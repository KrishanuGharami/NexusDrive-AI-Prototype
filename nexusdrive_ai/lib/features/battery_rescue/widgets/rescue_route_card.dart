import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/route.dart';

class RescueRouteCard extends StatelessWidget {
  final RouteEntity route;

  const RescueRouteCard({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      hasGlow: true,
      glowColor: AppColors.batterySafe,
      borderColor: AppColors.batterySafe.withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.batterySafe,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.alt_route_rounded, color: AppColors.textInverse, size: 14),
                SizedBox(width: 4),
                Text(
                  'RECALCULATED RESCUE TRAJECTORY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textInverse,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            route.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            route.explanation,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Recalculated metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('REVISED DISTANCE', '${route.distanceKm} km'),
              _buildDivider(),
              _buildMetric('TOTAL DURATION', DistanceUtils.formatDurationMinutes(route.estimatedTimeMinutes)),
              _buildDivider(),
              _buildMetric('SECURED RESERVE', '${route.estimatedArrivalReserve.toStringAsFixed(0)}%', color: AppColors.batterySafe),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'WAYPOINTS TRAVERSED',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Column(
            children: route.waypoints.map((wp) {
              final isCharger = wp.contains('⚡');
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    Icon(
                      isCharger ? Icons.ev_station_rounded : Icons.fiber_manual_record_rounded,
                      size: isCharger ? 16 : 8,
                      color: isCharger ? AppColors.cyanAccent : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        wp,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCharger ? FontWeight.w700 : FontWeight.w500,
                          color: isCharger ? AppColors.cyanAccent : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, {Color color = AppColors.textPrimary}) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24, color: AppColors.surfaceBorderSubtle);
  }
}
