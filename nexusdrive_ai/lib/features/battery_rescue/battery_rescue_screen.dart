import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/repositories/charging_repository.dart';
import '../../data/repositories/route_repository.dart';
import '../../demo/demo_controller.dart';
import '../../domain/services/battery_rescue_service.dart';
import 'widgets/battery_risk_card.dart';
import 'widgets/charging_fallback_card.dart';
import 'widgets/rescue_route_card.dart';

class BatteryRescueScreen extends StatefulWidget {
  final DemoController demoController;
  final RouteRepository routeRepository;
  final ChargingRepository chargingRepository;

  const BatteryRescueScreen({
    super.key,
    required this.demoController,
    required this.routeRepository,
    required this.chargingRepository,
  });

  @override
  State<BatteryRescueScreen> createState() => _BatteryRescueScreenState();
}

class _BatteryRescueScreenState extends State<BatteryRescueScreen> {
  bool _isLoading = true;
  BatteryRescuePlan? _rescuePlan;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _computeRescue();
    widget.demoController.addListener(_onDemoChanged);
  }

  @override
  void dispose() {
    widget.demoController.removeListener(_onDemoChanged);
    super.dispose();
  }

  void _onDemoChanged() {
    if (mounted) {
      _computeRescue();
    }
  }

  Future<void> _computeRescue() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ctrl = widget.demoController;
      final telemetry = ctrl.activeTelemetry;
      final routes = await widget.routeRepository.getRoutesForDestination(ctrl.selectedDestination);
      if (routes.isEmpty) {
        throw Exception('No routes found for destination');
      }

      final rescueService = BatteryRescueService(chargingRepository: widget.chargingRepository);
      final plan = await rescueService.computeRescuePlan(
        currentLatitude: telemetry.latitude,
        currentLongitude: telemetry.longitude,
        currentBatteryPercent: telemetry.batteryPercentage,
        batteryCapacityKwh: ctrl.selectedVehicle.batteryCapacityKwh,
        originalRoute: routes.first,
      );

      if (mounted) {
        setState(() {
          _rescuePlan = plan;
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

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: AppColors.batteryCritical, size: 20),
            SizedBox(width: 8),
            Text('Battery Rescue Copilot'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.batteryCritical),
                  SizedBox(height: 16),
                  Text('Auditing local charging hubs & computing rescue route...', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(_errorMessage!, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              : _rescuePlan == null
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Critical Battery Assessment Card
                          BatteryRiskCard(
                            currentBatteryPercent: telemetry.batteryPercentage,
                            destinationDistanceKm: _rescuePlan!.recalculatedRoute.distanceKm,
                            estimatedArrivalReserve: _rescuePlan!.recalculatedRoute.estimatedArrivalReserve,
                            isViolated: telemetry.batteryPercentage < 20.0,
                          ),
                          const SizedBox(height: 16),

                          // Recalculated Rescue Trajectory
                          RescueRouteCard(
                            route: _rescuePlan!.recalculatedRoute,
                          ),
                          const SizedBox(height: 16),

                          // Ranked Charging Fallbacks
                          const Text(
                            'RECOMMENDED CHARGING FALLBACKS (OFFLINE LOCAL HUB)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._rescuePlan!.candidateStations.map((station) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ChargingFallbackCard(
                                station: station,
                                distanceKm: _rescuePlan!.distanceToStationKm,
                                chargeTimeMinutes: _rescuePlan!.estimatedChargeTimeMinutes,
                                batteryAtStationPercent: _rescuePlan!.estimatedBatteryAtStation,
                                isSelected: station.id == _rescuePlan!.recommendedStation.id,
                                onSelect: () {},
                              ),
                            );
                          }),

                          const SizedBox(height: 20),
                          PrimaryButton(
                            label: 'Accept Rescue Route & Divert',
                            icon: Icons.alt_route_rounded,
                            backgroundColor: AppColors.batteryCritical,
                            foregroundColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Battery Rescue Active: Navigating to ${_rescuePlan!.recommendedStation.name}'),
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
}
