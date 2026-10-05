class VehicleModel {
  final String id;
  final String name;
  final double batteryCapacityKwh;
  final double maxChargingSpeedKw;
  final double efficiencyWhPerKm;
  final List<String> supportedPlugTypes;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.batteryCapacityKwh,
    required this.maxChargingSpeedKw,
    required this.efficiencyWhPerKm,
    required this.supportedPlugTypes,
  });

  static List<VehicleModel> get defaultVehicles => const [
    VehicleModel(
      id: 'v_nexon',
      name: 'Tata Nexon.ev LR (40.5 kWh)',
      batteryCapacityKwh: 40.5,
      maxChargingSpeedKw: 50.0,
      efficiencyWhPerKm: 140.0,
      supportedPlugTypes: ['CCS2', 'Type 2'],
    ),
    VehicleModel(
      id: 'v_tiago',
      name: 'Tata Tiago.ev (24 kWh)',
      batteryCapacityKwh: 24.0,
      maxChargingSpeedKw: 25.0,
      efficiencyWhPerKm: 120.0,
      supportedPlugTypes: ['CCS2', 'Type 2'],
    ),
    VehicleModel(
      id: 'v_mg',
      name: 'MG ZS EV Long Range (50.3 kWh)',
      batteryCapacityKwh: 50.3,
      maxChargingSpeedKw: 80.0,
      efficiencyWhPerKm: 155.0,
      supportedPlugTypes: ['CCS2', 'Type 2'],
    ),
  ];
}
