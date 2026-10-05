import '../../domain/entities/charging_station.dart';

class ChargingStationModel extends ChargingStation {
  const ChargingStationModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.connectorTypes,
    required super.powerKw,
    required super.totalPorts,
    required super.availablePorts,
    required super.status,
    required super.pricingPerKwh,
    required super.reliabilityScore,
    required super.amenities,
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      connectorTypes: (json['connectorTypes'] as List<dynamic>).map((e) => e.toString()).toList(),
      powerKw: (json['powerKw'] as num).toDouble(),
      totalPorts: json['totalPorts'] as int,
      availablePorts: json['availablePorts'] as int,
      status: json['status'] as String,
      pricingPerKwh: (json['pricingPerKwh'] as num).toDouble(),
      reliabilityScore: (json['reliabilityScore'] as num).toDouble(),
      amenities: (json['amenities'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'connectorTypes': connectorTypes,
      'powerKw': powerKw,
      'totalPorts': totalPorts,
      'availablePorts': availablePorts,
      'status': status,
      'pricingPerKwh': pricingPerKwh,
      'reliabilityScore': reliabilityScore,
      'amenities': amenities,
    };
  }
}
