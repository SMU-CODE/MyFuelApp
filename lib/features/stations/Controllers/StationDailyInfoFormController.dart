import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationFormRequest.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationByIdModel.dart';
import 'package:my_fuel/features/stations/Services/DailyInfoStationsServicesForManager.dart';
import 'package:my_fuel/features/stations/services/StationsServicesForManager.dart';

import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared/helper/Parser.dart';

class StationDailyInfoFormController extends GetxController {
  final String? dailyInfoId;
  StationDailyInfoFormController({this.dailyInfoId});

  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final RxBool isEditMode = false.obs;
  final RxList<Map<String, String>> stationsDropdown =
      <Map<String, String>>[].obs;

  int selectedStationId = 0;
  int selectedFuelTypeId = 0;

  final TextEditingController totalBookingsCtrl = TextEditingController();
  final TextEditingController shippedAmountCtrl = TextEditingController();
  final TextEditingController receivedAmountCtrl = TextEditingController();
  final TextEditingController infoDateCtrl = TextEditingController();
  final TextEditingController remainingAmountCtrl = TextEditingController();
  final TextEditingController expectedShipmentCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();
  final RxString status = '1'.obs;

  Future<void> _loadStationsDropdown() async {
    try {
      isLoading.value = true;

      final result = await StationsServicesForManager.stationsDropDown();

      if (result.success && result.data != null) {
        stationsDropdown.value =
            result.data!
                .map((v) => {'id': v.id.toString(), 'name': v.name ?? ''})
                .toList();
      } else {}
    } catch (e) {
      MuLogger.exception(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadStationsDropdown();
    if (dailyInfoId != null) {
      isEditMode.value = true;
      _loadDailyInfoData(dailyInfoId!);
    } else {}
  }

  @override
  void onClose() {
    totalBookingsCtrl.dispose();
    shippedAmountCtrl.dispose();
    receivedAmountCtrl.dispose();
    infoDateCtrl.dispose();
    remainingAmountCtrl.dispose();
    expectedShipmentCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadDailyInfoData(String id) async {
    isLoading.value = true;
    try {
      final result =
          await DailyInfoStationsServicesForManager.getStationDailyInfoById(id);
      if (result.success && result.data != null) {
        _fillFormWithData(result.data!);
      } else {
        MuAlerts.showError(result.message);
        Get.back();
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to load daily info data");
      MuAlerts.showError(
        'فشل تحميل بيانات السجل اليومي. يرجى المحاولة مرة أخرى لاحقاً.',
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _fillFormWithData(DailyInfoStationByIdModel dailyInfo) {
    selectedFuelTypeId = dailyInfo.fuelTypeId ?? 0;
    selectedStationId = dailyInfo.stationId ?? 0;
    totalBookingsCtrl.text = dailyInfo.maxBookings.toString();
    shippedAmountCtrl.text = dailyInfo.shippedAmount.toString();
    receivedAmountCtrl.text = dailyInfo.receivedAmount.toString();
    infoDateCtrl.text = Parser.formatDateTime(dailyInfo.infoDate);
    remainingAmountCtrl.text = dailyInfo.remainingAmount.toString();
    expectedShipmentCtrl.text = dailyInfo.shippedAmount.toString();
    notesCtrl.text = dailyInfo.notes ?? "";
    status.value = dailyInfo.status ?? "";
  }

  Future<void> handleDailyInfoSubmission() async {
    if (isLoading.value) return;

    isSuccess.value = false;
    if (!isEditMode.value) {
      if (selectedStationId == 0 || selectedFuelTypeId == 0) {
        MuAlerts.showWarning('الرجاء ملء جميع الحقول المطلوبة.');
        return;
      }
    }
    if (selectedFuelTypeId == 0) {
      MuAlerts.showWarning('الرجاء ملء جميع الحقول المطلوبة.');
      return;
    }

    isLoading.value = true;
    try {
      final requestData = DailyInfoStationFormRequest(
        stationId: selectedStationId,
        fuelTypeId: Parser.parseInt(selectedFuelTypeId),
        maxBookings: Parser.parseInt(totalBookingsCtrl.text),
        shippedAmount: Parser.parseDouble(shippedAmountCtrl.text),
        receivedAmount: Parser.parseDouble(receivedAmountCtrl.text),
        infoDate: Parser.parseString(infoDateCtrl.text),
        remainingAmount: Parser.parseDouble(remainingAmountCtrl.text),
        expectedShipment: Parser.parseDouble(expectedShipmentCtrl.text),
        notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
        status: status.value,
      );

      ApiResponse result;
      if (isEditMode.value) {
        result =
            await DailyInfoStationsServicesForManager.updateStationDailyInfo(
              dailyInfoId!,
              requestData,
            );
      } else {
        result =
            await DailyInfoStationsServicesForManager.addNewStationDailyInfo(
              requestData,
            );
      }

      if (result.success) {
        isSuccess.value = true;
        MuAlerts.showSuccess(result.message);
        // Assuming there's a management controller to refresh the list
        // Get.find<StationDailyInfoManagementController>().fetchAllStationDailyInfos();
      } else {
        isSuccess.value = false;
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Error processing daily info form");
      isSuccess.value = false;
      MuAlerts.showError('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقاً.');
    } finally {
      if (isEditMode.value) {
        resetForm();
      } else {}
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedFuelTypeId = 0;
    selectedStationId = 0;
    totalBookingsCtrl.clear();
    shippedAmountCtrl.clear();
    receivedAmountCtrl.clear();
    infoDateCtrl.clear();
    remainingAmountCtrl.clear();
    expectedShipmentCtrl.clear();
    notesCtrl.clear();
    status.value = '1';
    isSuccess.value = false;
    isEditMode.value = false;
    isLoading.value = false;
  }
}
