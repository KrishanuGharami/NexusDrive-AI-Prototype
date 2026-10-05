import '../../core/utils/distance_utils.dart';
import '../../domain/entities/charging_station.dart';
import '../datasources/local_charging_datasource.dart';

abstract class ChargingRepository {
  Future<List<ChargingStation>> getAllChargingStations();
  Future<ChargingStation?> getChargingStationById(String id);
  Future<List<ChargingStation>> getNearestStations({
    required double latitude,
    required double longitude,
    int limit = 3,
  });
}

class ChargingRepositoryImpl implements ChargingRepository {
  final LocalChargingDataSource localDataSource;

  ChargingRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ChargingStation>> getAllChargingStations() async {
    return await localDataSource.getAllChargingStations();
  }

  @override
  Future<ChargingStation?> getChargingStationById(String id) async {
    return await localDataSource.getChargingStationById(id);
  }

  @override
  Future<List<ChargingStation>> getNearestStations({
    required double latitude,
    required double longitude,
    int limit = 3,
  }) async {
    final stations = await getAllChargingStations();
    if (stations.isEmpty) return [];

    // Sort by distance to given coordinates
    final sorted = List<ChargingStation>.from(stations)
      ..sort((a, b) {
        final distA = DistanceUtils.haversineDistanceKm(
          lat1: latitude,
          lon1: longitude,
          lat2: a.latitude,
          lon2: a.longitude,
        );
        final distB = DistanceUtils.haversineDistanceKm(
          lat1: latitude,
          lon1: longitude,
          lat2: b.latitude,
          lon2: b.longitude,
        );
        return distA.compareTo(distB);
      });

    return sorted.take(limit).toList();
  }
}
