import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';

class BatteryRiskCard extends StatelessWidget {
  final double currentBatteryPercent;
  final double destinationDistanceKm;
  final double estimatedArrivalReserve;
  final bool isViolated;

  const BatteryRiskCard({
    super.key,
    required this.currentBatteryPercent,
    required this.destinationDistanceKm,
    required this.estimatedArrivalReserve,
    required this.isViolated,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      hasGlow: isViolated,
      glowColor: AppColors.batteryCritical,
      borderColor: isViolated ? AppColors.batteryCritical.withOpacity(0.8) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning_rounded, color: AppColors.batteryCritical, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'CRITICAL BATTERY ASSESSMENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.batteryCritical,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.batteryCritical.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'RESCUE MANDATORY',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.batteryCritical,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('CURRENT SOC', '${currentBatteryPercent.toStringAsFixed(0)}%', AppColors.batteryCritical),
              _buildDivider(),
              _buildMetric('DEST. DISTANCE', '${destinationDistanceKm.toStringAsFixed(1)} km', AppColors.textPrimary),
              _buildDivider(),
              _buildMetric(
                'ARRIVAL SOC',
                '${estimatedArrivalReserve.toStringAsFixed(1)}%',
                estimatedArrivalReserve < 15.0 ? AppColors.batteryCritical : AppColors.batteryWarning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Arrival reserve is projected below the 15% safety buffer. Continuing directly risks complete stranding. Route diverted via nearest fast charging station.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 26, color: AppColors.surfaceBorderSubtle);
  }
}
