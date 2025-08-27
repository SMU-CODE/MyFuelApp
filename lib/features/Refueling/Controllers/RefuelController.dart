import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/refueling/Services/refuelVehicleService.dart';
import 'package:my_fuel/features/vehicles/Models/VehicleWithInfoModel.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class RefuelController extends GetxController {
  final fuelAmountCtrl = TextEditingController(text: '40');
  final vehicleCodeCtrl = TextEditingController();

  final Rxn<VehicleWithInfoModel> vehicleInfo = Rxn<VehicleWithInfoModel>();

  final isLoading = false.obs;

  @override
  void onClose() {
    fuelAmountCtrl.dispose();
    vehicleCodeCtrl.dispose();
    super.onClose();
  }

  /// Fetches vehicle data by QR code.
  Future<void> fetchVehicleInfo({String? qrCode}) async { 
  
    String vehicleCode = qrCode??  vehicleCodeCtrl.text;
    if (vehicleCode.isEmpty) {
      MuAlerts.showWarning('يرجى إدخال رمز المركبة للمسح.');
      return;
    }

    isLoading.value = true;
    try {
    
      final response = await RefuelVehicleService.getVehicleInfoByQr(vehicleCode);
      if (response.success && response.data != null) {
        vehicleInfo.value = response.data;
        vehicleCodeCtrl.text = vehicleCode; // Populate field from scan
        MuAlerts.showSuccess('تم العثور على بيانات المركبة.');
      } else {
        vehicleInfo.value = null; // Clear previous info
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

  /// Submits the refueling request.
  Future<void> performRefuel() async {
    if (vehicleInfo.value == null || vehicleInfo.value?.qrCode == null) {
      MuAlerts.showWarning('يرجى مسح رمز المركبة أولاً.');
      return;
    }
    if (fuelAmountCtrl.text.isEmpty ||
        double.tryParse(fuelAmountCtrl.text) == null) {
      MuAlerts.showWarning('يرجى إدخال كمية وقود صالحة.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await RefuelVehicleService.refuelVehicle(
        vehicleQrCode: vehicleInfo.value!.qrCode!,
        notes: "تمت التعبئة بمقدار ${fuelAmountCtrl.text} لتر",
        //TODO      amount: double.parse(fuelAmountCtrl.text),
      );

      if (response.success) {
        MuAlerts.showSuccess(response.message);
        resetInputs(); // Reset fields on successful operation
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Refueling operation failed");
      MuAlerts.showError(
        'حدث خطأ أثناء عملية التعبئة. الرجاء المحاولة لاحقاً.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Resets all inputs and vehicle information.
  void resetInputs() {
    vehicleCodeCtrl.clear();
    fuelAmountCtrl.text = '40';
    vehicleInfo.value = null;
  }
}
