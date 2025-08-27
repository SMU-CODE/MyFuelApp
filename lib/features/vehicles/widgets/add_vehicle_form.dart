// lib/features/vehicles/widgets/add_vehicle_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Refueling/Views/ScanQRScreen.dart';
import 'package:my_fuel/features/vehicles/Controllers/LinkingVehicleController.dart';
import 'package:my_fuel/shared/helper/InputValidator.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/MuTextField.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart'; // Assuming AppFont is here

class AddVehicleForm extends StatelessWidget {
  final LinkingVehicleController controller;

  const AddVehicleForm({super.key, required this.controller});

  Future<void> _startQrScan() async {
    final scannedCode = await Get.to<String?>(() => const ScanQRScreen());
    if (scannedCode != null && scannedCode.isNotEmpty) {
      // You might want to update the text field here if fetchVehicleInfo doesn't
      controller.vehicleQrController.text = scannedCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MuTextField(
          controller: controller.vehicleQrController,
          label: "رمز QR للمركبة",
          prefixIcon: IconButton(
            icon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
            onPressed: () async => await _startQrScan(),
          ),
          labelStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
          hintText: "أدخل رمز QR",
        ),
        MuTextField(
          validator:
              (p0) => InputValidator.validate(
                value: controller.ownerPhoneController.text,
                types: [InputType.phone],
                fieldName: 'رقم الهاتف',
                minLength: 9,
              ),
          controller: controller.ownerPhoneController,
          label: "هاتف المالك",
          prefixIcon: IconButton(
            icon: Icon(Icons.phone, color: AppColors.primary),
            onPressed: () async => await _startQrScan(),
          ),
          labelStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
          hintText: "ادخل رقم جوال مالك المركبة",
        ),
        SizedBox(height: AppSize.spacingMedium),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await controller.initiateLinkingProcess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSize.borderRadiusLarge,
                ),
                elevation: AppSize.elevationMedium,
                padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
              ),
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        width: AppSize.iconMedium,
                        height: AppSize.iconMedium,
                        child: CircularProgressIndicator(
                          color: AppColors.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        'ربط المركبة',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: AppFont.wbold,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
