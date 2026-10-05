import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.outfit().fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.cyanAccent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyanAccent,
        secondary: AppColors.electricBlue,
        surface: AppColors.surface,
        error: AppColors.batteryCritical,
        onPrimary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceBorderSubtle,
        thickness: 1,
      ),
    );
  }
}
