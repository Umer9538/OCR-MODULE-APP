import 'package:flutter/material.dart';

/// MiGynae App Color Palette
/// Extracted from app screenshots for design consistency
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryPink = Color(0xFFC2185B);
  static const Color primaryPinkLight = Color(0xFFE91E63);
  static const Color primaryPinkDark = Color(0xFF880E4F);

  // Secondary Colors
  static const Color darkNavy = Color(0xFF1A237E);
  static const Color darkNavyLight = Color(0xFF303F9F);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFF0F5);
  static const Color backgroundSoftPink = Color(0xFFFCE4EC);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Accent Colors
  static const Color accentMagenta = Color(0xFFE91E63);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPink, primaryPinkLight],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundWhite, backgroundSoftPink],
  );
}
