import 'package:flutter/material.dart';
import 'package:my_fuel/shared/theme/ThemeController.dart';

class AppColors {
  // Main colors
  static const Color primary = Color(0xFF5B9C40);
  static const Color secondary = Color(0xFF4C956C);
  static const Color tertiary = Color(0xFFB5E48C);
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF0288D1);

  // Active theme colors
  static ThemeColors get _active =>
      ThemeController.instance.isDarkMode ? darkColors : lightColors;

  // Theme-based colors
  static Color get background => _active.background;
  static Color get backgroundInverse => _active.backgroundInverse;
  static Color get surface => _active.surface;
  static Color get onSurface => _active.onSurface;
  static Color get onPrimary => _active.onPrimary;
  static Color get outline => _active.outline;

  static Color get primaryContainer => _active.primaryContainer;
  static Color get onPrimaryContainer => _active.onPrimaryContainer;
  static Color get onTertiary => _active.onTertiary;
  static Color get onError => _active.onError;

  // Light theme
  static const ThemeColors lightColors = ThemeColors(
    background: Color(0xFFF8FDF8),
    backgroundInverse: Color(0xFF121212),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1B1C18),
    onPrimary: Colors.white,
    outline: Color(0xFF73796E),
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    onTertiary: Color(0xFFB71C1C),
    onError: Colors.white,
  );

  // Dark theme
  static const ThemeColors darkColors = ThemeColors(
    background: Color(0xFF121212),
    backgroundInverse: Color(0xFFF8FDF8),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE3E3E3),
    onPrimary: Colors.white,
    outline: Color(0xFF8D9387),
    primaryContainer: Color(0xFF0D47A1),
    onPrimaryContainer: Color(0xFFBBDEFB),
    onTertiary: Color(0xFFEF9A9A),
    onError: Colors.black,
  );

  static var grey = onError; //TODO

  static var greyLight = onError; //TODO

  // Primary color swatch (Material)
  static MaterialColor get primarySwatch => MaterialColor(
    // ignore: deprecated_member_use
    primary.red << 16 | primary.green << 8 | primary.blue,
    const {
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: primary,
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  // Dynamic color by theme
  static Color dynamicColor({required Color light, required Color dark}) =>
      ThemeController.instance.isDarkMode ? dark : light;

  // Auto text color for backgrounds
  static Color textColorForBackground(Color background) =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

// Public theme color model
class ThemeColors {
  final Color background;
  final Color backgroundInverse;
  final Color surface;
  final Color onSurface;
  final Color onPrimary;
  final Color outline;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color onTertiary;
  final Color onError;

  const ThemeColors({
    required this.background,
    required this.backgroundInverse,
    required this.surface,
    required this.onSurface,
    required this.onPrimary,
    required this.outline,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.onTertiary,
    required this.onError,
  });
}
