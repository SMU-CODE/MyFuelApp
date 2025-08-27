import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_fuel/shared/theme/app_theme.dart';

class ThemeController extends GetxService {
  static ThemeController get instance => Get.find();

  final GetStorage _box = GetStorage();
  static const String _themeModeKey = 'themeMode';

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  ThemeData get currentTheme =>
      isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  Future<ThemeController> init() async {
    await _loadTheme();
    return this;
  }

  Future<void> _loadTheme() async {
    try {
      final savedMode = _box.read<String>(_themeModeKey);
      _themeMode.value = _parseThemeMode(savedMode);
    } catch (_) {
      _themeMode.value = ThemeMode.system;
    }
    _updateTheme();
  }

  void toggleTheme() {
    _themeMode.value = _nextThemeMode();
    _box.write(_themeModeKey, _themeMode.value.toString());
    _updateTheme();
  }

  void _updateTheme() {
    Get.forceAppUpdate();
    Get.changeThemeMode(_themeMode.value);
  }

  ThemeMode _nextThemeMode() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.light;
      case ThemeMode.system:
        if (isDarkMode) {
          return ThemeMode.light;
        } else {
          return ThemeMode.dark;
        }
    }
  }

  ThemeMode _parseThemeMode(String? mode) {
    if (mode == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == mode,
      orElse: () => ThemeMode.system,
    );
  }
}
