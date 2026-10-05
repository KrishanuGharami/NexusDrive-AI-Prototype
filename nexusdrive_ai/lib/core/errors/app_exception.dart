/// Domain and App Exceptions for NexusDrive AI
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException[$code]: $message';
}

class TelemetryException extends AppException {
  TelemetryException(super.message, {super.code, super.details});
}

class RouteOptimizationException extends AppException {
  RouteOptimizationException(super.message, {super.code, super.details});
}

class BatterySafetyException extends AppException {
  final double currentBattery;
  final double estimatedReserve;

  BatterySafetyException({
    required this.currentBattery,
    required this.estimatedReserve,
    required String message,
  }) : super(message, code: 'CRITICAL_BATTERY_RESERVE');
}
