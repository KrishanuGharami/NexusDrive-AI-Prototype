import 'package:flutter_test/flutter_test.dart';
import 'package:nexusdrive_ai/data/repositories/charging_repository.dart';
import 'package:nexusdrive_ai/domain/entities/charging_station.dart';
import 'package:nexusdrive_ai/domain/entities/route.dart';
import 'package:nexusdrive_ai/domain/services/battery_rescue_service.dart';

class MockChargingRepository implements ChargingRepository {
  final List<ChargingStation> stations;
  MockChargingRepository(this.stations);

  @override
  Future<List<ChargingStation>> getAllChargingStations() async => stations;

  @override
  Future<ChargingStation?> getChargingStationById(String id) async {
    try {
      return stations.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ChargingStation>> getNearestStations({
    required double latitude,
    required double longitude,
    int limit = 3,
  }) async {
    return stations.take(limit).toList();
  }
}

void main() {
  group('BatteryRescueService Tests', () {
    late BatteryRescueService rescueService;
    late MockChargingRepository mockRepo;
    late RouteEntity sampleRoute;

    setUp(() {
      final mockStations = [
        const ChargingStation(
          id: 'cs_fast_1',
          name: 'Central 60kW DC Hub',
          address: 'Main St',
          latitude: 12.9355,
          longitude: 77.6250,
          connectorTypes: ['CCS2'],
          powerKw: 60.0,
          totalPorts: 4,
          availablePorts: 2,
          status: 'OPERATIONAL',
          pricingPerKwh: 18.0,
          reliabilityScore: 0.95,
          amenities: ['Cafe'],
        ),
        const ChargingStation(
          id: 'cs_slow_2',
          name: 'Slow 15kW AC Post',
          address: 'Sub St',
          latitude: 12.9500,
          longitude: 77.6300,
          connectorTypes: ['Type 2'],
          powerKw: 15.0,
          totalPorts: 2,
          availablePorts: 1,
          status: 'OPERATIONAL',
          pricingPerKwh: 14.0,
          reliabilityScore: 0.85,
          amenities: [],
        ),
      ];

      mockRepo = MockChargingRepository(mockStations);
      rescueService = BatteryRescueService(chargingRepository: mockRepo);

      sampleRoute = const RouteEntity(
        id: 'rt_original',
        origin: 'Origin',
        destination: 'Long Distance Dest',
        title: 'Original Direct Route',
        routeType: 'Fastest',
        distanceKm: 45.0,
        estimatedTimeMinutes: 50,
        baseEnergyKwh: 7.2,
        elevationGainMeters: 50.0,
        elevationLossMeters: 30.0,
        trafficCongestionMultiplier: 1.1,
        connectivityReliability: 0.9,
        fallbackChargerIds: ['cs_fast_1'],
        waypoints: ['A', 'B'],
        roadGradeDescription: 'Expressway',
      );
    });

    test('computeRescuePlan selects high-power fast charger and recalculates feasible route', () async {
      final plan = await rescueService.computeRescuePlan(
        currentLatitude: 12.9352,
        currentLongitude: 77.6245,
        currentBatteryPercent: 15.0,
        batteryCapacityKwh: 40.5,
        originalRoute: sampleRoute,
      );

      expect(plan.isFeasible, isTrue);
      expect(plan.recommendedStation.id, equals('cs_fast_1'));
      expect(plan.recalculatedRoute.waypoints.any((w) => w.contains('⚡')), isTrue);
      expect(plan.recalculatedRoute.routeType, equals('Battery Rescue Divert'));
      expect(plan.explanation.contains('Battery Rescue Active'), isTrue);
    });
  });
}
