import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/telemetry.dart';

class TelemetryMotionCard extends StatelessWidget {
  final TelemetryEntity telemetry;

  const TelemetryMotionCard({super.key, required this.telemetry});

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.vibration_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'IMU & ACCELEROMETER DYNAMICS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  telemetry.motionActivity,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.electricBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAxis('X (Lateral)', '${telemetry.accelX.toStringAsFixed(2)} m/s²'),
              _buildAxis('Y (Longitudinal)', '${telemetry.accelY.toStringAsFixed(2)} m/s²'),
              _buildAxis('Z (Vertical)', '${telemetry.accelZ.toStringAsFixed(2)} m/s²'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Dynamic kinetic tracking enables grade & regenerative deceleration estimation without relying on cloud servers.',
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildAxis(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, fontFamily: 'monospace', color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
      ],
    );
  }
}
