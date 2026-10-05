import '../domain/entities/telemetry.dart';

class DemoTelemetryGenerator {
  static TelemetryEntity generate({
    required double batteryPercent,
    required String connectivity,
    bool isSimulated = true,
  }) {
    final bool isOffline = connectivity.contains('Poor') || connectivity.contains('Offline');
    final String netType = isOffline ? 'OFFLINE (EDGE AI ACTIVE)' : (connectivity.contains('5G') ? '5G-SA' : '4G-LTE');
    final double signal = isOffline ? 0.05 : (connectivity.contains('5G') ? 0.95 : 0.65);

    return TelemetryEntity(
      batteryPercentage: batteryPercent,
      isCharging: false,
      batteryTemperatureCelsius: 32.4,
      latitude: 12.9352, // Koramangala, Bengaluru
      longitude: 77.6245,
      altitudeMeters: 920.0,
      speedKmh: 41.5,
      gpsAccuracyMeters: 4.8,
      gpsStatus: isSimulated ? 'SIMULATED (DEMO MODE)' : 'LOCKED',
      accelX: 0.15,
      accelY: 0.08,
      accelZ: 9.81,
      motionActivity: 'CRUISING',
      networkType: netType,
      signalStrength: signal,
      isOffline: isOffline,
      edgeEngineStatus: 'ACTIVE_LOCAL',
      timestamp: DateTime.now(),
      isSimulated: isSimulated,
    );
  }
}
