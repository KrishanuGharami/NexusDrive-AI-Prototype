import 'package:flutter_test/flutter_test.dart';
import 'package:nexusdrive_ai/core/utils/distance_utils.dart';
import 'package:nexusdrive_ai/data/models/telemetry_model.dart';
import 'package:nexusdrive_ai/domain/entities/telemetry.dart';

void main() {
  group('Telemetry & Math Tests', () {
    test('TelemetryModel serialization and deserialization roundtrip preserves fidelity', () {
      final initial = TelemetryModel(
        batteryPercentage: 72.5,
        isCharging: true,
        batteryTemperatureCelsius: 31.0,
        latitude: 12.9716,
        longitude: 77.5946,
        altitudeMeters: 920.0,
        speedKmh: 48.0,
        gpsAccuracyMeters: 3.5,
        gpsStatus: 'LOCKED',
        accelX: 0.12,
        accelY: -0.45,
        accelZ: 9.80,
        motionActivity: 'CRUISING',
        networkType: '5G-SA',
        signalStrength: 0.95,
        isOffline: false,
        edgeEngineStatus: 'ACTIVE_LOCAL',
        timestamp: DateTime(2026, 10, 5, 12, 0, 0),
        isSimulated: false,
      );

      final jsonMap = initial.toJson();
      final parsed = TelemetryModel.fromJson(jsonMap);

      expect(parsed.batteryPercentage, equals(initial.batteryPercentage));
      expect(parsed.isCharging, equals(initial.isCharging));
      expect(parsed.latitude, equals(initial.latitude));
      expect(parsed.longitude, equals(initial.longitude));
      expect(parsed.speedKmh, equals(initial.speedKmh));
      expect(parsed.gpsStatus, equals(initial.gpsStatus));
    });

    test('DistanceUtils.haversineDistanceKm calculates accurate Bengaluru distance', () {
      // Indiranagar (12.9719, 77.6412) to Koramangala (12.9352, 77.6245) is ~4.5 km straight-line
      final dist = DistanceUtils.haversineDistanceKm(
        lat1: 12.9719,
        lon1: 77.6412,
        lat2: 12.9352,
        lon2: 77.6245,
      );

      expect(dist, inInclusiveRange(4.0, 5.5));
    });

    test('TelemetryEntity baseline initializes nominal telemetry', () {
      final t = TelemetryEntity.initial();
      expect(t.batteryPercentage, inInclusiveRange(0.0, 100.0));
      expect(t.gpsStatus, equals('LOCKED'));
      expect(t.edgeEngineStatus, equals('ACTIVE_LOCAL'));
    });
  });
}
