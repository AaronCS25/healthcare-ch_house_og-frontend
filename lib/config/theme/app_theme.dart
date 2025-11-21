import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color rimacRed = Color(0xFFE5233D);
  static const Color vibrantPink = Color(0xFFFF0055);
  static const Color rimacRedHover = Color(0xFFC41B2E);
  static const Color rimacRedLight = Color(0xFFFBE8EC);

  // Neutral Colors (Light)
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF9FAFB);
  static const Color mediumGray = Color(0xFFF3F4F6);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color darkGray = Color(0xFF1F2937);
  static const Color darkGrayMuted = Color(0xFF374151);

  // Neutral Colors (Dark)
  static const Color darkBgPrimary = Color(0xFF111827);
  static const Color darkBgSecondary = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Status Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    const String fontName = 'Geist';

    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: fontName,
        fontSize: 36.0,
        height: 40.0 / 36.0,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineLarge: TextStyle(
        fontFamily: fontName,
        fontSize: 30.0,
        height: 36.0 / 30.0,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineMedium: TextStyle(
        fontFamily: fontName,
        fontSize: 24.0,
        height: 32.0 / 24.0,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      titleLarge: TextStyle(
        fontFamily: fontName,
        fontSize: 20.0,
        height: 28.0 / 20.0,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleMedium: TextStyle(
        fontFamily: fontName,
        fontSize: 18.0,
        height: 28.0 / 18.0,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleSmall: TextStyle(
        fontFamily: fontName,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: fontName,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodyMedium: TextStyle(
        fontFamily: fontName,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodySmall: TextStyle(
        fontFamily: fontName,
        fontSize: 12.0,
        height: 16.0 / 12.0,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),

      labelLarge: TextStyle(
        fontFamily: fontName,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),

      labelMedium: TextStyle(
        fontFamily: fontName,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),

      labelSmall: TextStyle(
        fontFamily: fontName,
        fontSize: 12.0,
        height: 16.0 / 12.0,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: rimacRed,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: rimacRed,
        secondary: vibrantPink,
        surface: white,
        onPrimary: white,
        onSurface: darkGray,
        error: errorRed,
        tertiary: mediumGray,
      ),
      textTheme: _buildTextTheme(darkGray, gray500),
      dividerTheme: const DividerThemeData(color: lightGray, thickness: 1),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: rimacRed,
      scaffoldBackgroundColor: darkBgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: rimacRed,
        secondary: vibrantPink,
        surface: darkBgSecondary,
        onPrimary: white,
        onSurface: darkTextPrimary,
        error: errorRed,
        tertiary: darkGrayMuted,
      ),
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),
      dividerTheme: const DividerThemeData(color: darkGrayMuted, thickness: 1),
    );
  }
}
