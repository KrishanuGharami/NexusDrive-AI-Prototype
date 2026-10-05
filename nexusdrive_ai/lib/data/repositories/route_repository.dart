import '../../domain/entities/route.dart';
import '../datasources/local_route_datasource.dart';

abstract class RouteRepository {
  Future<List<RouteEntity>> getAllRoutes();
  Future<List<RouteEntity>> getRoutesForDestination(String destination);
}

class RouteRepositoryImpl implements RouteRepository {
  final LocalRouteDataSource localDataSource;

  RouteRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RouteEntity>> getAllRoutes() async {
    return await localDataSource.getAllRoutes();
  }

  @override
  Future<List<RouteEntity>> getRoutesForDestination(String destination) async {
    return await localDataSource.getRoutesForDestination(destination);
  }
}
