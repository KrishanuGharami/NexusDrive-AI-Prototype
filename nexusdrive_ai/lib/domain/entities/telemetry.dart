class TelemetryEntity {
  final double batteryPercentage;
  final bool isCharging;
  final double batteryTemperatureCelsius;
  final double latitude;
  final double longitude;
  final double altitudeMeters;
  final double speedKmh;
  final double gpsAccuracyMeters;
  final String gpsStatus; // 'LOCKED', 'ACQUIRING', 'SIMULATED'
  final double accelX;
  final double accelY;
  final double accelZ;
  final String motionActivity; // 'STATIONARY', 'CRUISING', 'ACCELERATING', 'REGEN_BRAKING'
  final String networkType; // '5G-SA', '4G-LTE', 'OFFLINE'
  final double signalStrength; // 0.0 to 1.0
  final bool isOffline;
  final String edgeEngineStatus; // 'ACTIVE_LOCAL', 'INFERRING', 'READY'
  final DateTime timestamp;
  final bool isSimulated;

  const TelemetryEntity({
    required this.batteryPercentage,
    required this.isCharging,
    required this.batteryTemperatureCelsius,
    required this.latitude,
    required this.longitude,
    required this.altitudeMeters,
    required this.speedKmh,
    required this.gpsAccuracyMeters,
    required this.gpsStatus,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.motionActivity,
    required this.networkType,
    required this.signalStrength,
    required this.isOffline,
    required this.edgeEngineStatus,
    required this.timestamp,
    this.isSimulated = false,
  });

  /// Factory for standard baseline telemetry (Bengaluru central coordinates)
  factory TelemetryEntity.initial() {
    return TelemetryEntity(
      batteryPercentage: 68.0,
      isCharging: false,
      batteryTemperatureCelsius: 31.5,
      latitude: 12.9352, // Koramangala, Bengaluru
      longitude: 77.6245,
      altitudeMeters: 920.0,
      speedKmh: 42.0,
      gpsAccuracyMeters: 4.2,
      gpsStatus: 'LOCKED',
      accelX: 0.12,
      accelY: 0.05,
      accelZ: 9.81,
      motionActivity: 'CRUISING',
      networkType: '5G-SA',
      signalStrength: 0.92,
      isOffline: false,
      edgeEngineStatus: 'ACTIVE_LOCAL',
      timestamp: DateTime.now(),
      isSimulated: false,
    );
  }

  TelemetryEntity copyWith({
    double? batteryPercentage,
    bool? isCharging,
    double? batteryTemperatureCelsius,
    double? latitude,
    double? longitude,
    double? altitudeMeters,
    double? speedKmh,
    double? gpsAccuracyMeters,
    String? gpsStatus,
    double? accelX,
    double? accelY,
    double? accelZ,
    String? motionActivity,
    String? networkType,
    double? signalStrength,
    bool? isOffline,
    String? edgeEngineStatus,
    DateTime? timestamp,
    bool? isSimulated,
  }) {
    return TelemetryEntity(
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      isCharging: isCharging ?? this.isCharging,
      batteryTemperatureCelsius: batteryTemperatureCelsius ?? this.batteryTemperatureCelsius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      speedKmh: speedKmh ?? this.speedKmh,
      gpsAccuracyMeters: gpsAccuracyMeters ?? this.gpsAccuracyMeters,
      gpsStatus: gpsStatus ?? this.gpsStatus,
      accelX: accelX ?? this.accelX,
      accelY: accelY ?? this.accelY,
      accelZ: accelZ ?? this.accelZ,
      motionActivity: motionActivity ?? this.motionActivity,
      networkType: networkType ?? this.networkType,
      signalStrength: signalStrength ?? this.signalStrength,
      isOffline: isOffline ?? this.isOffline,
      edgeEngineStatus: edgeEngineStatus ?? this.edgeEngineStatus,
      timestamp: timestamp ?? this.timestamp,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }
}
