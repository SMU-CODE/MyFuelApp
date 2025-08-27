import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Refueling/Services/refuelVehicleService.dart';
import 'package:my_fuel/features/vehicles/Models/LinkingVehicleRequest.dart';
import 'package:my_fuel/features/vehicles/Models/UservehicleswithdetailsModel.dart';
import 'package:my_fuel/features/vehicles/Services/VehiclesLinkingServices.dart';
import 'package:my_fuel/features/vehicles/Services/VehicleService.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/notifications/NotificationService.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/AppRoutes.dart';

class LinkingVehicleController extends GetxController {
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController vehicleQrController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  final RxBool isLoading = false.obs;
  final RxBool isOtp = false.obs;

  final RxList<UservehicleswithdetailsModel> userVehicles =
      <UservehicleswithdetailsModel>[].obs;

  final RxInt otpResendCountdown = 0.obs;
  Timer? _resendTimer;
  final int _initialResendSeconds = 60; // 60 seconds countdown

  @override
  void onInit() {
    super.onInit();
    loadLinkedVehicles();
  }

  @override
  void onClose() {
    ownerPhoneController.dispose();
    vehicleQrController.dispose();
    otpController.dispose();
    _resendTimer?.cancel(); // Cancel timer on close
    super.onClose();
  }

  Future<void> fetchVehicleInfo({String? qrCode}) async {
    String vehicleCode = qrCode ?? vehicleQrController.text;
    if (vehicleCode.isEmpty || vehicleQrController.text == '') {
      MuAlerts.showWarning('يرجى إدخال رمز المركبة للمسح.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await RefuelVehicleService.getVehicleInfoByQr(
        vehicleCode,
      );
      if (response.success && response.data != null) {
        response.data;
        vehicleQrController.text = vehicleCode;
        //   ownerPhoneController.text = response.data!.ownerPhone!;
      } else {
        MuAlerts.showWarning(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to fetch vehicle data");
      MuAlerts.showError(
        'حدث خطأ أثناء جلب بيانات المركبة. الرجاء المحاولة لاحقاً.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startResendTimer() {
    _resendTimer?.cancel(); // Cancel any existing timer
    otpResendCountdown.value = _initialResendSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpResendCountdown.value > 0) {
        otpResendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> loadLinkedVehicles() async {
    try {
      isLoading.value = true;
      final response = await VehicleService.getUserVehiclesWithDetails();

      if (response.success) {
        userVehicles.value = response.data ?? [];
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "فشل تحميل المركبات");
      MuAlerts.showError(
        'حدث خطأ أثناء تحميل المركبات. الرجاء المحاولة لاحقاً.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initiateLinkingProcess() async {
    final ownerPhone = ownerPhoneController.text.trim();
    final vehicleQrCode = vehicleQrController.text.trim();

    if (ownerPhone.isEmpty || vehicleQrCode.isEmpty) {
      MuAlerts.showError('الرجاء إدخال رقم الهاتف ورمز QR للمركبة.');
      return;
    }

    try {
      isLoading.value = true;
      final request = LinkingVehicleRequest(
        vehicleQrCode: vehicleQrCode,
        ownerPhone: ownerPhone,
      );

      final response = await VehiclesLinkingServices.linkVehicle(request);

      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 201) {
        final String myVerifyOtp = Parser.parseString(
          response.data!.verifyCode,
        );
        isOtp.value = true;
        MuLogger.success("response.data!.verify_code::$myVerifyOtp");
        _notificationService.showSimpleNotification(
          title: "وقودي",
          body: "كود التحقق هو:$myVerifyOtp",
        );
        otpController.text = myVerifyOtp;
        MuAlerts.showSuccess(response.message);
        startResendTimer(); // Start timer after successful OTP request
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "فشل بدء ربط المركبة");
      MuAlerts.showError('حدث خطأ أثناء بدء ربط المركبة: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (otpResendCountdown.value > 0) {
      MuAlerts.showInfo('الرجاء الانتظار قبل إعادة إرسال الرمز.');
      return;
    }

    // Re-call initiateLinkingProcess to request a new OTP
    await initiateLinkingProcess();
  }

  Future<void> verifyOtpProcess() async {
    final ownerPhone = ownerPhoneController.text.trim();
    final vehicleQrCode = vehicleQrController.text.trim();
    final otpCode = otpController.text.trim();

    if (otpCode.isEmpty) {
      MuAlerts.showError('الرجاء إدخال رمز التحقق (OTP).');
      return;
    }

    try {
      isLoading.value = true;
      final request = LinkingVehicleRequest(
        vehicleQrCode: vehicleQrCode,
        ownerPhone: ownerPhone,
        otpCode: otpCode,
        type: 'phone',
        channel: 'sms',
      );

      final response = await VehiclesLinkingServices.linkVehicle(request);

      if (response.success) {
        MuAlerts.showSuccess(response.message);
        // Clear all fields and reset state after successful linking
        /*  otpController.clear();
        ownerPhoneController.clear();
        vehicleQrController.clear(); */

        _resendTimer?.cancel(); // Stop the timer
        otpResendCountdown.value = 0; // Reset countdown
        //  Get.back();
        AppRoutes.goTo(AppRoutes.vehicleLinking);
        await loadLinkedVehicles();
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "فشل التحقق من OTP وربط المركبة");
      MuAlerts.showError(
        'حدث خطأ أثناء التحقق من OTP وربط المركبة: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
      isOtp.value = false;
     
    }
  }

  Future<void> unlinkVehicle(String qrCode) async {
    if (!await MuAlerts.showConfirmDialog(
      title: "فك ارتباط المركبة",
      contentText: "هل أنت متأكد أنك تريد فك ارتباط هذه المركبة؟",
      confirmText: "تأكيد",
      cancelText: "إلغاء",
      confirmColor: AppColors.error,
    )) {
      return;
    }

    try {
      isLoading.value = true;
      final request = LinkingVehicleRequest(vehicleQrCode: qrCode);

      final response = await VehiclesLinkingServices.unlinkVehicle(request);

      if (response.success == true) {
        MuAlerts.showSuccess(response.message);
        await loadLinkedVehicles();
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "فشل فك ارتباط المركبة");
      MuAlerts.showError('حدث خطأ أثناء فك ارتباط المركبة.');
    } finally {
      isLoading.value = false;
    }
  }
}
