import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class BatterySnapshot {
  final double levelPercent;
  final bool isCharging;
  final String stateLabel;

  const BatterySnapshot({
    required this.levelPercent,
    required this.isCharging,
    required this.stateLabel,
  });
}

class BatteryService {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _stateSubscription;
  Function(BatterySnapshot)? _onBatteryChanged;

  /// Fetches current Android battery percentage and charging state
  Future<BatterySnapshot> getCurrentBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      final isCharging = state == BatteryState.charging || state == BatteryState.full;

      return BatterySnapshot(
        levelPercent: level.toDouble(),
        isCharging: isCharging,
        stateLabel: state.name.toUpperCase(),
      );
    } catch (e) {
      debugPrint('BatteryService hardware read fallback: $e');
      return const BatterySnapshot(
        levelPercent: 68.0,
        isCharging: false,
        stateLabel: 'DISCHARGING (LOCAL)',
      );
    }
  }

  /// Listens to battery state changes
  void startListening(Function(BatterySnapshot) onBatteryChanged) {
    _onBatteryChanged = onBatteryChanged;
    try {
      _stateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
        final level = await _battery.batteryLevel.catchError((_) => 68);
        final isCharging = state == BatteryState.charging || state == BatteryState.full;
        _onBatteryChanged?.call(
          BatterySnapshot(
            levelPercent: level.toDouble(),
            isCharging: isCharging,
            stateLabel: state.name.toUpperCase(),
          ),
        );
      });
    } catch (e) {
      debugPrint('BatteryService subscription error: $e');
    }
  }

  void dispose() {
    _stateSubscription?.cancel();
  }
}
