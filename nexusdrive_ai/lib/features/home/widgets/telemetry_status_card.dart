import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../core/widgets/status_indicator.dart';
import '../../../domain/entities/telemetry.dart';

class TelemetryStatusCard extends StatelessWidget {
  final TelemetryEntity telemetry;
  final VoidCallback? onDetailsTap;

  const TelemetryStatusCard({
    super.key,
    required this.telemetry,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sensors_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'PHONE EDGE TELEMETRY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              if (telemetry.isSimulated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.batteryWarning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.batteryWarning.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'SIMULATION OVERRIDE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.batteryWarning,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.batterySafe,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'LIVE HARDWARE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.batterySafe,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusIndicator(
                label: 'Edge AI Layer',
                status: 'ON-DEVICE INT8',
                icon: Icons.memory_rounded,
                activeColor: AppColors.cyanAccent,
                isHighlight: true,
              ),
              StatusIndicator(
                label: 'Offline Engine',
                status: 'LOCAL EMBEDDED',
                icon: Icons.offline_pin_rounded,
                activeColor: AppColors.offlineChip,
              ),
              StatusIndicator(
                label: 'GPS Hardware',
                status: telemetry.gpsStatus.split(' ').first,
                icon: Icons.gps_fixed_rounded,
                activeColor: telemetry.gpsStatus.contains('LOCKED') ? AppColors.batterySafe : AppColors.batteryWarning,
              ),
              StatusIndicator(
                label: 'Motion Sensor',
                status: telemetry.motionActivity,
                icon: Icons.speed_rounded,
                activeColor: AppColors.electricBlue,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lat: ${telemetry.latitude.toStringAsFixed(4)}  Lon: ${telemetry.longitude.toStringAsFixed(4)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: AppColors.textTertiary,
                ),
              ),
              InkWell(
                onTap: onDetailsTap,
                child: const Row(
                  children: [
                    Text(
                      'Diagnostics',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cyanAccent,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.cyanAccent),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
