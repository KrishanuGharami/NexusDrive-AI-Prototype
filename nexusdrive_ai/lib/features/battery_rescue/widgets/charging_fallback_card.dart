import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/charging_station.dart';

class ChargingFallbackCard extends StatelessWidget {
  final ChargingStation station;
  final double distanceKm;
  final int chargeTimeMinutes;
  final double batteryAtStationPercent;
  final bool isSelected;
  final VoidCallback onSelect;

  const ChargingFallbackCard({
    super.key,
    required this.station,
    required this.distanceKm,
    required this.chargeTimeMinutes,
    required this.batteryAtStationPercent,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      onTap: onSelect,
      borderColor: isSelected ? AppColors.batterySafe : AppColors.surfaceBorder,
      backgroundColor: isSelected ? AppColors.batterySafe.withOpacity(0.06) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.batterySafe.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 12, color: AppColors.batterySafe),
                    const SizedBox(width: 4),
                    Text(
                      '${station.powerKw.toInt()} kW DC FAST',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.batterySafe),
                    ),
                  ],
                ),
              ),
              Text(
                '${distanceKm.toStringAsFixed(1)} km away',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.cyanAccent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            station.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            station.address,
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('PORTS OPEN', '${station.availablePorts}/${station.totalPorts}', AppColors.textPrimary),
                _buildStat('EST. CHARGE', '$chargeTimeMinutes min', AppColors.cyanAccent),
                _buildStat('SOC ON ARRIVAL', '${batteryAtStationPercent.toStringAsFixed(0)}%', AppColors.batterySafe),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 1),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
      ],
    );
  }
}
