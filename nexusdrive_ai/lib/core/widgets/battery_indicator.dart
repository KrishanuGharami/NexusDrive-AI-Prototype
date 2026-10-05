import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/battery_utils.dart';

class BatteryIndicator extends StatelessWidget {
  final double percentage;
  final bool isCharging;
  final double? estimatedRangeKm;
  final bool showRange;
  final double height;

  const BatteryIndicator({
    super.key,
    required this.percentage,
    this.isCharging = false,
    this.estimatedRangeKm,
    this.showRange = true,
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = BatteryUtils.getStatusColor(percentage);
    final clampedPercent = percentage.clamp(0.0, 100.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Row(
              children: [
                Icon(
                  isCharging
                      ? Icons.bolt_rounded
                      : (clampedPercent <= 20
                          ? Icons.battery_alert_rounded
                          : Icons.battery_charging_full_rounded),
                  color: statusColor,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  '${clampedPercent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                    letterSpacing: -0.5,
                  ),
                ),
                if (isCharging) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.cyanAccent, width: 0.8),
                    ),
                    child: const Text(
                      'CHARGING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cyanAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (showRange && estimatedRangeKm != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${estimatedRangeKm!.toStringAsFixed(0)} km',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'EST. RANGE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            color: AppColors.surfaceElevated,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedPercent / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.8),
                      statusColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
