import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/primary_button.dart';
import '../../demo/demo_controller.dart';
import '../../domain/entities/route.dart';
import '../../services/ai/edge_inference_engine.dart';
import '../../services/ai/explanation_service.dart';
import '../../services/ai/route_ai_service.dart';
import '../../services/office_kit/office_kit_bridge.dart';
import 'widgets/recommended_route_card.dart';
import 'widgets/route_comparison_card.dart';
import 'widgets/route_explanation_card.dart';

class RouteAnalysisScreen extends StatefulWidget {
  final DemoController demoController;
  final RouteAiService routeAiService;
  final OfficeKitBridge officeKitBridge;
  final VoidCallback onOpenBatteryRescue;

  const RouteAnalysisScreen({
    super.key,
    required this.demoController,
    required this.routeAiService,
    required this.officeKitBridge,
    required this.onOpenBatteryRescue,
  });

  @override
  State<RouteAnalysisScreen> createState() => _RouteAnalysisScreenState();
}

class _RouteAnalysisScreenState extends State<RouteAnalysisScreen> {
  bool _isLoading = true;
  RouteRecommendation? _recommendation;
  RouteEntity? _selectedRoute;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _runAnalysis();
    widget.demoController.addListener(_onDemoControllerChanged);
  }

  @override
  void dispose() {
    widget.demoController.removeListener(_onDemoControllerChanged);
    super.dispose();
  }

  void _onDemoControllerChanged() {
    if (mounted) {
      _runAnalysis();
    }
  }

  Future<void> _runAnalysis() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ctrl = widget.demoController;
      final recommendation = await widget.routeAiService.analyzeRoutesForDestination(
        destination: ctrl.selectedDestination,
        telemetry: ctrl.activeTelemetry,
        batteryCapacityKwh: ctrl.selectedVehicle.batteryCapacityKwh,
        drivingPreference: ctrl.drivingPreference,
      );

      if (mounted) {
        setState(() {
          _recommendation = recommendation;
          _selectedRoute = recommendation.recommendedRoute;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.demoController;
    final telemetry = ctrl.activeTelemetry;
    final isCriticalBattery = telemetry.batteryPercentage < AppConstants.batteryRescueThresholdPercent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edge AI Route Analysis'),
        actions: [
          // Office Kit Big Screen Sync Button
          IconButton(
            tooltip: 'Sync via Office Kit to PC Screen',
            icon: const Icon(Icons.cast_connected_rounded, color: AppColors.cyanAccent),
            onPressed: () => _syncToOfficeKit(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _runAnalysis,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.cyanAccent),
                  SizedBox(height: 16),
                  Text('Evaluating local route tensors on-device...', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.batteryCritical, size: 48),
                        const SizedBox(height: 12),
                        Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: 'Retry Evaluation',
                          onPressed: _runAnalysis,
                          isFullWidth: false,
                        ),
                      ],
                    ),
                  ),
                )
              : _recommendation == null
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Edge AI Header Badge
                          _buildEdgeHeader(),
                          const SizedBox(height: 10),
                          _buildQuickSimulationBar(ctrl),
                          const SizedBox(height: 12),

                          // If battery is critical, warn and offer one-tap rescue divert
                          if (isCriticalBattery || (_selectedRoute != null && !_selectedRoute!.isSafe)) ...[
                            _buildCriticalBatteryBanner(),
                            const SizedBox(height: 14),
                          ],

                          // Top Recommended Route Card
                          RecommendedRouteCard(
                            route: _recommendation!.recommendedRoute,
                          ),
                          const SizedBox(height: 14),

                          // "WHY THIS ROUTE?" Explanation Card
                          RouteExplanationCard(
                            route: _selectedRoute ?? _recommendation!.recommendedRoute,
                            telemetry: telemetry,
                            explanationService: ExplanationService(),
                          ),
                          const SizedBox(height: 16),

                          // Candidate Routes Comparison
                          const Text(
                            'ALL CANDIDATE ROUTES (OFFLINE EVALUATED)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._buildAllCandidateCards(),

                          const SizedBox(height: 20),
                          PrimaryButton(
                            label: 'Start Navigation with Active Edge Guard',
                            icon: Icons.navigation_rounded,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Navigation active: Offline Edge Guard monitoring ${_selectedRoute?.title}'),
                                  backgroundColor: AppColors.surfaceElevated,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildEdgeHeader() {
    final rec = _recommendation!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBorderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.offline_bolt_rounded, size: 14, color: AppColors.cyanAccent),
              const SizedBox(width: 6),
              Text(
                'LATENCY: ${rec.inferenceLatencyMs}ms (ZERO CLOUD)',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyanAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Text(
            'CONFIDENCE: ${(rec.confidenceScore * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.batterySafe,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSimulationBar(DemoController ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBorderSubtle),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.science_rounded, size: 14, color: AppColors.batteryWarning),
            const SizedBox(width: 6),
            const Text(
              'TEST SoC:',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary),
            ),
            const SizedBox(width: 8),
            ...[80.0, 50.0, 25.0, 15.0].map((pct) {
              final isSel = ctrl.selectedBatteryPercent == pct;
              return Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: InkWell(
                  onTap: () {
                    ctrl.setDemoMode(true);
                    ctrl.setBatteryPercent(pct);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSel
                          ? (pct <= 20 ? AppColors.batteryCritical : AppColors.cyanAccent).withOpacity(0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSel
                            ? (pct <= 20 ? AppColors.batteryCritical : AppColors.cyanAccent)
                            : AppColors.surfaceBorderSubtle,
                        width: isSel ? 1.2 : 0.8,
                      ),
                    ),
                    child: Text(
                      '${pct.toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSel
                            ? (pct <= 20 ? AppColors.batteryCritical : AppColors.cyanAccent)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                ctrl.setDemoMode(true);
                final isOff = ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline');
                ctrl.setConnectivity(isOff ? 'Good (5G-SA)' : 'Poor / Deadzone (Offline Edge)');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                      ? AppColors.offlineChip.withOpacity(0.25)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                        ? AppColors.cyanAccent
                        : AppColors.surfaceBorderSubtle,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                          ? Icons.cloud_off_rounded
                          : Icons.cloud_done_rounded,
                      size: 11,
                      color: (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                          ? AppColors.cyanAccent
                          : AppColors.batterySafe,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                          ? 'OFFLINE AIRGAP'
                          : '5G LINK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: (ctrl.selectedConnectivity.contains('Poor') || ctrl.selectedConnectivity.contains('Offline'))
                            ? AppColors.cyanAccent
                            : AppColors.batterySafe,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalBatteryBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.batteryCritical.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.batteryCritical.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.battery_alert_rounded, color: AppColors.batteryCritical, size: 24),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Battery safety threshold compromised. Divert to charger fallback recommended.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.batteryCritical),
            ),
          ),
          ElevatedButton(
            onPressed: widget.onOpenBatteryRescue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.batteryCritical,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: const Text('RESCUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllCandidateCards() {
    final allRoutes = [
      _recommendation!.recommendedRoute,
      ..._recommendation!.alternativeRoutes,
    ];

    return allRoutes.map((r) {
      final isSelected = _selectedRoute?.id == r.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RouteComparisonCard(
          route: r,
          isSelected: isSelected,
          onSelect: () {
            setState(() {
              _selectedRoute = r;
            });
          },
        ),
      );
    }).toList();
  }

  void _syncToOfficeKit(BuildContext context) async {
    final route = _selectedRoute ?? _recommendation?.recommendedRoute;
    if (route == null) return;

    final ok = await widget.officeKitBridge.broadcastRouteToPresentationScreen(
      route: route,
      telemetry: widget.demoController.activeTelemetry,
    );

    if (context.mounted && ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Office Kit: Route telemetry synced to ${widget.officeKitBridge.pairedDevice.deviceName} (Unified Clipboard Ready)'),
          backgroundColor: AppColors.surfaceElevated,
        ),
      );
    }
  }
}
