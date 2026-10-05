import '../../domain/entities/route.dart';
import '../../domain/entities/telemetry.dart';

class RouteScoreFactor {
  final String title;
  final double score; // 0.0 to 1.0
  final double weight;
  final String description;
  final bool isAdvantage;

  const RouteScoreFactor({
    required this.title,
    required this.score,
    required this.weight,
    required this.description,
    required this.isAdvantage,
  });

  double get contribution => score * weight;
}

class ExplanationService {
  List<RouteScoreFactor> generateFactorBreakdown(RouteEntity route, TelemetryEntity telemetry) {
    return [
      RouteScoreFactor(
        title: 'Energy Efficiency (35%)',
        score: route.energyEfficiencyScore,
        weight: 0.35,
        description: 'Estimated consumption ${(route.baseEnergyKwh * route.trafficCongestionMultiplier).toStringAsFixed(1)} kWh with ${route.elevationLossMeters.toInt()}m regen gain.',
        isAdvantage: route.energyEfficiencyScore >= 0.7,
      ),
      RouteScoreFactor(
        title: 'Battery Safety (25%)',
        score: route.batterySafetyScore,
        weight: 0.25,
        description: 'Projected arrival SoC of ${route.estimatedArrivalReserve.toStringAsFixed(1)}% vs 15% safety minimum.',
        isAdvantage: route.batterySafetyScore >= 0.7,
      ),
      RouteScoreFactor(
        title: 'Transit Duration (20%)',
        score: route.travelTimeScore,
        weight: 0.20,
        description: 'Estimated travel time ${route.estimatedTimeMinutes} min across ${route.distanceKm} km.',
        isAdvantage: route.travelTimeScore >= 0.7,
      ),
      RouteScoreFactor(
        title: 'Network Reliability (10%)',
        score: route.connectivityScore,
        weight: 0.10,
        description: '${(route.connectivityReliability * 100).toInt()}% coverage along telemetry corridors.',
        isAdvantage: route.connectivityScore >= 0.7,
      ),
      RouteScoreFactor(
        title: 'Charging Redundancy (10%)',
        score: route.chargingFallbackScore,
        weight: 0.10,
        description: '${route.fallbackChargerIds.length} DC Fast fallback hubs within immediate proximity.',
        isAdvantage: route.fallbackChargerIds.isNotEmpty,
      ),
    ];
  }
}
