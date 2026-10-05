class DemoScenario {
  final String title;
  final String subtitle;
  final double batteryPercent;
  final String destination;
  final String connectivity;
  final bool isRescueExpected;

  const DemoScenario({
    required this.title,
    required this.subtitle,
    required this.batteryPercent,
    required this.destination,
    required this.connectivity,
    required this.isRescueExpected,
  });

  static List<DemoScenario> get presets => const [
    DemoScenario(
      title: 'Scenario 1: High Battery (80%) Normal Cruising',
      subtitle: 'Fastest corridor wins comfortably. Arrival reserve > 65%.',
      batteryPercent: 80.0,
      destination: 'Electronic City Phase 1',
      connectivity: 'Good (5G-SA)',
      isRescueExpected: false,
    ),
    DemoScenario(
      title: 'Scenario 2: Mid Battery (50%) Efficiency Test',
      subtitle: 'Energy efficient route recommended to avoid excess expressway drag.',
      batteryPercent: 50.0,
      destination: 'Electronic City Phase 1',
      connectivity: 'Moderate (4G-LTE)',
      isRescueExpected: false,
    ),
    DemoScenario(
      title: 'Scenario 3: Battery Warning (25%) Preservation',
      subtitle: 'Algorithm shifts weights to battery safety; warns on arrival reserve.',
      batteryPercent: 25.0,
      destination: 'Kempegowda Int\'l Airport (KIAL)',
      connectivity: 'Good (5G-SA)',
      isRescueExpected: false,
    ),
    DemoScenario(
      title: 'Scenario 4: Critical Battery (15%) Battery Rescue Triggered',
      subtitle: 'Dangerous arrival reserve. Triggers auto-divert to nearest DC Fast charger.',
      batteryPercent: 15.0,
      destination: 'Electronic City Phase 1',
      connectivity: 'Poor / Deadzone (Offline Edge)',
      isRescueExpected: true,
    ),
  ];
}
