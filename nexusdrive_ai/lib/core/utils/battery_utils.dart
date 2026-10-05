import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class BatteryUtils {
  BatteryUtils._();

  /// Calculates estimated range in kilometers based on battery percentage and capacity
  static double estimateRangeKm({
    required double batteryPercent,
    required double batteryCapacityKwh,
    double consumptionKwhPerKm = AppConstants.avgConsumptionKwhPerKm,
  }) {
    if (batteryPercent <= 0 || batteryCapacityKwh <= 0) return 0.0;
    final availableKwh = (batteryPercent / 100.0) * batteryCapacityKwh;
    final range = availableKwh / consumptionKwhPerKm;
    return double.parse(range.toStringAsFixed(1));
  }

  /// Calculates remaining battery percentage upon reaching destination
  static double calculateArrivalReserve({
    required double currentBatteryPercent,
    required double energyRequiredKwh,
    required double batteryCapacityKwh,
  }) {
    final currentKwh = (currentBatteryPercent / 100.0) * batteryCapacityKwh;
    final remainingKwh = currentKwh - energyRequiredKwh;
    final reservePercent = (remainingKwh / batteryCapacityKwh) * 100.0;
    return double.parse(reservePercent.toStringAsFixed(1));
  }

  /// Categorizes battery state
  static BatteryRiskLevel assessRisk(double batteryPercent) {
    if (batteryPercent < AppConstants.batteryRescueThresholdPercent) {
      return BatteryRiskLevel.critical;
    } else if (batteryPercent < AppConstants.batteryWarningThresholdPercent) {
      return BatteryRiskLevel.warning;
    }
    return BatteryRiskLevel.nominal;
  }

  /// Returns UI theme color corresponding to battery state
  static Color getStatusColor(double batteryPercent) {
    switch (assessRisk(batteryPercent)) {
      case BatteryRiskLevel.critical:
        return AppColors.batteryCritical;
      case BatteryRiskLevel.warning:
        return AppColors.batteryWarning;
      case BatteryRiskLevel.nominal:
        return AppColors.batterySafe;
    }
  }
}

enum BatteryRiskLevel { nominal, warning, critical }
