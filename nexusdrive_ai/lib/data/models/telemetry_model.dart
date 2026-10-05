import '../../domain/entities/telemetry.dart';

class TelemetryModel extends TelemetryEntity {
  const TelemetryModel({
    required super.batteryPercentage,
    required super.isCharging,
    required super.batteryTemperatureCelsius,
    required super.latitude,
    required super.longitude,
    required super.altitudeMeters,
    required super.speedKmh,
    required super.gpsAccuracyMeters,
    required super.gpsStatus,
    required super.accelX,
    required super.accelY,
    required super.accelZ,
    required super.motionActivity,
    required super.networkType,
    required super.signalStrength,
    required super.isOffline,
    required super.edgeEngineStatus,
    required super.timestamp,
    super.isSimulated = false,
  });

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      batteryPercentage: (json['batteryPercentage'] as num).toDouble(),
      isCharging: json['isCharging'] as bool? ?? false,
      batteryTemperatureCelsius: (json['batteryTemperatureCelsius'] as num?)?.toDouble() ?? 30.0,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitudeMeters: (json['altitudeMeters'] as num?)?.toDouble() ?? 900.0,
      speedKmh: (json['speedKmh'] as num?)?.toDouble() ?? 0.0,
      gpsAccuracyMeters: (json['gpsAccuracyMeters'] as num?)?.toDouble() ?? 5.0,
      gpsStatus: json['gpsStatus'] as String? ?? 'LOCKED',
      accelX: (json['accelX'] as num?)?.toDouble() ?? 0.0,
      accelY: (json['accelY'] as num?)?.toDouble() ?? 0.0,
      accelZ: (json['accelZ'] as num?)?.toDouble() ?? 9.81,
      motionActivity: json['motionActivity'] as String? ?? 'STATIONARY',
      networkType: json['networkType'] as String? ?? '5G-SA',
      signalStrength: (json['signalStrength'] as num?)?.toDouble() ?? 0.9,
      isOffline: json['isOffline'] as bool? ?? false,
      edgeEngineStatus: json['edgeEngineStatus'] as String? ?? 'ACTIVE_LOCAL',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isSimulated: json['isSimulated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batteryPercentage': batteryPercentage,
      'isCharging': isCharging,
      'batteryTemperatureCelsius': batteryTemperatureCelsius,
      'latitude': latitude,
      'longitude': longitude,
      'altitudeMeters': altitudeMeters,
      'speedKmh': speedKmh,
      'gpsAccuracyMeters': gpsAccuracyMeters,
      'gpsStatus': gpsStatus,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'motionActivity': motionActivity,
      'networkType': networkType,
      'signalStrength': signalStrength,
      'isOffline': isOffline,
      'edgeEngineStatus': edgeEngineStatus,
      'timestamp': timestamp.toIso8601String(),
      'isSimulated': isSimulated,
    };
  }
}
