import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/battery_utils.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/telemetry.dart';

class TelemetryBatteryCard extends StatelessWidget {
  final TelemetryEntity telemetry;

  const TelemetryBatteryCard({super.key, required this.telemetry});

  @override
  Widget build(BuildContext context) {
    final statusColor = BatteryUtils.getStatusColor(telemetry.batteryPercentage);

    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.battery_charging_full_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'ANDROID BATTERY SUBSYSTEM',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  telemetry.isCharging ? 'CHARGING' : 'DISCHARGING',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${telemetry.batteryPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: statusColor),
                  ),
                  const Text('STATE OF CHARGE (SoC)', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${telemetry.batteryTemperatureCelsius.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const Text('PACK TEMPERATURE', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
