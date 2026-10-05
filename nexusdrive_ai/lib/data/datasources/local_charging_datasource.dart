import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/charging_station_model.dart';

abstract class LocalChargingDataSource {
  Future<List<ChargingStationModel>> getAllChargingStations();
  Future<ChargingStationModel?> getChargingStationById(String id);
}

class LocalChargingDataSourceImpl implements LocalChargingDataSource {
  List<ChargingStationModel>? _cachedStations;

  @override
  Future<List<ChargingStationModel>> getAllChargingStations() async {
    if (_cachedStations != null) return _cachedStations!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/charging_stations.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _cachedStations = jsonList
          .map((item) => ChargingStationModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cachedStations!;
    } catch (e) {
      // Fallback empty list if asset error
      return [];
    }
  }

  @override
  Future<ChargingStationModel?> getChargingStationById(String id) async {
    final stations = await getAllChargingStations();
    try {
      return stations.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
