import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AuthOTPScreen extends StatelessWidget {
  const AuthOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text(controller.authModeText), centerTitle: true),
      body: Padding(
        padding: AppSize.paddingAll,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Icon(
              Icons.verified_user,
              size: 80,
              color: _getIconColor(controller.currentAuthMode),
            ),
            SizedBox(height: AppSize.spacingLarge),

            // نص التعليمات
            Text(
              "أدخل كود التحقق المرسل إلى",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _getTextColor(controller.currentAuthMode),
              ),
            ),

            SizedBox(height: AppSize.spacingSmall),

            // رقم الهاتف
            Text(
              controller.phoneController.text,
              style: TextStyle(
                fontSize: 18,
                color: _getTextColor(controller.currentAuthMode),
              ),
            ),

            SizedBox(height: AppSize.spacingExtraLarge),

            // حقل إدخال OTP
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.screenWidth * 0.2,
              ),
              child: TextField(
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
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

            // زر التأكيد
            SizedBox(
              width: 200,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(
                      controller.currentAuthMode,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                    ),
                  ),
                  onPressed:
                      controller.isLoading
                          ? null
                          : () => controller.registerVerifyOtp(),
                  child:
                      controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            _getButtonText(controller.currentAuthMode),
                            style: const TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // إعادة إرسال الرمز
            TextButton(
              onPressed: () {
                //TODO controller.resendOTP();
              },
              child: Text(
                "إعادة إرسال الرمز",
                style: TextStyle(
                  color: _getTextColor(controller.currentAuthMode),
                ),
              ),
            ),

            // مؤقت إعادة الإرسال
            Obx(
              () => Text(
                "إعادة الإرسال متاحة خلال ${"controller.otpTimer.value"} ثانية",
                style: TextStyle(
                  color: _getTextColor(controller.currentAuthMode),
                ),
              ),
            ),

            SizedBox(height: AppSize.spacingLarge),
          ],
        ),
      ),
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
        return Colors.red;
      case AuthMode.otp:
        return const Color.fromARGB(255, 244, 244, 54);
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
}
