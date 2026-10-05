import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PermissionUtils {
  PermissionUtils._();

  /// Gracefully checks and requests location permission
  static Future<bool> requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled on device');
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied by user');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission permanently denied');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }
}
