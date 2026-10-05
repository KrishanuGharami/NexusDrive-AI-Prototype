import '../../data/repositories/route_repository.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/telemetry.dart';
import '../../domain/services/battery_rescue_service.dart';
import 'edge_inference_engine.dart';
import 'explanation_service.dart';

class RouteAiService {
  final RouteRepository routeRepository;
  final EdgeInferenceEngine edgeEngine;
  final BatteryRescueService rescueService;
  final ExplanationService explanationService;

  RouteAiService({
    required this.routeRepository,
    required this.edgeEngine,
    required this.rescueService,
    required this.explanationService,
  });

  /// Evaluates routes for a specified destination using local offline edge intelligence
  Future<RouteRecommendation> analyzeRoutesForDestination({
    required String destination,
    required TelemetryEntity telemetry,
    required double batteryCapacityKwh,
    String drivingPreference = 'Energy Efficient',
  }) async {
    final candidateRoutes = await routeRepository.getRoutesForDestination(destination);
    if (candidateRoutes.isEmpty) {
      throw Exception('No routes found in local database for: $destination');
    }

    return await edgeEngine.evaluateRoutes(
      candidateRoutes: candidateRoutes,
      telemetry: telemetry,
      batteryCapacityKwh: batteryCapacityKwh,
      drivingPreference: drivingPreference,
    );
  }

  /// Triggers emergency battery rescue calculation
  Future<BatteryRescuePlan> calculateEmergencyRescue({
    required TelemetryEntity telemetry,
    required double batteryCapacityKwh,
    required RouteEntity currentRoute,
  }) async {
    return await rescueService.computeRescuePlan(
      currentLatitude: telemetry.latitude,
      currentLongitude: telemetry.longitude,
      currentBatteryPercent: telemetry.batteryPercentage,
      batteryCapacityKwh: batteryCapacityKwh,
      originalRoute: currentRoute,
    );
  }
}
