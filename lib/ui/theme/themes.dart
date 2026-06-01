import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static const Color _lightSeed = Color(0xFFB0BEC5);
  static const Color _darkSeed = Color(0xFF1A237E);

  static final ThemeData lightTheme = _build(
    ColorScheme.fromSeed(seedColor: _lightSeed, brightness: Brightness.light),
  );

  static final ThemeData darkTheme = _build(
    ColorScheme.fromSeed(seedColor: _darkSeed, brightness: Brightness.dark),
  );

  static ThemeData _build(ColorScheme scheme) {
    final onBackground = scheme.onSurface;

    final textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 100, fontWeight: FontWeight.w200, color: onBackground),
      displayMedium: TextStyle(fontSize: 56, fontWeight: FontWeight.w200, color: onBackground),
      headlineMedium: TextStyle(fontSize: 20, color: onBackground),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onBackground),
      titleMedium: TextStyle(fontSize: 18, color: onBackground),
      bodyLarge: TextStyle(fontSize: 16, color: onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: onBackground,
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: onBackground),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
