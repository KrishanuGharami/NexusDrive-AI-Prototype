import 'dart:math' as math;

class DistanceUtils {
  DistanceUtils._();

  /// Calculates Haversine distance between two coordinates in kilometers
  static double haversineDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return double.parse((earthRadiusKm * c).toStringAsFixed(2));
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Formats travel duration nicely
  static String formatDurationMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }
}
