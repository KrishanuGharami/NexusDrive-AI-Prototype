import 'package:flutter_test/flutter_test.dart';
import 'package:nexusdrive_ai/core/utils/battery_utils.dart';
import 'package:nexusdrive_ai/domain/entities/route.dart';
import 'package:nexusdrive_ai/domain/services/battery_safety_service.dart';

void main() {
  group('BatterySafetyService & BatteryUtils Tests', () {
    late BatterySafetyService safetyService;
    late RouteEntity sampleRoute;

    setUp(() {
      safetyService = BatterySafetyService();
      sampleRoute = const RouteEntity(
        id: 'rt_test',
        origin: 'Origin',
        destination: 'Dest',
        title: 'Test Route',
        routeType: 'Energy Efficient',
        distanceKm: 30.0,
        estimatedTimeMinutes: 40,
        baseEnergyKwh: 4.5,
        elevationGainMeters: 30.0,
        elevationLossMeters: 30.0,
        trafficCongestionMultiplier: 1.0,
        connectivityReliability: 0.9,
        fallbackChargerIds: ['cs1'],
        waypoints: ['A', 'B'],
        roadGradeDescription: 'Flat',
      );
    });

    test('BatteryUtils.estimateRangeKm calculates accurate mileage', () {
      final range = BatteryUtils.estimateRangeKm(
        batteryPercent: 80.0,
        batteryCapacityKwh: 40.5,
        consumptionKwhPerKm: 0.145,
      );
      // 80% of 40.5 = 32.4 kWh. 32.4 / 0.145 = ~223.4 km
      expect(range, closeTo(223.4, 0.5));
    });

    test('BatteryUtils.calculateArrivalReserve correctly subtracts consumed energy', () {
      final reserve = BatteryUtils.calculateArrivalReserve(
        currentBatteryPercent: 50.0,
        energyRequiredKwh: 4.05, // exactly 10% of 40.5 kWh
        batteryCapacityKwh: 40.5,
      );
      expect(reserve, closeTo(40.0, 0.1));
    });

    test('BatterySafetyService assesses nominal safety when battery is healthy', () {
      final audit = safetyService.assessRouteSafety(
        route: sampleRoute,
        currentBatteryPercent: 80.0,
        batteryCapacityKwh: 40.5,
      );

      expect(audit.isRescueRequired, isFalse);
      expect(audit.isWarningActive, isFalse);
      expect(audit.deficitPercent, equals(0.0));
      expect(audit.safetyStatusSummary.contains('NOMINAL'), isTrue);
    });

    test('BatterySafetyService triggers rescue required when reserve violates threshold', () {
      final audit = safetyService.assessRouteSafety(
        route: sampleRoute,
        currentBatteryPercent: 18.0, // Low starting battery
        batteryCapacityKwh: 40.5,
      );

      expect(audit.isRescueRequired, isTrue);
      expect(audit.safetyStatusSummary.contains('CRITICAL'), isTrue);
    });
  });
}
