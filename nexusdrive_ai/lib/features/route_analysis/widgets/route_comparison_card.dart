import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/route.dart';

class RouteComparisonCard extends StatelessWidget {
  final RouteEntity route;
  final bool isSelected;
  final VoidCallback onSelect;

  const RouteComparisonCard({
    super.key,
    required this.route,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      onTap: onSelect,
      borderColor: isSelected ? AppColors.cyanAccent : AppColors.surfaceBorder,
      backgroundColor: isSelected ? AppColors.cyanAccent.withOpacity(0.06) : null,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRouteTypeColor(route.routeType).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  route.routeType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _getRouteTypeColor(route.routeType),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Row(
                children: [
                  const Text('Score: ', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                  Text(
                    '${(route.totalScore * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.cyanAccent : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            route.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          // Comparison Key Points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricChip(
                icon: Icons.schedule_rounded,
                text: DistanceUtils.formatDurationMinutes(route.estimatedTimeMinutes),
              ),
              _buildMetricChip(
                icon: Icons.straighten_rounded,
                text: '${route.distanceKm} km',
              ),
              _buildMetricChip(
                icon: Icons.battery_charging_full_rounded,
                text: '${route.estimatedArrivalReserve.toStringAsFixed(0)}% reserve',
                color: route.estimatedArrivalReserve < 15.0 ? AppColors.batteryCritical : null,
              ),
              _buildMetricChip(
                icon: Icons.network_cell_rounded,
                text: '${(route.connectivityReliability * 100).toInt()}% cell',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRouteTypeColor(String type) {
    if (type.contains('Energy')) return AppColors.batterySafe;
    if (type.contains('Fast')) return AppColors.batteryWarning;
    if (type.contains('Connectivity')) return AppColors.offlineChip;
    return AppColors.cyanAccent;
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final fg = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: fg),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
        ),
      ],
    );
  }
}
