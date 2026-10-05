import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionSnapshot {
  final double x;
  final double y;
  final double z;
  final String activityState;

  const MotionSnapshot({
    required this.x,
    required this.y,
    required this.z,
    required this.activityState,
  });
}

class MotionService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  Function(MotionSnapshot)? _listener;

  void startListening(Function(MotionSnapshot) onMotion) {
    _listener = onMotion;
    try {
      _subscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          final x = double.parse(event.x.toStringAsFixed(2));
          final y = double.parse(event.y.toStringAsFixed(2));
          final z = double.parse(event.z.toStringAsFixed(2));

          // Simple dynamic motion classification
          String activity = 'CRUISING';
          if (y < -2.0) {
            activity = 'REGEN_BRAKING';
          } else if (y > 2.0) {
            activity = 'ACCELERATING';
          } else if (x.abs() > 3.0) {
            activity = 'TURNING';
          } else if (x.abs() < 0.5 && y.abs() < 0.5 && (z - 9.8).abs() < 0.8) {
            activity = 'STATIONARY';
          }

          _listener?.call(
            MotionSnapshot(
              x: x,
              y: y,
              z: z,
              activityState: activity,
            ),
          );
        },
        onError: (e) {
          debugPrint('Motion sensors stream error: $e');
        },
      );
    } catch (e) {
      debugPrint('MotionService subscription error: $e');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
