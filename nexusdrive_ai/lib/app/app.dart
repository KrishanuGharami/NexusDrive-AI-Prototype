import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/datasources/local_charging_datasource.dart';
import '../data/datasources/local_route_datasource.dart';
import '../data/datasources/local_telemetry_datasource.dart';
import '../data/repositories/charging_repository.dart';
import '../data/repositories/route_repository.dart';
import '../data/repositories/telemetry_repository.dart';
import '../demo/demo_controller.dart';
import '../domain/services/battery_rescue_service.dart';
import '../domain/services/battery_safety_service.dart';
import '../domain/services/route_scoring_service.dart';
import '../features/battery_rescue/battery_rescue_screen.dart';
import '../features/home/home_screen.dart';
import '../features/journey/journey_screen.dart';
import '../features/route_analysis/route_analysis_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/telemetry/telemetry_screen.dart';
import '../services/ai/edge_inference_engine.dart';
import '../services/ai/explanation_service.dart';
import '../services/ai/route_ai_service.dart';
import '../services/camera/battery_ocr_service.dart';
import '../services/office_kit/office_kit_bridge.dart';
import '../services/telemetry/battery_service.dart';
import '../services/telemetry/location_service.dart';
import '../services/telemetry/motion_service.dart';
import '../services/voice/voice_command_service.dart';
import 'app_theme.dart';

class NexusDriveApp extends StatefulWidget {
  const NexusDriveApp({super.key});

  @override
  State<NexusDriveApp> createState() => _NexusDriveAppState();
}

class _NexusDriveAppState extends State<NexusDriveApp> {
  late final LocalChargingDataSource _chargingDataSource;
  late final LocalRouteDataSource _routeDataSource;
  late final LocalTelemetryDataSource _telemetryDataSource;

  late final ChargingRepository _chargingRepository;
  late final RouteRepository _routeRepository;
  late final TelemetryRepository _telemetryRepository;

  late final RouteScoringService _scoringService;
  late final BatterySafetyService _safetyService;
  late final BatteryRescueService _rescueService;
  late final EdgeInferenceEngine _edgeEngine;
  late final ExplanationService _explanationService;
  late final RouteAiService _routeAiService;

  late final BatteryService _batteryService;
  late final LocationService _locationService;
  late final MotionService _motionService;
  late final VoiceCommandService _voiceService;
  late final OfficeKitBridge _officeKitBridge;
  late final BatteryOcrService _ocrService;

  late final DemoController _demoController;

  @override
  void initState() {
    super.initState();
    // 1. Data sources
    _chargingDataSource = LocalChargingDataSourceImpl();
    _routeDataSource = LocalRouteDataSourceImpl();
    _telemetryDataSource = LocalTelemetryDataSourceImpl();

    // 2. Repositories
    _chargingRepository = ChargingRepositoryImpl(localDataSource: _chargingDataSource);
    _routeRepository = RouteRepositoryImpl(localDataSource: _routeDataSource);
    _telemetryRepository = TelemetryRepositoryImpl(localDataSource: _telemetryDataSource);

    // 3. Domain Services
    _scoringService = RouteScoringService();
    _safetyService = BatterySafetyService();
    _rescueService = BatteryRescueService(chargingRepository: _chargingRepository);

    // 4. Edge AI Engine
    _edgeEngine = LocalDeterministicEdgeInferenceEngine(
      scoringService: _scoringService,
      safetyService: _safetyService,
    );
    _explanationService = ExplanationService();
    _routeAiService = RouteAiService(
      routeRepository: _routeRepository,
      edgeEngine: _edgeEngine,
      rescueService: _rescueService,
      explanationService: _explanationService,
    );

    // 5. Hardware / Phone Telemetry Services
    _batteryService = BatteryService();
    _locationService = LocationService();
    _motionService = MotionService();
    _voiceService = VoiceCommandService()..initialize();
    _officeKitBridge = OfficeKitBridge();
    _ocrService = BatteryOcrService();

    // 6. Demo & Telemetry Controller
    _demoController = DemoController(
      batteryService: _batteryService,
      locationService: _locationService,
      motionService: _motionService,
      telemetryRepository: _telemetryRepository,
    );
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexusDrive AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _MainNavigationScaffold(
        demoController: _demoController,
        routeAiService: _routeAiService,
        routeRepository: _routeRepository,
        chargingRepository: _chargingRepository,
        voiceService: _voiceService,
        officeKitBridge: _officeKitBridge,
        ocrService: _ocrService,
      ),
    );
  }
}

class _MainNavigationScaffold extends StatefulWidget {
  final DemoController demoController;
  final RouteAiService routeAiService;
  final RouteRepository routeRepository;
  final ChargingRepository chargingRepository;
  final VoiceCommandService voiceService;
  final OfficeKitBridge officeKitBridge;
  final BatteryOcrService ocrService;

  const _MainNavigationScaffold({
    required this.demoController,
    required this.routeAiService,
    required this.routeRepository,
    required this.chargingRepository,
    required this.voiceService,
    required this.officeKitBridge,
    required this.ocrService,
  });

  @override
  State<_MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<_MainNavigationScaffold> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _openRouteAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RouteAnalysisScreen(
          demoController: widget.demoController,
          routeAiService: widget.routeAiService,
          officeKitBridge: widget.officeKitBridge,
          onOpenBatteryRescue: _openBatteryRescue,
        ),
      ),
    );
  }

  void _openBatteryRescue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BatteryRescueScreen(
          demoController: widget.demoController,
          routeRepository: widget.routeRepository,
          chargingRepository: widget.chargingRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        demoController: widget.demoController,
        voiceService: widget.voiceService,
        onNavigateTab: _navigateToTab,
        onOpenRouteAnalysis: _openRouteAnalysis,
        onOpenBatteryRescue: _openBatteryRescue,
      ),
      JourneyScreen(
        demoController: widget.demoController,
        onAnalyzePressed: _openRouteAnalysis,
      ),
      TelemetryScreen(
        demoController: widget.demoController,
      ),
      SettingsScreen(
        demoController: widget.demoController,
        officeKitBridge: widget.officeKitBridge,
        ocrService: widget.ocrService,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _navigateToTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.cyanAccent,
          unselectedItemColor: AppColors.textTertiary,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Copilot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Journey',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.memory_rounded),
              label: 'Telemetry',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Vehicle/Kit',
            ),
          ],
        ),
      ),
    );
  }
}
