import 'package:flutter/material.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AppTextStyles {
  /// ===== Body Text Styles =====
  static TextStyle get body => TextStyle(
    fontSize: AppSize.mediumFont,
    color: AppColors.onSurface,
    height: 1.5,
  );

  static TextStyle get bodySmall => body.copyWith(fontSize: AppSize.smallFont);
  static TextStyle get bodyLarge => body.copyWith(fontSize: AppSize.largeFont);

  /// ===== Headings =====
  static TextStyle get heading1 => TextStyle(
    fontSize: AppSize.titleFont,
    fontWeight: AppFont.wbold,
    color: AppColors.onSurface,
    height: 1.2,
  );

  static TextStyle get heading2 =>
      heading1.copyWith(fontSize: AppSize.scaleFont(28));

  static TextStyle get heading3 => heading1.copyWith(
    fontSize: AppSize.scaleFont(24),
    fontWeight: AppFont.wregular,
  );

  /// ===== AppBar Title =====
  static TextStyle get appBarTitle => TextStyle(
    fontSize: AppSize.titleFont,
    fontWeight: AppFont.wbold,
    color: AppColors.onSurface,
    letterSpacing: 0.5,
  );

  /// ===== Button Text =====
  static TextStyle get button => TextStyle(
    fontSize: AppSize.largeFont,
    fontWeight: AppFont.wmedium,
    color: AppColors.onPrimary,
    letterSpacing: 0.8,
  );

  static TextStyle get buttonSmall =>
      button.copyWith(fontSize: AppSize.smallFont);
  static TextStyle get buttonLarge =>
      button.copyWith(fontSize: AppSize.largeFont);

  /// ===== Input Fields =====
  static TextStyle get input =>
      TextStyle(fontSize: AppSize.mediumFont, color: AppColors.onSurface);

  static TextStyle get inputLabel => input.copyWith(
    fontSize: AppSize.smallFont,
    color: AppColors.onSurface.withValues(alpha: 0.7),
  );

  static TextStyle get inputHint =>
      inputLabel.copyWith(color: AppColors.onSurface.withValues(alpha: 0.5));

  /// ===== Cards =====
  static TextStyle get cardTitle => TextStyle(
    fontSize: AppSize.largeFont,
    fontWeight: AppFont.wbold,
    color: AppColors.onSurface,
  );

  static TextStyle get cardSubtitle => TextStyle(
    fontSize: AppSize.smallFont,
    color: AppColors.onSurface.withValues(alpha: 0.8),
  );

  /// ===== Special Text Styles =====
  static TextStyle get error =>
      TextStyle(fontSize: AppSize.smallFont, color: AppColors.error);

  static TextStyle get success =>
      TextStyle(fontSize: AppSize.smallFont, color: AppColors.success);

  static TextStyle get link => TextStyle(
    fontSize: AppSize.mediumFont,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  /// ===== Utilities =====
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  static TextStyle withOpacity(TextStyle style, double opacity) =>
      style.copyWith(color: style.color?.withValues(alpha: opacity));
}
