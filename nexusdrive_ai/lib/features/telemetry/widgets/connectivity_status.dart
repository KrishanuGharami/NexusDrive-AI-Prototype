import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/telemetry.dart';

class TelemetryConnectivityCard extends StatelessWidget {
  final TelemetryEntity telemetry;

  const TelemetryConnectivityCard({super.key, required this.telemetry});

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
                  Icon(Icons.network_cell_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'CONNECTIVITY & OFFLINE EDGE AIRGAP',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: telemetry.isOffline
                      ? AppColors.offlineChip.withOpacity(0.2)
                      : AppColors.batterySafe.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  telemetry.isOffline ? 'OFFLINE SECURE' : 'CELLULAR CONNECTED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: telemetry.isOffline ? AppColors.cyanAccent : AppColors.batterySafe,
                  ),
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
                    telemetry.networkType,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const Text('SIGNAL INTERFACE', style: TextStyle(fontSize: 9, color: AppColors.textTertiary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(telemetry.signalStrength * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: telemetry.signalStrength < 0.3 ? AppColors.batteryCritical : AppColors.batterySafe,
                    ),
                  ),
                  const Text('LINK QUALITY', style: TextStyle(fontSize: 9, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.storage_rounded, size: 16, color: AppColors.cyanAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Local Cache: 9 Routes • 8 Fast Charging Plazas • 6 Cellular Deadzones (Embedded JSON)',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
