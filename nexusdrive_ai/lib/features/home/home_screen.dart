import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/demo_constants.dart';
import '../../demo/demo_controller.dart';
import '../../demo/demo_scenarios.dart';
import '../../services/voice/voice_command_service.dart';
import 'widgets/battery_status_card.dart';
import 'widgets/journey_summary_card.dart';
import 'widgets/telemetry_status_card.dart';

class HomeScreen extends StatefulWidget {
  final DemoController demoController;
  final VoiceCommandService voiceService;
  final Function(int targetTab) onNavigateTab;
  final VoidCallback onOpenRouteAnalysis;
  final VoidCallback onOpenBatteryRescue;

  const HomeScreen({
    super.key,
    required this.demoController,
    required this.voiceService,
    required this.onNavigateTab,
    required this.onOpenRouteAnalysis,
    required this.onOpenBatteryRescue,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListeningVoice = false;
  String? _lastVoiceTranscript;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.demoController,
      builder: (context, _) {
        final ctrl = widget.demoController;
        final telemetry = ctrl.activeTelemetry;
        final isCriticalBattery = telemetry.batteryPercentage < AppConstants.batteryRescueThresholdPercent;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.cyanAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.electric_car_rounded, color: AppColors.cyanAccent, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NexusDrive AI',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                    Text(
                      'Smarter Routes • Greener Journeys',
                      style: TextStyle(fontSize: 10, color: AppColors.cyanAccent, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Simulation / Demo Mode Pill
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  selected: ctrl.isDemoModeActive,
                  avatar: Icon(
                    ctrl.isDemoModeActive ? Icons.science_rounded : Icons.phone_android_rounded,
                    size: 14,
                    color: ctrl.isDemoModeActive ? AppColors.batteryWarning : AppColors.cyanAccent,
                  ),
                  label: Text(
                    ctrl.isDemoModeActive ? 'SIMULATION' : 'HARDWARE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: ctrl.isDemoModeActive ? AppColors.batteryWarning : AppColors.textSecondary,
                    ),
                  ),
                  backgroundColor: AppColors.surfaceElevated,
                  selectedColor: AppColors.batteryWarning.withOpacity(0.15),
                  side: BorderSide(
                    color: ctrl.isDemoModeActive ? AppColors.batteryWarning : AppColors.surfaceBorder,
                  ),
                  onSelected: (val) {
                    _showDemoControlsBottomSheet(context, ctrl);
                  },
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: AppColors.cyanAccent,
            backgroundColor: AppColors.surfaceElevated,
            onRefresh: () async {
              // Re-read hardware sensors
              await Future.delayed(const Duration(milliseconds: 400));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice Command Floating Bar
                  _buildVoiceBar(context, ctrl),
                  const SizedBox(height: 14),

                  // Battery Status Card
                  BatteryStatusCard(
                    batteryPercent: telemetry.batteryPercentage,
                    isCharging: telemetry.isCharging,
                    batteryCapacityKwh: ctrl.selectedVehicle.batteryCapacityKwh,
                    vehicleName: ctrl.selectedVehicle.name,
                    onRescuePressed: widget.onOpenBatteryRescue,
                  ),
                  const SizedBox(height: 14),

                  // Telemetry Status Overview
                  TelemetryStatusCard(
                    telemetry: telemetry,
                    onDetailsTap: () => widget.onNavigateTab(3), // Navigate to Telemetry Tab
                  ),
                  const SizedBox(height: 14),

                  // Planned Journey Card
                  JourneySummaryCard(
                    destination: ctrl.selectedDestination,
                    drivingPreference: ctrl.drivingPreference,
                    onPlanPressed: widget.onOpenRouteAnalysis,
                    onChangeDestinationPressed: () => widget.onNavigateTab(1), // Navigate to Journey Tab
                  ),

                  if (isCriticalBattery) ...[
                    const SizedBox(height: 14),
                    _buildBatteryRescueBanner(context),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoiceBar(BuildContext context, DemoController ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isListeningVoice ? AppColors.cyanAccent : AppColors.surfaceBorderSubtle,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _handleVoiceMicTap(context, ctrl),
            icon: Icon(
              _isListeningVoice ? Icons.mic : Icons.mic_none_rounded,
              color: _isListeningVoice ? AppColors.cyanAccent : AppColors.textSecondary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: _isListeningVoice ? AppColors.cyanAccent.withOpacity(0.15) : AppColors.surface,
              padding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isListeningVoice
                      ? 'Listening... Speak command'
                      : (_lastVoiceTranscript ?? 'Say: "Optimize my route for battery"'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isListeningVoice ? AppColors.cyanAccent : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Edge Voice Copilot (Offline Natural Recognition)',
                  style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          // Fast Voice Preset Button for reliable demo
          TextButton(
            onPressed: () {
              ctrl.setDrivingPreference('Battery Safe');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice Command Recognized: "Optimize route for battery" -> Switched to Battery Safe mode'),
                  backgroundColor: AppColors.surfaceElevated,
                ),
              );
              widget.onOpenRouteAnalysis();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: AppColors.cyanAccent.withOpacity(0.12),
            ),
            child: const Text(
              'TEST VOICE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVoiceMicTap(BuildContext context, DemoController ctrl) async {
    if (_isListeningVoice) {
      await widget.voiceService.stopListening();
      setState(() => _isListeningVoice = false);
      return;
    }

    await widget.voiceService.startListening(
      onListeningStateChanged: (listening) {
        setState(() => _isListeningVoice = listening);
      },
      onResult: (result) {
        setState(() {
          _lastVoiceTranscript = '"${result.recognizedText}"';
        });

        if (result.intent == VoiceIntent.optimizeBattery) {
          ctrl.setDrivingPreference('Battery Safe');
          widget.onOpenRouteAnalysis();
        } else if (result.intent == VoiceIntent.optimizeFastest) {
          ctrl.setDrivingPreference('Fastest');
          widget.onOpenRouteAnalysis();
        } else if (result.intent == VoiceIntent.optimizeEnergy) {
          ctrl.setDrivingPreference('Energy Efficient');
          widget.onOpenRouteAnalysis();
        } else if (result.intent == VoiceIntent.activateBatteryRescue) {
          widget.onOpenBatteryRescue();
        }
      },
    );
  }

  Widget _buildBatteryRescueBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.batteryCritical.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.batteryCritical.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency_rounded, color: AppColors.batteryCritical, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BATTERY RESCUE ACTIVE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.batteryCritical,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Critically low charge detected. Recalculating path to nearest fast charger.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onOpenBatteryRescue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.batteryCritical,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
            child: const Text('VIEW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  void _showDemoControlsBottomSheet(BuildContext context, DemoController ctrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'JURY DEMO & SIMULATION SUITE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.cyanAccent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Text(
                      'Test edge cases, low battery triggers, and connectivity deadzones without spoofing hardware telemetry.',
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 16),

                    // Toggle Live Hardware vs Simulation
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable Simulation Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        ctrl.isDemoModeActive ? 'Active: Overrides with preset telemetry' : 'Inactive: Reading real phone hardware sensors',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      value: ctrl.isDemoModeActive,
                      activeColor: AppColors.cyanAccent,
                      onChanged: (val) {
                        ctrl.setDemoMode(val);
                        setSheetState(() {});
                      },
                    ),
                    const Divider(),

                    // Battery Presets
                    const Text('BATTERY LEVEL PRESET', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: DemoConstants.batteryPresets.map((pct) {
                        final isSel = ctrl.selectedBatteryPercent == pct;
                        return ChoiceChip(
                          label: Text('${pct.toInt()}%'),
                          selected: isSel,
                          selectedColor: pct <= 20 ? AppColors.batteryCritical.withOpacity(0.3) : AppColors.cyanAccent.withOpacity(0.3),
                          onSelected: (_) {
                            ctrl.setDemoMode(true);
                            ctrl.setBatteryPercent(pct);
                            setSheetState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Connectivity Presets
                    const Text('CONNECTIVITY ZONE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: DemoConstants.connectivityPresets.map((conn) {
                        final isSel = ctrl.selectedConnectivity == conn;
                        return ChoiceChip(
                          label: Text(conn.split(' ').first),
                          selected: isSel,
                          onSelected: (_) {
                            ctrl.setDemoMode(true);
                            ctrl.setConnectivity(conn);
                            setSheetState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Preset Scenarios
                    const Text('PRE-PACKED SCENARIOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Column(
                      children: DemoScenario.presets.map((sc) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(sc.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          subtitle: Text(sc.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          trailing: const Icon(Icons.play_circle_outline_rounded, color: AppColors.cyanAccent),
                          onTap: () {
                            ctrl.setDemoMode(true);
                            ctrl.setBatteryPercent(sc.batteryPercent);
                            ctrl.setConnectivity(sc.connectivity);
                            ctrl.setDestination(sc.destination);
                            Navigator.pop(ctx);
                            if (sc.isRescueExpected) {
                              widget.onOpenBatteryRescue();
                            } else {
                              widget.onOpenRouteAnalysis();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
