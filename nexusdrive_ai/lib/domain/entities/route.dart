class RouteEntity {
  final String id;
  final String origin;
  final String destination;
  final String title;
  final String routeType; // 'Fastest', 'Energy Efficient', 'Low Connectivity Safe'
  final double distanceKm;
  final int estimatedTimeMinutes;
  final double baseEnergyKwh;
  final double elevationGainMeters;
  final double elevationLossMeters;
  final double trafficCongestionMultiplier;
  final double connectivityReliability; // 0.0 to 1.0
  final List<String> fallbackChargerIds;
  final List<String> waypoints;
  final String roadGradeDescription;

  // Dynamic Scored Attributes evaluated by Edge Engine
  final double totalScore;
  final double energyEfficiencyScore;
  final double batterySafetyScore;
  final double travelTimeScore;
  final double connectivityScore;
  final double chargingFallbackScore;
  final double estimatedArrivalReserve;
  final bool isSafe;
  final String explanation;
  final bool isRecommended;

  const RouteEntity({
    required this.id,
    required this.origin,
    required this.destination,
    required this.title,
    required this.routeType,
    required this.distanceKm,
    required this.estimatedTimeMinutes,
    required this.baseEnergyKwh,
    required this.elevationGainMeters,
    required this.elevationLossMeters,
    required this.trafficCongestionMultiplier,
    required this.connectivityReliability,
    required this.fallbackChargerIds,
    required this.waypoints,
    required this.roadGradeDescription,
    this.totalScore = 0.0,
    this.energyEfficiencyScore = 0.0,
    this.batterySafetyScore = 0.0,
    this.travelTimeScore = 0.0,
    this.connectivityScore = 0.0,
    this.chargingFallbackScore = 0.0,
    this.estimatedArrivalReserve = 0.0,
    this.isSafe = true,
    this.explanation = '',
    this.isRecommended = false,
  });

  RouteEntity copyWith({
    double? totalScore,
    double? energyEfficiencyScore,
    double? batterySafetyScore,
    double? travelTimeScore,
    double? connectivityScore,
    double? chargingFallbackScore,
    double? estimatedArrivalReserve,
    bool? isSafe,
    String? explanation,
    bool? isRecommended,
  }) {
    return RouteEntity(
      id: id,
      origin: origin,
      destination: destination,
      title: title,
      routeType: routeType,
      distanceKm: distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes,
      baseEnergyKwh: baseEnergyKwh,
      elevationGainMeters: elevationGainMeters,
      elevationLossMeters: elevationLossMeters,
      trafficCongestionMultiplier: trafficCongestionMultiplier,
      connectivityReliability: connectivityReliability,
      fallbackChargerIds: fallbackChargerIds,
      waypoints: waypoints,
      roadGradeDescription: roadGradeDescription,
      totalScore: totalScore ?? this.totalScore,
      energyEfficiencyScore: energyEfficiencyScore ?? this.energyEfficiencyScore,
      batterySafetyScore: batterySafetyScore ?? this.batterySafetyScore,
      travelTimeScore: travelTimeScore ?? this.travelTimeScore,
      connectivityScore: connectivityScore ?? this.connectivityScore,
      chargingFallbackScore: chargingFallbackScore ?? this.chargingFallbackScore,
      estimatedArrivalReserve: estimatedArrivalReserve ?? this.estimatedArrivalReserve,
      isSafe: isSafe ?? this.isSafe,
      explanation: explanation ?? this.explanation,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }
}
