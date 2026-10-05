import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/battery_utils.dart';
import '../../../core/widgets/battery_indicator.dart';
import '../../../core/widgets/nexus_card.dart';

class BatteryStatusCard extends StatelessWidget {
  final double batteryPercent;
  final bool isCharging;
  final double batteryCapacityKwh;
  final String vehicleName;
  final VoidCallback? onRescuePressed;

  const BatteryStatusCard({
    super.key,
    required this.batteryPercent,
    required this.isCharging,
    required this.batteryCapacityKwh,
    required this.vehicleName,
    this.onRescuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedRange = BatteryUtils.estimateRangeKm(
      batteryPercent: batteryPercent,
      batteryCapacityKwh: batteryCapacityKwh,
    );
    final risk = BatteryUtils.assessRisk(batteryPercent);
    final isCritical = risk == BatteryRiskLevel.critical;

    return NexusCard(
      hasGlow: isCritical,
      glowColor: AppColors.batteryCritical,
      borderColor: isCritical ? AppColors.batteryCritical.withOpacity(0.6) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.electric_car_rounded,
                      color: AppColors.cyanAccent,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    vehicleName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isCritical
                          ? AppColors.batteryCritical
                          : (batteryPercent < 30 ? AppColors.batteryWarning : AppColors.batterySafe))
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCritical ? 'CRITICAL RESERVE' : (batteryPercent < 30 ? 'ELEVATED RISK' : 'NOMINAL'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isCritical
                        ? AppColors.batteryCritical
                        : (batteryPercent < 30 ? AppColors.batteryWarning : AppColors.batterySafe),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BatteryIndicator(
            percentage: batteryPercent,
            isCharging: isCharging,
            estimatedRangeKm: estimatedRange,
            height: 10,
          ),
          if (isCritical) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.batteryCritical.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.batteryCritical.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.batteryCritical, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Battery < 20%: Immediate charging fallback recommended.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.batteryCritical,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onRescuePressed,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: AppColors.batteryCritical,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('RESCUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
