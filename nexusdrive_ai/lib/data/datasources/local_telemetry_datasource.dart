import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/telemetry_model.dart';

abstract class LocalTelemetryDataSource {
  Future<void> cacheTelemetry(TelemetryModel telemetry);
  Future<TelemetryModel?> getCachedTelemetry();
}

class LocalTelemetryDataSourceImpl implements LocalTelemetryDataSource {
  static const String _telemetryKey = 'cached_telemetry_snapshot';
  TelemetryModel? _memorySnapshot;

  @override
  Future<void> cacheTelemetry(TelemetryModel telemetry) async {
    _memorySnapshot = telemetry;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_telemetryKey, json.encode(telemetry.toJson()));
    } catch (_) {
      // Graceful fallback to memory
    }
  }

  @override
  Future<TelemetryModel?> getCachedTelemetry() async {
    if (_memorySnapshot != null) return _memorySnapshot;

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_telemetryKey);
      if (jsonString != null) {
        final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;
        _memorySnapshot = TelemetryModel.fromJson(data);
        return _memorySnapshot;
      }
    } catch (_) {}
    return null;
  }
}
