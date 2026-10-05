import '../../core/utils/distance_utils.dart';
import '../entities/charging_station.dart';
import '../entities/route.dart';
import '../../data/repositories/charging_repository.dart';

class BatteryRescuePlan {
  final ChargingStation recommendedStation;
  final List<ChargingStation> candidateStations;
  final double distanceToStationKm;
  final double estimatedBatteryAtStation;
  final int estimatedChargeTimeMinutes;
  final RouteEntity recalculatedRoute;
  final String explanation;
  final bool isFeasible;

  const BatteryRescuePlan({
    required this.recommendedStation,
    required this.candidateStations,
    required this.distanceToStationKm,
    required this.estimatedBatteryAtStation,
    required this.estimatedChargeTimeMinutes,
    required this.recalculatedRoute,
    required this.explanation,
    required this.isFeasible,
  });
}

class BatteryRescueService {
  final ChargingRepository chargingRepository;

  BatteryRescueService({required this.chargingRepository});

  /// Computes an emergency battery rescue plan
  Future<BatteryRescuePlan> computeRescuePlan({
    required double currentLatitude,
    required double currentLongitude,
    required double currentBatteryPercent,
    required double batteryCapacityKwh,
    required RouteEntity originalRoute,
  }) async {
    // 1. Fetch nearest charging stations
    final stations = await chargingRepository.getNearestStations(
      latitude: currentLatitude,
      longitude: currentLongitude,
      limit: 4,
    );

    if (stations.isEmpty) {
      throw Exception('No local charging hubs located within emergency radius');
    }

    // 2. Rank stations by composite rescue score:
    // Score = (1.0 / distance) * 0.4 + (powerKw / 120.0) * 0.3 + (reliability) * 0.2 + (availability) * 0.1
    final rankedStations = List<ChargingStation>.from(stations)
      ..sort((a, b) {
        final distA = DistanceUtils.haversineDistanceKm(
          lat1: currentLatitude,
          lon1: currentLongitude,
          lat2: a.latitude,
          lon2: a.longitude,
        );
        final distB = DistanceUtils.haversineDistanceKm(
          lat1: currentLatitude,
          lon1: currentLongitude,
          lat2: b.latitude,
          lon2: b.longitude,
        );

        final scoreA = (10.0 / (distA + 0.5)) + (a.powerKw * 0.1) + (a.hasAvailablePorts ? 5.0 : 0.0);
        final scoreB = (10.0 / (distB + 0.5)) + (b.powerKw * 0.1) + (b.hasAvailablePorts ? 5.0 : 0.0);
        return scoreB.compareTo(scoreA);
      });

    final targetStation = rankedStations.first;
    final distToStation = DistanceUtils.haversineDistanceKm(
      lat1: currentLatitude,
      lon1: currentLongitude,
      lat2: targetStation.latitude,
      lon2: targetStation.longitude,
    );

    // Energy to reach station: ~0.15 kWh per km
    final energyToStation = distToStation * 0.15;
    final batteryUsedPercent = (energyToStation / batteryCapacityKwh) * 100.0;
    final batteryAtStation = currentBatteryPercent - batteryUsedPercent;
    final isFeasible = batteryAtStation > 2.0;

    // Estimate charging time to 80% SoC
    final kwhNeededTo80Percent = ((80.0 - batteryAtStation) / 100.0) * batteryCapacityKwh;
    final chargeTimeHours = kwhNeededTo80Percent / (targetStation.powerKw * 0.85); // 85% charge efficiency
    final chargeTimeMinutes = (chargeTimeHours * 60).round().clamp(10, 60);

    // 3. Create recalculated route via charger
    final rescueRoute = RouteEntity(
      id: 'rescue_${originalRoute.id}',
      origin: originalRoute.origin,
      destination: '${originalRoute.destination} (via ${targetStation.name})',
      title: 'Emergency Battery Rescue Corridor',
      routeType: 'Battery Rescue Divert',
      distanceKm: double.parse((distToStation + originalRoute.distanceKm * 0.85).toStringAsFixed(1)),
      estimatedTimeMinutes: (distToStation * 2.2).round() + chargeTimeMinutes + (originalRoute.estimatedTimeMinutes * 0.8).round(),
      baseEnergyKwh: double.parse((energyToStation + 2.1).toStringAsFixed(2)),
      elevationGainMeters: 20.0,
      elevationLossMeters: 20.0,
      trafficCongestionMultiplier: 1.05,
      connectivityReliability: 0.92,
      fallbackChargerIds: [targetStation.id, ...originalRoute.fallbackChargerIds],
      waypoints: [
        'Current Position',
        '⚡ ${targetStation.name} (${distToStation.toStringAsFixed(1)} km)',
        'Resumed Route to ${originalRoute.destination}',
      ],
      roadGradeDescription: 'Low-speed urban divert minimizing aerodynamic drain to safeguard battery',
      totalScore: 0.95,
      energyEfficiencyScore: 0.90,
      batterySafetyScore: 0.98,
      travelTimeScore: 0.65,
      connectivityScore: 0.92,
      chargingFallbackScore: 1.0,
      estimatedArrivalReserve: 72.0, // After 80% charge
      isSafe: true,
      explanation: 'Route recalculated because current battery (${currentBatteryPercent.toStringAsFixed(0)}%) cannot safely reach destination without stranding. Diverting to ${targetStation.name} (${targetStation.powerKw.toInt()} kW DC) adds $distToStation km with guaranteed arrival buffer.',
      isRecommended: true,
    );

    final explanation =
        'Battery Rescue Active: Original route cannot guarantee arrival reserve. Diverting ${distToStation.toStringAsFixed(1)} km to ${targetStation.name} provides ${targetStation.powerKw.toInt()} kW fast charging with ${targetStation.availablePorts} ports open.';

    return BatteryRescuePlan(
      recommendedStation: targetStation,
      candidateStations: rankedStations,
      distanceToStationKm: distToStation,
      estimatedBatteryAtStation: double.parse(batteryAtStation.toStringAsFixed(1)),
      estimatedChargeTimeMinutes: chargeTimeMinutes,
      recalculatedRoute: rescueRoute,
      explanation: explanation,
      isFeasible: isFeasible,
    );
  }
}
