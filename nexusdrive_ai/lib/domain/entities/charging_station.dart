class ChargingStation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> connectorTypes;
  final double powerKw;
  final int totalPorts;
  final int availablePorts;
  final String status;
  final double pricingPerKwh;
  final double reliabilityScore; // 0.0 to 1.0
  final List<String> amenities;

  const ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.connectorTypes,
    required this.powerKw,
    required this.totalPorts,
    required this.availablePorts,
    required this.status,
    required this.pricingPerKwh,
    required this.reliabilityScore,
    required this.amenities,
  });

  bool get isFastCharger => powerKw >= 50.0;
  bool get hasAvailablePorts => availablePorts > 0;
}
