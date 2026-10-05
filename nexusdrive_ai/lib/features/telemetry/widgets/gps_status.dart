import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/telemetry.dart';

class TelemetryGpsCard extends StatelessWidget {
  final TelemetryEntity telemetry;

  const TelemetryGpsCard({super.key, required this.telemetry});

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
                  Icon(Icons.gps_fixed_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'GPS / GNSS POSITIONING ENGINE',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.batterySafe.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  telemetry.gpsStatus,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.batterySafe),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCoordCol('LATITUDE', telemetry.latitude.toStringAsFixed(6)),
              _buildCoordCol('LONGITUDE', telemetry.longitude.toStringAsFixed(6)),
              _buildCoordCol('ALTITUDE', '${telemetry.altitudeMeters.toStringAsFixed(0)} m'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Speed: ${telemetry.speedKmh.toStringAsFixed(1)} km/h',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              Text(
                'Horizontal Accuracy: ±${telemetry.gpsAccuracyMeters.toStringAsFixed(1)}m',
                style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'monospace', color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
      ],
    );
  }
}
