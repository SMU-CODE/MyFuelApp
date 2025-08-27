import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/features/vehicles/Models/AddNewVehicleRequest.dart';
import 'package:my_fuel/features/vehicles/Services/VehicleService.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/Parser.dart';

class AddNewVehicleController extends GetxController {
  final isLoading = false.obs;
  final selectedFuelTypeId = 0.obs;

  final ownerNameCtrl = TextEditingController();
  final vehicleTypeCtrl = TextEditingController();
  final engineNumberCtrl = TextEditingController();
  final plateNumberCtrl = TextEditingController();
  final ownerPhoneCtrl = TextEditingController();
  final modelYearCtrl = TextEditingController();
  final colorCtrl = TextEditingController();

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  void _disposeResources() {
    ownerNameCtrl.dispose();
    vehicleTypeCtrl.dispose();
    engineNumberCtrl.dispose();
    plateNumberCtrl.dispose();
    ownerPhoneCtrl.dispose();
    modelYearCtrl.dispose();
    colorCtrl.dispose();
  }

  Future<void> addNewVehicle() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final request = AddNewVehicleRequest(
        fuelTypeId: selectedFuelTypeId.value,
        ownerName: ownerNameCtrl.text.trim(),
        type: vehicleTypeCtrl.text.trim(),
        engineNumber: Parser.parseString(engineNumberCtrl.text),
        plateNumber: Parser.parseString(plateNumberCtrl.text),
        ownerPhone: ownerPhoneCtrl.text.trim(),
        modelYear: int.tryParse(modelYearCtrl.text.trim()),
        color: colorCtrl.text.trim(),
        lastRefuelDate: null,
        isActive: true,
      );

      final result = await VehicleService.addNewVehicle(request);

      if (result.success) {
        MuAlerts.showSuccess(result.message);
        final qrCode = result.data?.qrCode ?? "";

        if (qrCode != "" || qrCode != "N/A") {
          AppRoutes.goTo(
            AppRoutes.qrDisplay,
            arguments: {'plateNumber': plateNumberCtrl.text, 'qrCode': qrCode},
          );
        }
      } else {
        MuAlerts.showError(result.message);
      }
    } catch (e) {
      MuAlerts.showError('حدث خطأ غير متوقع: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    isLoading.value = false;
    selectedFuelTypeId.value = 0;

    ownerNameCtrl.clear();
    vehicleTypeCtrl.clear();
    engineNumberCtrl.clear();
    plateNumberCtrl.clear();
    ownerPhoneCtrl.clear();
    modelYearCtrl.clear();
    colorCtrl.clear();
  }
}
