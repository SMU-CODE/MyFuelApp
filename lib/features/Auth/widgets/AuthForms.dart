import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/features/Auth/widgets/AuthTextField.dart';
import 'package:my_fuel/shared/helper/InputValidator.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

// Common Auth Form Container
Widget _authFormContainer({
  required Key key,
  required AuthController controller,
  required List<Widget> children,
}) {
  return Container(
    key: key,
    padding: AppSize.paddingAll,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppSize.borderRadiusLarge,
      boxShadow: [
        BoxShadow(
          color: AppColors.outline.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  );
}

// Login Form Widget
Widget loginForm(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('login_container'),
    controller: controller,
    children: [
      AuthTextField(
        keyboardType: TextInputType.number,
        label: 'رقم الهاتف',
        controller: controller.phoneController,
        hintText: 'أدخل رقم الهاتف',
        icon: Icons.phone,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.phone],
              fieldName: 'رقم الهاتف',
              minLength: 9,
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'كلمة المرور',
        controller: controller.passwordController,
        hintText: 'أدخل كلمة المرور',
        isPassword: true,
        icon: Icons.lock,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.password],
              fieldName: 'كلمة المرور',
            ),
        authMode: controller.currentAuthMode,
        onFieldSubmitted: (_) => controller.registerOrLoginTest(),
      ),
    ],
  );
}

// Register Form Widget
Widget registerForm(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('register_container'),
    controller: controller,
    children: [
      AuthTextField(
        label: 'اسم المستخدم',
        controller: controller.usernameController,
        hintText: 'أدخل اسم المستخدم',
        icon: Icons.person,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.name],
              fieldName: 'اسم المستخدم',
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        keyboardType: TextInputType.number,
        label: 'رقم الهاتف',
        controller: controller.phoneController,
        hintText: 'أدخل رقم الهاتف',
        icon: Icons.phone,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.phone],
              fieldName: 'رقم الهاتف',
              minLength: 9,
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'كلمة المرور',
        controller: controller.passwordController,
        hintText: 'أدخل كلمة المرور',
        isPassword: true,
        icon: Icons.lock,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.password],
              fieldName: 'كلمة المرور',
            ),
        authMode: controller.currentAuthMode,
        onFieldSubmitted: (_) => controller.registerOrLoginTest(),
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'تأكيد كلمة المرور الجديدة',
        controller: controller.confirmPasswordController,
        hintText: 'أعد إدخال كلمة المرور الجديدة',
        isPassword: true,
        icon: Icons.lock_outline,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.confirmPassword],
              passwordToMatch: controller.passwordController.text,
              fieldName: 'تأكيد كلمة المرور',
            ),
        authMode: controller.currentAuthMode,
      ),
    ],
  );
}

// Change Password Form Widget
Widget changePasswordForm(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('change_password_container'),
    controller: controller,
    children: [
      AuthTextField(
        label: 'كلمة المرور الحالية',
        controller: controller.currPasswordConfirmCtrl,
        hintText: 'أدخل كلمة المرور الحالية',
        isPassword: true,
        icon: Icons.lock,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.password],
              fieldName: 'كلمة المرور الحالية',
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'كلمة المرور الجديدة',
        controller: controller.newPasswordController,
        hintText: 'أدخل كلمة المرور الجديدة',
        isPassword: true,
        icon: Icons.lock_reset,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.password],
              fieldName: 'كلمة المرور الجديدة',
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'تأكيد كلمة المرور الجديدة',
        controller: controller.newPasswordConfirmCtrl,
        hintText: 'أعد إدخال كلمة المرور الجديدة',
        isPassword: true,
        icon: Icons.lock_outline,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.confirmPassword],
              passwordToMatch: controller.newPasswordController.text,
              fieldName: 'تأكيد كلمة المرور',
            ),
        authMode: controller.currentAuthMode,
      ),
    ],
  );
}

// Reset Password Form Widget
Widget restPasswordForm(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('rest_password_container'),
    controller: controller,
    children: [
      AuthTextField(
        label: 'رقم الهاتف',
        controller: controller.phoneController,
        hintText: 'أدخل رقم الهاتف',
        icon: Icons.phone,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.phone],
              fieldName: 'رقم الهاتف',
              minLength: 9,
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'كلمة المرور الجديدة',
        controller: controller.newPasswordController,
        hintText: 'أدخل كلمة المرور الجديدة',
        isPassword: true,
        icon: Icons.password,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.password],
              fieldName: 'كلمة المرور الجديدة',
            ),
        authMode: controller.currentAuthMode,
      ),
      const SizedBox(height: 12),
      AuthTextField(
        label: 'تأكيد كلمة المرور الجديدة',
        controller: controller.newPasswordConfirmCtrl,
        hintText: 'أعد إدخال كلمة المرور الجديدة',
        isPassword: true,
        icon: Icons.lock_outline,
        validator:
            (val) => InputValidator.validate(
              value: val ?? '',
              types: [InputType.confirmPassword],
              passwordToMatch: controller.newPasswordController.text,
              fieldName: 'تأكيد كلمة المرور',
            ),
        authMode: controller.currentAuthMode,
      ),
    ],
  );
}

// Logout Confirmation Widget
Widget logoutConfirmation(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('logout_container'),
    controller: controller,
    children: [
      Text(
        'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.outline),
              ),
              onPressed: () => Get.back(),
              child: Text(
                'إلغاء',
                style: TextStyle(color: AppColors.onSurface),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: controller.logout,
              child: Text(
                'تسجيل خروج',
                style: TextStyle(color: AppColors.onError),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// OTP Form Widget
Widget otpForm(AuthController controller) {
  return _authFormContainer(
    key: const ValueKey('otp_container'),
    controller: controller,
    children: [
      // رمز التحقق
      Center(
        child: Icon(
          Icons.verified_user,
          size: 60,
          color: _getIconColor(controller.currentAuthMode),
        ),
      ),
      SizedBox(height: AppSize.spacingLarge),

      // نص التعليمات
      Text(
        "أدخل كود التحقق المرسل إلى",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppSize.mediumFont,
          color: AppColors.onSurface,
        ),
      ),
      SizedBox(height: AppSize.spacingSmall),

      // رقم الهاتف
      Text(
        controller.phoneController.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _getTextColor(controller.currentAuthMode),
        ),
      ),
      SizedBox(height: AppSize.spacingExtraLarge),

      // حقل إدخال OTP
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.screenWidth * 0.1),
        child: TextFormField(
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          validator:
              (val) => InputValidator.validate(
                value: val ?? '',
                types: [InputType.otp],
                fieldName: 'كود التحقق',
              ),
          decoration: InputDecoration(
            hintText: "------",
            hintStyle: const TextStyle(letterSpacing: 4),
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
              borderSide: BorderSide(
                color: _getBorderColor(controller.currentAuthMode),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
              borderSide: BorderSide(
                color: _getBorderColor(controller.currentAuthMode),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 24, letterSpacing: 4),
        ),
      ),
      SizedBox(height: AppSize.spacingExtraLarge),

      // إعادة إرسال الرمز
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              // TODO: controller.resendOTP();
            },
            child: Text(
              controller.errorMessage,
              style: TextStyle(
                color: _getTextColor(controller.currentAuthMode),
              ),
            ),
          ),
          Obx(
            () => Text(
              "(${Parser.parseString(controller.otpTimer.value)})",
              style: TextStyle(
                color: AppColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// دوال مساعدة لتحديد الألوان حسب الحالة
Color _getIconColor(AuthMode mode) {
  switch (mode) {
    case AuthMode.login:
      return AppColors.primary;
    case AuthMode.signUp:
      return AppColors.secondary;
    case AuthMode.changePassword:
      return Colors.purple;
    case AuthMode.restPassword:
      return Colors.indigo;
    case AuthMode.logout:
      return AppColors.error;
    case AuthMode.otp:
      return AppColors.primary;
  }
}

Color _getBorderColor(AuthMode mode) {
  return _getIconColor(mode);
}

Color _getButtonColor(AuthMode mode) {
  return _getIconColor(mode);
}

Color _getTextColor(AuthMode mode) {
  return _getIconColor(mode);
}

String _getButtonText(AuthMode mode) {
  switch (mode) {
    case AuthMode.login:
      return "تسجيل الدخول";
    case AuthMode.signUp:
      return "إنشاء حساب";
    case AuthMode.changePassword:
      return "تغيير كلمة المرور";
    case AuthMode.restPassword:
      return "إعادة تعيين كلمة المرور";
    case AuthMode.logout:
      return "تسجيل الخروج";
    case AuthMode.otp:
      return "التحقق من الرمز";
  }
}
