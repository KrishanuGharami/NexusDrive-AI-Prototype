import '../../core/constants/app_constants.dart';
import '../../core/utils/battery_utils.dart';
import '../entities/route.dart';

class BatterySafetyAudit {
  final bool isRescueRequired;
  final bool isWarningActive;
  final double currentBatteryPercent;
  final double estimatedArrivalReserve;
  final double deficitPercent;
  final String safetyStatusSummary;

  const BatterySafetyAudit({
    required this.isRescueRequired,
    required this.isWarningActive,
    required this.currentBatteryPercent,
    required this.estimatedArrivalReserve,
    required this.deficitPercent,
    required this.safetyStatusSummary,
  });
}

class BatterySafetyService {
  /// Assesses if a route is safe to traverse under current battery conditions
  BatterySafetyAudit assessRouteSafety({
    required RouteEntity route,
    required double currentBatteryPercent,
    required double batteryCapacityKwh,
  }) {
    final arrivalReserve = BatteryUtils.calculateArrivalReserve(
      currentBatteryPercent: currentBatteryPercent,
      energyRequiredKwh: route.baseEnergyKwh * route.trafficCongestionMultiplier,
      batteryCapacityKwh: batteryCapacityKwh,
    );

    final isRescueRequired = currentBatteryPercent < AppConstants.batteryRescueThresholdPercent ||
        arrivalReserve < AppConstants.minimumArrivalReservePercent;

    final isWarningActive = currentBatteryPercent < AppConstants.batteryWarningThresholdPercent ||
        arrivalReserve < 20.0;

    final deficitPercent = arrivalReserve < AppConstants.minimumArrivalReservePercent
        ? (AppConstants.minimumArrivalReservePercent - arrivalReserve)
        : 0.0;

    String summary;
    if (isRescueRequired) {
      summary = 'CRITICAL: Arrival reserve (${arrivalReserve.toStringAsFixed(1)}%) is below safe limits. Divert to charging fallback.';
    } else if (isWarningActive) {
      summary = 'CAUTION: Moderate reserve (${arrivalReserve.toStringAsFixed(1)}%). Avoid aggressive acceleration.';
    } else {
      summary = 'NOMINAL: Safe battery margin (${arrivalReserve.toStringAsFixed(1)}% at arrival).';
    }

    return BatterySafetyAudit(
      isRescueRequired: isRescueRequired,
      isWarningActive: isWarningActive,
      currentBatteryPercent: currentBatteryPercent,
      estimatedArrivalReserve: arrivalReserve,
      deficitPercent: double.parse(deficitPercent.toStringAsFixed(1)),
      safetyStatusSummary: summary,
    );
  }
}
