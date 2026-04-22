import 'package:flutter/material.dart';

/// RefinUp design-system color tokens (tokens.md)
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF818CF8); // Indigo 400
  static const Color primaryContainer = Color(0xFFE0E7FF); // Indigo 100
  static const Color primaryContainerDark = Color(0xFF3730A3); // Indigo 800

  static const Color secondary = Color(0xFF10B981); // Emerald 500
  static const Color secondaryDark = Color(0xFF34D399); // Emerald 400

  static const Color tertiary = Color(0xFFF59E0B); // Amber 500
  static const Color tertiaryDark = Color(0xFFFCD34D); // Amber 300

  // Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceVariant = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceVariantDark = Color(0xFF1E293B); // Slate 800
  static const Color background = Color(0xFFF1F5F9); // Slate 100
  static const Color backgroundDark = Color(0xFF020617); // Slate 950

  // Semantic
  static const Color onSurface = Color(0xFF0F172A); // Slate 900
  static const Color onSurfaceDark = Color(0xFFF8FAFC); // Slate 50
  static const Color onSurfaceVariant = Color(0xFF475569); // Slate 600
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8); // Slate 400
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorDark = Color(0xFFFCA5A5); // Red 300
  static const Color outline = Color(0xFFCBD5E1); // Slate 300
  static const Color outlineDark = Color(0xFF334155); // Slate 700

  // AI Round Role Colors
  static const Color roleCritic = Color(0xFFEF4444); // Red
  static const Color roleOptimist = Color(0xFF10B981); // Emerald
  static const Color rolePragmatist = Color(0xFF6366F1); // Indigo
  static const Color roleDevil = Color(0xFFF59E0B); // Amber

  static Color roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'critic':
        return roleCritic;
      case 'optimist':
        return roleOptimist;
      case 'pragmatist':
        return rolePragmatist;
      case 'devil':
      case "devil's advocate":
        return roleDevil;
      default:
        return primary;
    }
  }
}
