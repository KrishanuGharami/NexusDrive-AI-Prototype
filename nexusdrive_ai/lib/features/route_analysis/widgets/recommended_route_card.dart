import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/route.dart';

class RecommendedRouteCard extends StatelessWidget {
  final RouteEntity route;
  final VoidCallback? onStartNav;

  const RecommendedRouteCard({
    super.key,
    required this.route,
    this.onStartNav,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      hasGlow: true,
      glowColor: AppColors.cyanAccent,
      borderColor: AppColors.cyanAccent.withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyanAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars_rounded, color: AppColors.textInverse, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'AI RECOMMENDED',
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
              Row(
                children: [
                  const Text('MATCH SCORE ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                  Text(
                    '${(route.totalScore * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            route.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            route.roadGradeDescription,
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),
          // Core Metrics Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: Icons.schedule_rounded,
                  label: 'DURATION',
                  value: DistanceUtils.formatDurationMinutes(route.estimatedTimeMinutes),
                  color: AppColors.textPrimary,
                ),
                _buildDivider(),
                _buildMetric(
                  icon: Icons.straighten_rounded,
                  label: 'DISTANCE',
                  value: '${route.distanceKm} km',
                  color: AppColors.textPrimary,
                ),
                _buildDivider(),
                _buildMetric(
                  icon: Icons.battery_charging_full_rounded,
                  label: 'ARRIVAL SOC',
                  value: '${route.estimatedArrivalReserve.toStringAsFixed(0)}%',
                  color: route.estimatedArrivalReserve >= 20 ? AppColors.batterySafe : AppColors.batteryCritical,
                ),
                _buildDivider(),
                _buildMetric(
                  icon: Icons.bolt_rounded,
                  label: 'ENERGY',
                  value: '${(route.baseEnergyKwh * route.trafficCongestionMultiplier).toStringAsFixed(1)} kWh',
                  color: AppColors.cyanAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Cellular & Fallback Tags
          Row(
            children: [
              _buildTag(
                icon: Icons.network_cell_rounded,
                text: 'Cellular: ${(route.connectivityReliability * 100).toInt()}%',
                color: route.connectivityReliability >= 0.75 ? AppColors.batterySafe : AppColors.batteryWarning,
              ),
              const SizedBox(width: 8),
              _buildTag(
                icon: Icons.ev_station_rounded,
                text: '${route.fallbackChargerIds.length} Charging Fallbacks',
                color: AppColors.electricBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.surfaceBorderSubtle,
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
