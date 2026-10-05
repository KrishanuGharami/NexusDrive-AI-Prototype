/// Simulation & Demo Presets for Hackathon Jury Reproducibility
class DemoConstants {
  DemoConstants._();

  static const List<double> batteryPresets = [80.0, 50.0, 25.0, 15.0];

  static const List<String> connectivityPresets = [
    'Good (5G-SA)',
    'Moderate (4G-LTE)',
    'Poor / Deadzone (Offline Edge)'
  ];

  static const List<String> sampleDestinations = [
    'Electronic City Phase 1',
    'Kempegowda Int\'l Airport (KIAL)',
    'Whitefield ITPL Corridor'
  ];

  static const List<String> drivingPreferences = [
    'Battery Safe',
    'Energy Efficient',
    'Fastest'
  ];
}
