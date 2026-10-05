import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/primary_button.dart';
import '../../demo/demo_controller.dart';
import 'widgets/destination_input.dart';
import 'widgets/optimization_selector.dart';
import 'widgets/vehicle_selector.dart';

class JourneyScreen extends StatelessWidget {
  final DemoController demoController;
  final VoidCallback onAnalyzePressed;

  const JourneyScreen({
    super.key,
    required this.demoController,
    required this.onAnalyzePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: demoController,
      builder: (context, _) {
        final ctrl = demoController;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Journey Planner'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surfaceCard,
                      title: const Text('Edge Route Optimizer'),
                      content: const Text(
                        'NexusDrive AI processes multiple local route candidates on-device. Evaluates elevation profiles, traffic multipliers, and cellular deadzones entirely offline.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK', style: TextStyle(color: AppColors.cyanAccent)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DestinationInput(
                  selectedDestination: ctrl.selectedDestination,
                  onDestinationChanged: (dest) => ctrl.setDestination(dest),
                ),
                const SizedBox(height: 14),
                VehicleSelector(
                  selectedVehicle: ctrl.selectedVehicle,
                  onVehicleSelected: (veh) => ctrl.setVehicle(veh),
                ),
                const SizedBox(height: 14),
                OptimizationSelector(
                  selectedPreference: ctrl.drivingPreference,
                  onPreferenceChanged: (pref) => ctrl.setDrivingPreference(pref),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Analyze Route with Edge AI',
                  icon: Icons.auto_awesome_rounded,
                  onPressed: onAnalyzePressed,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
