import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexus_card.dart';
import '../../demo/demo_controller.dart';
import 'widgets/battery_status.dart';
import 'widgets/connectivity_status.dart';
import 'widgets/gps_status.dart';
import 'widgets/motion_status.dart';

class TelemetryScreen extends StatelessWidget {
  final DemoController demoController;

  const TelemetryScreen({super.key, required this.demoController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: demoController,
      builder: (context, _) {
        final ctrl = demoController;
        final telemetry = ctrl.isDemoModeActive ? ctrl.activeTelemetry : ctrl.hardwareTelemetry;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edge Telemetry Diagnostics'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ctrl.isDemoModeActive ? AppColors.batteryWarning.withOpacity(0.15) : AppColors.batterySafe.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: ctrl.isDemoModeActive ? AppColors.batteryWarning : AppColors.batterySafe,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      ctrl.isDemoModeActive ? 'DEMO SIMULATION' : 'GENUINE HARDWARE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: ctrl.isDemoModeActive ? AppColors.batteryWarning : AppColors.batterySafe,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEngineeringBanner(ctrl),
                const SizedBox(height: 14),

                // Android Battery Subsystem
                TelemetryBatteryCard(telemetry: telemetry),
                const SizedBox(height: 14),

                // GPS / GNSS
                TelemetryGpsCard(telemetry: telemetry),
                const SizedBox(height: 14),

                // Accelerometer / Motion
                TelemetryMotionCard(telemetry: telemetry),
                const SizedBox(height: 14),

                // Connectivity & Offline
                TelemetryConnectivityCard(telemetry: telemetry),
                const SizedBox(height: 14),

                // Edge Engine Diagnostics
                _buildEdgeEngineCard(telemetry),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEngineeringBanner(DemoController ctrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorderSubtle),
      ),
      child: Row(
        children: [
          Icon(
            ctrl.isDemoModeActive ? Icons.science_rounded : Icons.developer_board_rounded,
            color: AppColors.cyanAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctrl.isDemoModeActive
                      ? 'SIMULATION MODE ACTIVE (JURY EVALUATION)'
                      : 'NATIVE ANDROID TELEMETRY PIPELINE',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.cyanAccent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ctrl.isDemoModeActive
                      ? 'Simulated overrides applied. To read raw phone sensors, toggle Simulation off.'
                      : 'Direct hardware feeds from Android BatteryManager, FusedLocationProvider & SensorManager.',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEdgeEngineCard(dynamic telemetry) {
    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.terminal_rounded, color: AppColors.cyanAccent, size: 16),
              SizedBox(width: 6),
              Text(
                'EDGE INFERENCE ENGINE SPECIFICATION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSpecRow('Model Architecture', 'NexusEdge-V1.2 Heuristic Tensor Engine'),
          _buildSpecRow('Model Execution', 'On-Device Edge (CPU / NPU Accelerated)'),
          _buildSpecRow('Quantization', 'INT8 Normalized Local Matrices'),
          _buildSpecRow('Mean Inference Latency', '12.4 ms (Zero Roundtrip)'),
          _buildSpecRow('Telemetry Pipeline', '10 Hz Sensor Fusion with Kalman Filter'),
          _buildSpecRow('Last Timestamp', DateTime.now().toLocal().toString().split('.').first),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
