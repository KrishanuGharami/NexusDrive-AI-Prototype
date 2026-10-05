import '../../domain/entities/route.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.origin,
    required super.destination,
    required super.title,
    required super.routeType,
    required super.distanceKm,
    required super.estimatedTimeMinutes,
    required super.baseEnergyKwh,
    required super.elevationGainMeters,
    required super.elevationLossMeters,
    required super.trafficCongestionMultiplier,
    required super.connectivityReliability,
    required super.fallbackChargerIds,
    required super.waypoints,
    required super.roadGradeDescription,
    super.totalScore = 0.0,
    super.energyEfficiencyScore = 0.0,
    super.batterySafetyScore = 0.0,
    super.travelTimeScore = 0.0,
    super.connectivityScore = 0.0,
    super.chargingFallbackScore = 0.0,
    super.estimatedArrivalReserve = 0.0,
    super.isSafe = true,
    super.explanation = '',
    super.isRecommended = false,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      title: json['title'] as String,
      routeType: json['routeType'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int,
      baseEnergyKwh: (json['baseEnergyKwh'] as num).toDouble(),
      elevationGainMeters: (json['elevationGainMeters'] as num).toDouble(),
      elevationLossMeters: (json['elevationLossMeters'] as num).toDouble(),
      trafficCongestionMultiplier: (json['trafficCongestionMultiplier'] as num).toDouble(),
      connectivityReliability: (json['connectivityReliability'] as num).toDouble(),
      fallbackChargerIds: (json['fallbackChargerIds'] as List<dynamic>).map((e) => e.toString()).toList(),
      waypoints: (json['waypoints'] as List<dynamic>).map((e) => e.toString()).toList(),
      roadGradeDescription: json['roadGradeDescription'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin,
      'destination': destination,
      'title': title,
      'routeType': routeType,
      'distanceKm': distanceKm,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'baseEnergyKwh': baseEnergyKwh,
      'elevationGainMeters': elevationGainMeters,
      'elevationLossMeters': elevationLossMeters,
      'trafficCongestionMultiplier': trafficCongestionMultiplier,
      'connectivityReliability': connectivityReliability,
      'fallbackChargerIds': fallbackChargerIds,
      'waypoints': waypoints,
      'roadGradeDescription': roadGradeDescription,
    };
  }
}
