import 'package:flutter/material.dart';

/// Core Design System and Application Constants for NexusDrive AI
class AppColors {
  AppColors._();

  // Premium Dark EV Theme Palette
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF111726);
  static const Color surfaceElevated = Color(0xFF182032);
  static const Color surfaceCard = Color(0xFF151D2D);
  static const Color surfaceBorder = Color(0xFF23304A);
  static const Color surfaceBorderSubtle = Color(0x1AFFFFFF);

  // Brand Accents
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color cyanGlow = Color(0x3300E5FF);
  static const Color electricBlue = Color(0xFF2979FF);

  // Status & Telemetry
  static const Color batterySafe = Color(0xFF00E676);
  static const Color batteryWarning = Color(0xFFFFB300);
  static const Color batteryCritical = Color(0xFFFF3D57);
  static const Color offlineChip = Color(0xFF651FFF);
  static const Color edgeAiChip = Color(0xFF00B0FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFF0F4FC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textInverse = Color(0xFF090D16);
}

class AppConstants {
  AppConstants._();

  static const String appName = 'NexusDrive AI';
  static const String appTagline = 'Offline-First EV Intelligence & Edge Copilot';
  static const String eventLabel = 'iQOO Hackathon 2026 Grand Finale • Bengaluru';

  // Scoring Weights (Exact formula)
  static const double weightEnergyEfficiency = 0.35;
  static const double weightBatterySafety = 0.25;
  static const double weightTravelTime = 0.20;
  static const double weightConnectivity = 0.10;
  static const double weightChargingFallback = 0.10;

  // Battery Safety Margins
  static const double batteryRescueThresholdPercent = 20.0;
  static const double batteryWarningThresholdPercent = 30.0;
  static const double minimumArrivalReservePercent = 15.0;

  // EV Battery Presets (kWh)
  static const double defaultBatteryCapacityKwh = 40.5; // Typical EV (e.g. Nexon EV Long Range)
  static const double avgConsumptionKwhPerKm = 0.145; // ~145 Wh/km realistic urban/suburban
}
