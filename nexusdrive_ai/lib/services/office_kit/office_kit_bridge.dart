import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/telemetry.dart';

enum OfficeKitSyncStatus {
  disconnected,
  discovering,
  connected,
  transferring,
  synced,
}

class OfficeKitDeviceInfo {
  final String deviceName;
  final String ipAddress;
  final String protocolVersion;
  final bool isPaired;

  const OfficeKitDeviceInfo({
    required this.deviceName,
    required this.ipAddress,
    required this.protocolVersion,
    required this.isPaired,
  });
}

/// Bridge abstraction for iQOO/vivo Office Kit & PC Multi-Screen Collaboration
class OfficeKitBridge {
  OfficeKitSyncStatus _status = OfficeKitSyncStatus.connected;
  final OfficeKitDeviceInfo _pairedDevice = const OfficeKitDeviceInfo(
    deviceName: 'iQOO Workstation Book (Bengaluru Lab)',
    ipAddress: '192.168.1.104:8848',
    protocolVersion: 'v2.4-vivoSync',
    isPaired: true,
  );

  OfficeKitSyncStatus get status => _status;
  OfficeKitDeviceInfo get pairedDevice => _pairedDevice;

  /// Simulates syncing live route telemetry to paired PC presentation display
  Future<bool> broadcastRouteToPresentationScreen({
    required RouteEntity route,
    required TelemetryEntity telemetry,
  }) async {
    _status = OfficeKitSyncStatus.transferring;

    final payload = {
      'event': 'NEXUS_ROUTE_TELEMETRY_SYNC',
      'device': 'iQOO 12 Pro 5G',
      'timestamp': DateTime.now().toIso8601String(),
      'route': {
        'title': route.title,
        'distanceKm': route.distanceKm,
        'durationMinutes': route.estimatedTimeMinutes,
        'arrivalBatteryPercent': route.estimatedArrivalReserve,
        'score': route.totalScore,
        'waypoints': route.waypoints,
      },
      'telemetry': {
        'battery': telemetry.batteryPercentage,
        'speedKmh': telemetry.speedKmh,
        'signal': telemetry.networkType,
      },
    };

    // Copy to system clipboard for instant pasting on connected PC via Office Kit unified clipboard
    try {
      await Clipboard.setData(ClipboardData(text: json.encode(payload)));
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 600));
    _status = OfficeKitSyncStatus.synced;
    return true;
  }
}
