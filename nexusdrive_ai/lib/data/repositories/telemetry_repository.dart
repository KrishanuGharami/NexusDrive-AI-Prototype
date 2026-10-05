import '../../domain/entities/telemetry.dart';
import '../datasources/local_telemetry_datasource.dart';
import '../models/telemetry_model.dart';

abstract class TelemetryRepository {
  Future<void> saveTelemetrySnapshot(TelemetryEntity telemetry);
  Future<TelemetryEntity> getLatestTelemetry();
}

class TelemetryRepositoryImpl implements TelemetryRepository {
  final LocalTelemetryDataSource localDataSource;

  TelemetryRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveTelemetrySnapshot(TelemetryEntity telemetry) async {
    final model = TelemetryModel(
      batteryPercentage: telemetry.batteryPercentage,
      isCharging: telemetry.isCharging,
      batteryTemperatureCelsius: telemetry.batteryTemperatureCelsius,
      latitude: telemetry.latitude,
      longitude: telemetry.longitude,
      altitudeMeters: telemetry.altitudeMeters,
      speedKmh: telemetry.speedKmh,
      gpsAccuracyMeters: telemetry.gpsAccuracyMeters,
      gpsStatus: telemetry.gpsStatus,
      accelX: telemetry.accelX,
      accelY: telemetry.accelY,
      accelZ: telemetry.accelZ,
      motionActivity: telemetry.motionActivity,
      networkType: telemetry.networkType,
      signalStrength: telemetry.signalStrength,
      isOffline: telemetry.isOffline,
      edgeEngineStatus: telemetry.edgeEngineStatus,
      timestamp: telemetry.timestamp,
      isSimulated: telemetry.isSimulated,
    );
    await localDataSource.cacheTelemetry(model);
  }

  @override
  Future<TelemetryEntity> getLatestTelemetry() async {
    final cached = await localDataSource.getCachedTelemetry();
    return cached ?? TelemetryEntity.initial();
  }
}
