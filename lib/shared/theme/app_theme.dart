import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AppTheme {
  /// [Public Themes]
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  /// [Core Theme Builder]
  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final overlayStyle =
        isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppFont.primaryFont,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.outline,
      ),

      // ===== AppBar Theme =====
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        systemOverlayStyle: overlayStyle,
        titleTextStyle: TextStyle(
          fontSize: AppSize.titleFont,
          fontWeight: AppFont.wbold,
          fontFamily: AppFont.primaryFont,
        ),
      ),

      // ===== ElevatedButton Theme =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: AppSize.buttonSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusMedium),
          ),
          textStyle: TextStyle(
            fontSize: AppSize.mediumFont,
            fontFamily: AppFont.primaryFont,
          ),
        ),
      ),

      // ===== InputDecoration Theme =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: AppSize.mediumFont,
          fontWeight: AppFont.wregular,
        ),
        hintStyle: TextStyle(
          color: AppColors.onSurface.withValues(alpha: 0.6),
          fontSize: AppSize.smallFont,
          fontWeight: AppFont.wlight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: AppSize.paddingAll,
      ),

      // ===== Icon Theme =====
      iconTheme: IconThemeData(color: AppColors.primary),

      // ===== Divider Theme =====
      dividerTheme: DividerThemeData(
        color: AppColors.outline.withValues(alpha: 0.6),
        thickness: 1,
      ),

      // ===== Text Theme =====
      textTheme: TextTheme(
        bodySmall: TextStyle(
          fontSize: AppSize.smallFont,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSize.mediumFont,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSize.largeFont,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: AppSize.titleFont,
          color: AppColors.onSurface,
          fontWeight: AppFont.wbold,
        ),
      ),
    );
  }
}
