import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/route_model.dart';

abstract class LocalRouteDataSource {
  Future<List<RouteModel>> getAllRoutes();
  Future<List<RouteModel>> getRoutesForDestination(String destination);
}

class LocalRouteDataSourceImpl implements LocalRouteDataSource {
  List<RouteModel>? _cachedRoutes;

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    if (_cachedRoutes != null) return _cachedRoutes!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/routes.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _cachedRoutes = jsonList
          .map((item) => RouteModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cachedRoutes!;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<RouteModel>> getRoutesForDestination(String destination) async {
    final routes = await getAllRoutes();
    final normalized = destination.toLowerCase().trim();
    final matched = routes.where((r) {
      return r.destination.toLowerCase().contains(normalized) ||
          normalized.contains(r.destination.toLowerCase());
    }).toList();

    // If destination matches none exactly, return all routes for the closest default
    if (matched.isEmpty && routes.isNotEmpty) {
      return routes.take(3).toList();
    }
    return matched;
  }
}
