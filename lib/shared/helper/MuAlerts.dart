import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class MuAlerts {
  // Alert colors from AppColors for consistency
  static const Color _successColor = AppColors.success;
  static const Color _errorColor = AppColors.error;
  static const Color _warningColor = AppColors.warning;
  static const Color _infoColor = AppColors.info;

  /// Private constructor for common AlertDialog styling.
  static AlertDialog _buildAlertDialog({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? actionsPadding,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      ),
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent, // Prevents default surface tint
      title: title,
      content: content,
      actions: actions,
      contentPadding: contentPadding,
      titlePadding: titlePadding,
      actionsPadding: actionsPadding,
    );
  }

  /// Private constructor for common TextButton styling.
  static TextButton _buildTextButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
    FontWeight fontWeight = AppFont.wmedium,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: AppSize.mediumFont,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  /// Displays a confirmation dialog. Returns true if confirmed, false otherwise.
  static Future<bool> showConfirmDialog({
    required String title,
    String? contentText,
    Widget? contentWidget,
    required String confirmText,
    String cancelText = 'إلغاء',
    Color confirmColor = AppColors.error,
    bool barrierDismissible = false,
  }) async {
    assert(
      contentText != null || contentWidget != null,
      'Either contentText or contentWidget must be provided.',
    );

    return await Get.dialog<bool>(
          Directionality(
            textDirection: TextDirection.rtl,
            child: _buildAlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: AppSize.largeFont,
                  fontWeight: AppFont.wbold,
                  color: AppColors.onSurface,
                ),
              ),
              content:
                  contentWidget ??
                  Text(
                    contentText!,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: AppSize.mediumFont,
                      color: AppColors.onSurface,
                    ),
                  ),
              actions: [
                _buildTextButton(
                  onPressed: () {
                    Get.back(
                      result: false,
                    ); // Dismisses dialog and returns false
                  },
                  text: cancelText,
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                  fontWeight: AppFont.wmedium,
                ),
                _buildTextButton(
                  onPressed: () {
                    Get.back(result: true); // Dismisses dialog and returns true
                  },
                  text: confirmText,
                  color: confirmColor,
                ),
              ],
            ),
          ),
          barrierDismissible: barrierDismissible,
        ) ??
        false; // Fallback in case dialog is dismissed without a result
  }

  /// Displays an informational dialog with an "Okay" button.
  static Future<void> showInfoDialog({
    required String title,
    required String content,
    IconData? icon,
    Color? iconColor,
    Color? titleColor,
    bool dismissible = true,
  }) async {
    await Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: _buildAlertDialog(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSize.iconMedium,
                  color: iconColor ?? _infoColor,
                ),
                SizedBox(width: AppSize.spacingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: AppFont.wbold,
                    fontSize: AppSize.largeFont,
                    color: titleColor ?? AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: TextStyle(
              fontSize: AppSize.mediumFont,
              color: AppColors.onSurface,
            ),
          ),
          actions: [
            _buildTextButton(
              onPressed: () => Get.back(),
              text: "حسنًا",
              color: AppColors.primary,
            ),
          ],
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.spacingMedium,
            vertical: AppSize.verticalSpacing,
          ),
          titlePadding: EdgeInsets.only(
            top: AppSize.spacingMedium,
            left: AppSize.spacingMedium,
            right: AppSize.spacingMedium,
          ),
          actionsPadding: EdgeInsets.only(
            bottom: AppSize.spacingSmall,
            right: 8,
          ),
        ),
      ),
      barrierDismissible: dismissible,
    );
  }

  /// Displays a dialog for text input. Returns the entered text or null.
  static Future<String?> showInputDialog({
    required String title,
    String? initialValue,
    String? hintText,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) async {
    final TextEditingController textController = TextEditingController(
      text: initialValue,
    );
    return await Get.dialog<String>(
      Directionality(
        textDirection: TextDirection.rtl,
        child: _buildAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.largeFont,
              fontWeight: AppFont.wbold,
              color: AppColors.onSurface,
            ),
          ),
          content: TextField(
            controller: textController,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.onSurface.withValues(alpha: .6),
                fontSize: AppSize.smallFont,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.backgroundInverse.withValues(
                alpha: 0.1,
              ), // A lighter fill
            ),
            style: TextStyle(
              fontSize: AppSize.mediumFont,
              color: AppColors.onSurface,
            ),
          ),
          actions: [
            _buildTextButton(
              onPressed: () => Get.back(result: null),
              text: cancelText,
              color: AppColors.onSurface.withValues(alpha: 0.7),
              fontWeight: AppFont.wmedium,
            ),
            _buildTextButton(
              onPressed: () => Get.back(result: textController.text),
              text: confirmText,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Displays a custom dialog with any widget content.
  static Future<T?> showCustomDialog<T>({
    required Widget content,
    bool barrierDismissible = false,
    Color? backgroundColor,
    ShapeBorder? shape,
    EdgeInsets? insetPadding,
  }) async {
    return await Get.dialog<T>(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: backgroundColor ?? AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
              ),
          insetPadding: insetPadding,
          child: content,
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Simple circular loading indicator.
  static Widget circularLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  /// Shows a loading dialog that prevents user interaction.
  static void showLoading({String? message}) {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(AppSize.spacingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSize.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              if (message != null) ...[
                SizedBox(height: AppSize.verticalSpacing),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: AppSize.mediumFont,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hides the current loading dialog.
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Displays a confirmation dialog for deleting an item.
  static Future<bool> confirmDelete(String itemName) async {
    return showConfirmDialog(
      title: "حذف العنصر",
      contentText: "هل أنت متأكد من حذف '$itemName'؟",
      confirmText: "حذف",
      confirmColor: _errorColor,
    );
  }

  /// Displays a custom SnackBar.
  static void showSnackBar({
    String? title,
    required String message,
    Color? backgroundColor,
    Duration? duration,
    IconData? icon,
    TextDirection textDirection = TextDirection.rtl,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? '',
      message,
      backgroundColor: backgroundColor ?? AppColors.onSurface,
      colorText: AppColors.onPrimary,
      snackPosition: snackPosition,
      duration: duration ?? const Duration(seconds: 3),
      margin: EdgeInsets.all(AppSize.spacingMedium),
      icon: icon != null ? Icon(icon, color: AppColors.onPrimary) : null,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      barBlur: 0,
      borderRadius: AppSize.radiusMedium,
    );
  }

  /// Displays a success SnackBar.
  static void showSuccess(String message, {Duration? duration, String? title}) {
    showSnackBar(
      message: message,
      backgroundColor: _successColor,
      duration: duration,
      icon: Icons.check_circle,
      title: title ?? "نجاح",
    );
  }

  /// Displays an error SnackBar.
  static void showError(
    String message, {
    String? details,
    Duration? duration,
    String? title,
  }) {
    if (details != null) debugPrint('Error: $message\nDetails: $details');
    showSnackBar(
      message: message,
      backgroundColor: _errorColor,
      duration: duration,
      icon: Icons.error,
      title: title ?? "خطأ",
    );
  }

  /// Displays a warning SnackBar.
  static void showWarning(String message, {Duration? duration, String? title}) {
    showSnackBar(
      message: message,
      backgroundColor: _warningColor,
      duration: duration,
      icon: Icons.warning,
      title: title ?? "تحذير",
    );
  }

  /// Displays an informational SnackBar.
  static void showInfo(String message, {Duration? duration, String? title}) {
    showSnackBar(
      message: message,
      backgroundColor: _infoColor,
      duration: duration,
      icon: Icons.info,
      title: title ?? "معلومة",
    );
  }

  /// Displays a custom bottom sheet.
  static Future<T?> showCustomBottomSheet<T>({
    required Widget content,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) async {
    return await Get.bottomSheet<T>(
      Directionality(textDirection: TextDirection.rtl, child: content),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: elevation,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSize.radiusLarge),
            ),
          ),
    );
  }
}
