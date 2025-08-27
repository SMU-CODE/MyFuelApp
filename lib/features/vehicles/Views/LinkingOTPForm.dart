import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/vehicles/Controllers/LinkingVehicleController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';

class LinkingOTPForm extends StatelessWidget {
  const LinkingOTPForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LinkingVehicleController controller = Get.find();

    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: AppSize.pagePadding,
      child: Column(
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: AppSize.iconLarge * 2,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSize.spacingLarge),

          Text(
            "أدخل كود التحقق المرسل إلى",
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.onSurface,
              fontWeight: AppFont.wmedium,
            ),
            textAlign: TextAlign.center,
          ),

          Obx(() => Text(
                controller.ownerPhoneController.text.isEmpty
                    ? "رقم الهاتف غير متوفر"
                    : controller.ownerPhoneController.text,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: AppFont.wbold,
                  color: AppColors.onSurface.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              )),

          SizedBox(height: AppSize.spacingLarge * 1.5),

          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: "------",
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: AppSize.borderRadiusMedium,
                borderSide: BorderSide(
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppSize.borderRadiusMedium,
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: AppSize.paddingMedium,
            ),
            style: textTheme.titleLarge?.copyWith(
              letterSpacing: AppSize.spacingSmall,
              fontWeight: AppFont.wbold,
              color: AppColors.onSurface,
            ),
          ),

          SizedBox(height: AppSize.spacingLarge),

          Obx(
            () => SizedBox(
              width: AppSize.buttonWidth * 1.5,
              height: AppSize.buttonHeight,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.verifyOtpProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSize.borderRadiusLarge,
                  ),
                  elevation: 4,
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: AppColors.onPrimary)
                    : Text(
                        'تأكيد',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: AppFont.wbold,
                        ),
                      ),
              ),
            ),
          ),

          SizedBox(height: AppSize.spacingLarge),

          Obx(() => TextButton(
                onPressed: controller.otpResendCountdown.value == 0
                    ? controller.resendOtp
                    : null,
                child: Text(
                  "إعادة إرسال الرمز",
                  style: textTheme.bodyMedium?.copyWith(
                    color: controller.otpResendCountdown.value == 0
                        ? AppColors.primary
                        : AppColors.outline.withValues(alpha: 0.6),
                    fontWeight: AppFont.wmedium,
                  ),
                ),
              )),

          Obx(() => Text(
                controller.otpResendCountdown.value > 0
                    ? "إعادة الإرسال خلال ${controller.otpResendCountdown.value} ثانية"
                    : "يمكنك إعادة إرسال الرمز الآن",
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              )),

          SizedBox(height: AppSize.spacingLarge),

          Divider(),
          SizedBox(height: AppSize.spacingSmall),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "لديك مشكلة؟",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: AppSize.spacingSmall),
              TextButton(
                onPressed: () {
                  // إجراء الدعم
                },
                child: Text(
                  "اتصل بالدعم",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppFont.wmedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
