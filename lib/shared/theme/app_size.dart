import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class AppSize {
  /// [Device Breakpoints]
  static const double _smallDeviceBreakpoint = 375;
  static const double _mediumDeviceBreakpoint = 768;
  static const double qrCodeImageSize = 250.0; // يمكنك تعديل القيمة حسب حاجتك
  /// [Device Type Getters]
  static bool get isSmallDevice => screenWidth < _smallDeviceBreakpoint;
  static bool get isMediumDevice =>
      screenWidth >= _smallDeviceBreakpoint &&
      screenWidth < _mediumDeviceBreakpoint;
  static bool get isLargeDevice => screenWidth >= _mediumDeviceBreakpoint;

  /// [Scaling Methods]
  static double scaleFont(double size, {bool debugLog = false}) {
    final scaled = size.sp;
    if (debugLog) scalingLog('Font', size, scaled);
    return scaled;
  }

  static double scaleWidth(double size, {bool debugLog = false}) {
    final scaled = size.w;
    if (debugLog) scalingLog('Width', size, scaled);
    return scaled;
  }

  static double scaleHeight(double size, {bool debugLog = false}) {
    final scaled = size.h;
    if (debugLog) scalingLog('Height', size, scaled);
    return scaled;
  }

  static double scaleRadius(double size, {bool debugLog = false}) {
    final scaled = size.r;
    if (debugLog) scalingLog('Radius', size, scaled);
    return scaled;
  }

  /// [Standard Sizes]
  static double get iconSmall => scaleWidth(25);
  static double get iconMedium => scaleWidth(30);
  static double get iconLarge => scaleWidth(35);

  static double get radiusSmall => scaleRadius(6);
  static double get radiusMedium => scaleRadius(10);
  static double get radiusLarge => scaleRadius(16);
  static double get radiusCircle => scaleRadius(1000);

  static BorderRadius get borderRadius => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge =>
      BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusSmall =>
      BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium =>
      BorderRadius.circular(radiusMedium);
      

  static double get spacingSmall => scaleWidth(8);
  static double get spacingMedium => scaleWidth(16);
  static double get spacingLarge => scaleWidth(24);

  static double get verticalSpacing => scaleHeight(12);
  static double get verticalSpacingLarge => scaleHeight(20);

  static EdgeInsets get paddingAll => EdgeInsets.all(spacingMedium);
  static EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: spacingMedium);
  static EdgeInsets get paddingVertical =>
      EdgeInsets.symmetric(vertical: verticalSpacing);
  static EdgeInsets get paddingSmall => EdgeInsets.all(spacingSmall);
  static EdgeInsets get paddingLarge => EdgeInsets.all(spacingLarge);

  static EdgeInsets get paddingMedium => EdgeInsets.all(spacingMedium);

  /// [Component Sizes]
  static double get buttonHeight => scaleHeight(50);
  static double get buttonWidth => scaleWidth(140);
  static double get inputHeight => scaleHeight(48);

  /// [Cards & Avatars]
  static double get cardHeight => screenHeight * 0.2;
  static double get avatarSmall => scaleWidth(28);
  static double get avatarMedium => scaleWidth(40);
  static double get avatarLarge => scaleWidth(64);

  static Size dynamicSize({double? width, double? height}) =>
      Size(width ?? buttonWidth, height ?? buttonHeight);

  static Size get buttonSize => Size(buttonWidth, buttonHeight);
  static Size get avatarSize => Size.square(avatarMedium);
  static Size get avatarSizeLarge => Size.square(avatarLarge);
  static Size get cardSize => Size(screenWidth, cardHeight);

  static BoxConstraints get maxCardConstraints =>
      BoxConstraints(maxWidth: screenWidth, minHeight: cardHeight);

  static BoxConstraints get squareButtonConstraints =>
      BoxConstraints.tight(buttonSize);

  static BoxConstraints get imagePreviewConstraints =>
      BoxConstraints(maxHeight: scaleHeight(180), maxWidth: screenWidth * 0.85);

  static EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: _horizontalPagePadding,
    vertical: _verticalPagePadding,
  );

  static double get _horizontalPagePadding {
    if (isSmallDevice) return scaleWidth(12);
    if (isMediumDevice) return scaleWidth(20);
    return scaleWidth(32);
  }

  static double get _verticalPagePadding {
    if (isSmallDevice) return scaleHeight(12);
    if (isMediumDevice) return scaleHeight(20);
    return scaleHeight(32);
  }

  /// [Screen Info]
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;
  static double? get screenDensity => ScreenUtil().pixelRatio;

  /// Font Sizes (Scaled)
  static double get captionFont => scaleFont(12);
  static double get smallFont => scaleFont(13);
  static double get mediumFont => scaleFont(14.3);
  static double get subtitleFont => scaleFont(15);
  static double get largeFont => scaleFont(17);
  static double get titleFont => scaleFont(20);

  /// [Additional Elevation Values]
  static double get elevationNone => 0;
  static double get elevationSmall => 1;
  static double get elevationMedium => 2;
  static double get elevationLarge => 4;

  /// [Additional Spacing Values]
  static double get spacingExtraSmall => scaleWidth(4);
  static double get spacingExtraLarge => scaleWidth(32);

  /// [Additional Icon Sizes]
  static double get iconExtraSmall => scaleWidth(20);
  static double get iconExtraLarge => scaleWidth(40);

  /// [Additional Radius Values]
  static double get circleAvatarRadiusSmall => scaleRadius(12);
  static double get circleAvatarRadiusMedium => scaleRadius(16);
  static double get circleAvatarRadiusLarge => scaleRadius(20);
}

void scalingLog(String type, double original, double scaled) {
  MuLogger.warning(
    '$type scaled from $original to $scaled (Factor: ${scaled / original})',
  );
}
