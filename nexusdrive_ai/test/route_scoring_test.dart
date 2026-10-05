import 'package:flutter_test/flutter_test.dart';
import 'package:nexusdrive_ai/domain/entities/route.dart';
import 'package:nexusdrive_ai/domain/services/route_scoring_service.dart';

void main() {
  group('RouteScoringService Tests', () {
    late RouteScoringService scoringService;
    late List<RouteEntity> sampleRoutes;

    setUp(() {
      scoringService = RouteScoringService();
      sampleRoutes = [
        const RouteEntity(
          id: 'rt_fast',
          origin: 'Origin',
          destination: 'Dest',
          title: 'Fast Highway Route',
          routeType: 'Fastest',
          distanceKm: 20.0,
          estimatedTimeMinutes: 20,
          baseEnergyKwh: 4.8, // High energy
          elevationGainMeters: 50.0,
          elevationLossMeters: 10.0,
          trafficCongestionMultiplier: 1.0,
          connectivityReliability: 0.90,
          fallbackChargerIds: ['cs1'],
          waypoints: ['A', 'B'],
          roadGradeDescription: 'Expressway',
        ),
        const RouteEntity(
          id: 'rt_eco',
          origin: 'Origin',
          destination: 'Dest',
          title: 'Energy Efficient Route',
          routeType: 'Energy Efficient',
          distanceKm: 18.0,
          estimatedTimeMinutes: 30, // Slower
          baseEnergyKwh: 2.5, // Low energy
          elevationGainMeters: 20.0,
          elevationLossMeters: 25.0,
          trafficCongestionMultiplier: 1.1,
          connectivityReliability: 0.92,
          fallbackChargerIds: ['cs1', 'cs2', 'cs3'],
          waypoints: ['A', 'C', 'B'],
          roadGradeDescription: 'City arterial',
        ),
        const RouteEntity(
          id: 'rt_cell_safe',
          origin: 'Origin',
          destination: 'Dest',
          title: 'Cellular Safe Route',
          routeType: 'Low Connectivity Safe',
          distanceKm: 22.0,
          estimatedTimeMinutes: 25,
          baseEnergyKwh: 3.5,
          elevationGainMeters: 30.0,
          elevationLossMeters: 20.0,
          trafficCongestionMultiplier: 1.05,
          connectivityReliability: 0.99,
          fallbackChargerIds: ['cs1', 'cs2'],
          waypoints: ['A', 'D', 'B'],
          roadGradeDescription: 'Spine road',
        ),
      ];
    });

    test('High battery (80%) with Fastest preference favors Fastest route', () {
      final ranked = scoringService.scoreAndRankRoutes(
        candidates: sampleRoutes,
        currentBatteryPercent: 80.0,
        batteryCapacityKwh: 40.5,
        drivingPreference: 'Fastest',
      );

      expect(ranked.isNotEmpty, isTrue);
      expect(ranked.first.routeType, equals('Fastest'));
      expect(ranked.first.isRecommended, isTrue);
      expect(ranked.first.totalScore, greaterThan(0.0));
    });

    test('Low battery (20%) automatically switches recommended route to Energy Efficient / Battery Safe', () {
      final rankedLowBattery = scoringService.scoreAndRankRoutes(
        candidates: sampleRoutes,
        currentBatteryPercent: 20.0,
        batteryCapacityKwh: 40.5,
        drivingPreference: 'Fastest', // Even if user requested Fastest!
      );

      expect(rankedLowBattery.isNotEmpty, isTrue);
      // Because 20% triggers safety modulation, high energy route cannot win
      expect(rankedLowBattery.first.id, equals('rt_eco'));
      expect(rankedLowBattery.first.isRecommended, isTrue);
    });

    test('All factors are normalized properly between 0.0 and 1.0', () {
      final ranked = scoringService.scoreAndRankRoutes(
        candidates: sampleRoutes,
        currentBatteryPercent: 50.0,
        batteryCapacityKwh: 40.5,
        drivingPreference: 'Energy Efficient',
      );

      for (final r in ranked) {
        expect(r.totalScore, inInclusiveRange(0.0, 1.0));
        expect(r.energyEfficiencyScore, inInclusiveRange(0.0, 1.0));
        expect(r.batterySafetyScore, inInclusiveRange(0.0, 1.0));
        expect(r.travelTimeScore, inInclusiveRange(0.0, 1.0));
        expect(r.connectivityScore, inInclusiveRange(0.0, 1.0));
        expect(r.chargingFallbackScore, inInclusiveRange(0.0, 1.0));
      }
    });

    test('Explanation text is generated dynamically and mentions arrival reserve', () {
      final ranked = scoringService.scoreAndRankRoutes(
        candidates: sampleRoutes,
        currentBatteryPercent: 60.0,
        batteryCapacityKwh: 40.5,
      );

      final top = ranked.first;
      expect(top.explanation.isNotEmpty, isTrue);
      expect(top.explanation.contains('%'), isTrue);
    });
  });
}
