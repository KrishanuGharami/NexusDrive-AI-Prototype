import 'dart:math' as math;
import '../../core/constants/app_constants.dart';
import '../../core/utils/battery_utils.dart';
import '../entities/route.dart';

class RouteScoringService {
  /// Evaluates and scores candidate routes given current battery & vehicle parameters
  List<RouteEntity> scoreAndRankRoutes({
    required List<RouteEntity> candidates,
    required double currentBatteryPercent,
    required double batteryCapacityKwh,
    String drivingPreference = 'Energy Efficient',
  }) {
    if (candidates.isEmpty) return [];

    // Step 1: Compute adjusted energy required for each route
    final energies = candidates.map((r) => _computeAdjustedEnergy(r)).toList();
    final minEnergy = energies.reduce(math.min);
    final maxEnergy = energies.reduce(math.max);
    final energySpan = (maxEnergy - minEnergy) > 0.001 ? (maxEnergy - minEnergy) : 1.0;

    // Step 2: Compute travel times
    final times = candidates.map((r) => r.estimatedTimeMinutes.toDouble()).toList();
    final minTime = times.reduce(math.min);
    final maxTime = times.reduce(math.max);
    final timeSpan = (maxTime - minTime) > 0.001 ? (maxTime - minTime) : 1.0;

    // Step 3: Weights based on user driving preference
    final weights = _resolveWeights(drivingPreference, currentBatteryPercent);

    final scoredRoutes = <RouteEntity>[];

    for (int i = 0; i < candidates.length; i++) {
      final route = candidates[i];
      final energyRequired = energies[i];

      // 1. Energy Efficiency Score (lower energy = higher score)
      final energyEfficiencyScore = 1.0 - ((energyRequired - minEnergy) / energySpan);

      // 2. Battery Safety Score & Arrival Reserve
      final arrivalReserve = BatteryUtils.calculateArrivalReserve(
        currentBatteryPercent: currentBatteryPercent,
        energyRequiredKwh: energyRequired,
        batteryCapacityKwh: batteryCapacityKwh,
      );

      final isSafe = arrivalReserve >= AppConstants.minimumArrivalReservePercent;

      double batterySafetyScore;
      if (arrivalReserve <= 0) {
        batterySafetyScore = 0.0;
      } else if (arrivalReserve < AppConstants.batteryRescueThresholdPercent) {
        // High penalty for low reserve
        batterySafetyScore = (arrivalReserve / AppConstants.batteryRescueThresholdPercent) * 0.4;
      } else if (arrivalReserve < 35.0) {
        batterySafetyScore = 0.4 + ((arrivalReserve - AppConstants.batteryRescueThresholdPercent) / 15.0) * 0.4;
      } else {
        batterySafetyScore = 0.8 + math.min(0.2, (arrivalReserve - 35.0) / 50.0);
      }

      // 3. Travel Time Score (lower time = higher score)
      final travelTimeScore = 1.0 - ((route.estimatedTimeMinutes - minTime) / timeSpan);

      // 4. Connectivity Score
      final connectivityScore = route.connectivityReliability.clamp(0.0, 1.0);

      // 5. Charging Fallback Score (number of fallbacks available)
      final fallbackCount = route.fallbackChargerIds.length;
      final chargingFallbackScore = (fallbackCount >= 3 ? 1.0 : (fallbackCount * 0.35)).clamp(0.0, 1.0);

      // Total Weighted Score
      final totalScore = (weights.wEnergy * energyEfficiencyScore) +
          (weights.wBattery * batterySafetyScore) +
          (weights.wTime * travelTimeScore) +
          (weights.wConnectivity * connectivityScore) +
          (weights.wFallback * chargingFallbackScore);

      final roundedTotal = double.parse(totalScore.toStringAsFixed(3));

      scoredRoutes.add(
        route.copyWith(
          totalScore: roundedTotal,
          energyEfficiencyScore: double.parse(energyEfficiencyScore.toStringAsFixed(2)),
          batterySafetyScore: double.parse(batterySafetyScore.toStringAsFixed(2)),
          travelTimeScore: double.parse(travelTimeScore.toStringAsFixed(2)),
          connectivityScore: double.parse(connectivityScore.toStringAsFixed(2)),
          chargingFallbackScore: double.parse(chargingFallbackScore.toStringAsFixed(2)),
          estimatedArrivalReserve: arrivalReserve,
          isSafe: isSafe,
        ),
      );
    }

    // Step 4: Sort by totalScore descending
    scoredRoutes.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    // Mark the highest scoring route as recommended and generate its explanation
    final ranked = <RouteEntity>[];
    for (int i = 0; i < scoredRoutes.length; i++) {
      final isTop = i == 0;
      final r = scoredRoutes[i];
      final explanation = _generateRouteExplanation(r, isTop, currentBatteryPercent);
      ranked.add(r.copyWith(
        isRecommended: isTop,
        explanation: explanation,
      ));
    }

    return ranked;
  }

  double _computeAdjustedEnergy(RouteEntity route) {
    // Base energy * traffic congestion multiplier
    // + (elevationGain * 0.0004 kWh/m) - (elevationLoss * 0.00025 kWh/m for regen)
    final elevationNetEnergy = (route.elevationGainMeters * 0.0004) - (route.elevationLossMeters * 0.00025);
    final energy = (route.baseEnergyKwh * route.trafficCongestionMultiplier) + elevationNetEnergy;
    return math.max(0.5, energy);
  }

  _ScoringWeights _resolveWeights(String preference, double batteryPercent) {
    // Dynamic weight modulation: if battery is critical (< 25%), battery safety gets priority
    if (batteryPercent < 25.0) {
      return _ScoringWeights(
        wEnergy: 0.30,
        wBattery: 0.40,
        wTime: 0.10,
        wConnectivity: 0.10,
        wFallback: 0.10,
      );
    }

    switch (preference) {
      case 'Fastest':
        return _ScoringWeights(
          wEnergy: 0.20,
          wBattery: 0.20,
          wTime: 0.40,
          wConnectivity: 0.10,
          wFallback: 0.10,
        );
      case 'Battery Safe':
        return _ScoringWeights(
          wEnergy: 0.30,
          wBattery: 0.40,
          wTime: 0.10,
          wConnectivity: 0.10,
          wFallback: 0.10,
        );
      case 'Energy Efficient':
      default:
        return _ScoringWeights(
          wEnergy: AppConstants.weightEnergyEfficiency,
          wBattery: AppConstants.weightBatterySafety,
          wTime: AppConstants.weightTravelTime,
          wConnectivity: AppConstants.weightConnectivity,
          wFallback: AppConstants.weightChargingFallback,
        );
    }
  }

  String _generateRouteExplanation(RouteEntity route, bool isRecommended, double batteryPercent) {
    if (isRecommended) {
      if (batteryPercent < 25.0) {
        return 'Selected for battery preservation. Maximizes arrival reserve (${route.estimatedArrivalReserve.toStringAsFixed(1)}%) with ${route.fallbackChargerIds.length} accessible charging fallbacks.';
      }
      if (route.energyEfficiencyScore >= 0.8) {
        return 'Optimal energy balance: Consumes minimal power with steady regenerative braking and ${route.estimatedArrivalReserve.toStringAsFixed(1)}% arrival reserve.';
      }
      if (route.travelTimeScore >= 0.8) {
        return 'Fastest transit: High-speed corridor verified with safe battery margin (${route.estimatedArrivalReserve.toStringAsFixed(1)}% arrival reserve).';
      }
      return 'Balanced recommendation: High connectivity (${(route.connectivityReliability * 100).toInt()}%), stable road grade, and dependable charger fallbacks.';
    } else {
      if (!route.isSafe) {
        return 'Battery warning: Low estimated reserve (${route.estimatedArrivalReserve.toStringAsFixed(1)}%) violates the 15% safety threshold.';
      }
      if (route.connectivityScore < 0.6) {
        return 'Cellular risk: Route traverses known connectivity drop zones with patchy offline telemetry.';
      }
      return 'Alternative candidate with higher energy draw or longer travel duration.';
    }
  }
}

class _ScoringWeights {
  final double wEnergy;
  final double wBattery;
  final double wTime;
  final double wConnectivity;
  final double wFallback;

  _ScoringWeights({
    required this.wEnergy,
    required this.wBattery,
    required this.wTime,
    required this.wConnectivity,
    required this.wFallback,
  });
}
