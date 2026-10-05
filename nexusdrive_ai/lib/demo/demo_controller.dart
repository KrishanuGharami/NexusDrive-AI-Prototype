import 'package:flutter/foundation.dart';
import '../data/models/vehicle_model.dart';
import '../domain/entities/telemetry.dart';
import '../services/telemetry/battery_service.dart';
import '../services/telemetry/location_service.dart';
import '../services/telemetry/motion_service.dart';
import 'demo_telemetry.dart';

import '../data/repositories/telemetry_repository.dart';

class DemoController extends ChangeNotifier {
  final BatteryService batteryService;
  final LocationService locationService;
  final MotionService motionService;
  final TelemetryRepository? telemetryRepository;

  DemoController({
    required this.batteryService,
    required this.locationService,
    required this.motionService,
    this.telemetryRepository,
  }) {
    _initHardwareTelemetry();
  }

  bool _isDemoModeActive = false;
  double _selectedBatteryPercent = 68.0;
  String _selectedConnectivity = 'Good (5G-SA)';
  String _selectedDestination = 'Electronic City Phase 1';
  String _drivingPreference = 'Energy Efficient';
  VehicleModel _selectedVehicle = VehicleModel.defaultVehicles.first;

  TelemetryEntity _hardwareTelemetry = TelemetryEntity.initial();
  TelemetryEntity _activeTelemetry = TelemetryEntity.initial();

  bool get isDemoModeActive => _isDemoModeActive;
  double get selectedBatteryPercent => _selectedBatteryPercent;
  String get selectedConnectivity => _selectedConnectivity;
  String get selectedDestination => _selectedDestination;
  String get drivingPreference => _drivingPreference;
  VehicleModel get selectedVehicle => _selectedVehicle;
  TelemetryEntity get hardwareTelemetry => _hardwareTelemetry;
  TelemetryEntity get activeTelemetry => _activeTelemetry;

  Future<void> _initHardwareTelemetry() async {
    // 1. Fetch real hardware battery
    final bat = await batteryService.getCurrentBattery();
    // 2. Fetch real hardware GPS
    final loc = await locationService.getCurrentLocation();

    _hardwareTelemetry = _hardwareTelemetry.copyWith(
      batteryPercentage: bat.levelPercent,
      isCharging: bat.isCharging,
      latitude: loc.latitude,
      longitude: loc.longitude,
      altitudeMeters: loc.altitude,
      speedKmh: loc.speedKmh,
      gpsAccuracyMeters: loc.accuracy,
      gpsStatus: loc.status,
      timestamp: DateTime.now(),
      isSimulated: false,
    );

    // 3. Listen to motion events
    motionService.startListening((motion) {
      _hardwareTelemetry = _hardwareTelemetry.copyWith(
        accelX: motion.x,
        accelY: motion.y,
        accelZ: motion.z,
        motionActivity: motion.activityState,
      );
      if (!_isDemoModeActive) {
        _activeTelemetry = _hardwareTelemetry;
        notifyListeners();
      }
    });

    // 4. Listen to battery events
    batteryService.startListening((bSnap) {
      _hardwareTelemetry = _hardwareTelemetry.copyWith(
        batteryPercentage: bSnap.levelPercent,
        isCharging: bSnap.isCharging,
      );
      if (!_isDemoModeActive) {
        _activeTelemetry = _hardwareTelemetry;
        notifyListeners();
      }
    });

    if (!_isDemoModeActive) {
      _activeTelemetry = _hardwareTelemetry;
      _selectedBatteryPercent = _hardwareTelemetry.batteryPercentage;
    }
    notifyListeners();
  }

  void setDemoMode(bool active) {
    _isDemoModeActive = active;
    _syncActiveTelemetry();
    notifyListeners();
  }

  void setBatteryPercent(double percent) {
    _selectedBatteryPercent = percent;
    _syncActiveTelemetry();
    notifyListeners();
  }

  void setConnectivity(String connectivity) {
    _selectedConnectivity = connectivity;
    _syncActiveTelemetry();
    notifyListeners();
  }

  void setDestination(String destination) {
    _selectedDestination = destination;
    notifyListeners();
  }

  void setDrivingPreference(String preference) {
    _drivingPreference = preference;
    notifyListeners();
  }

  void setVehicle(VehicleModel vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void _syncActiveTelemetry() {
    if (_isDemoModeActive) {
      _activeTelemetry = DemoTelemetryGenerator.generate(
        batteryPercent: _selectedBatteryPercent,
        connectivity: _selectedConnectivity,
        isSimulated: true,
      );
    } else {
      _activeTelemetry = _hardwareTelemetry;
      _selectedBatteryPercent = _hardwareTelemetry.batteryPercentage;
    }
  }

  @override
  void dispose() {
    batteryService.dispose();
    motionService.dispose();
    super.dispose();
  }
}
