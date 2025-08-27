import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Controllers/StationsManagementController.dart';
import 'package:my_fuel/features/stations/Models/StationResponseForManager.dart';
import 'package:my_fuel/features/stations/Models/StationFormRequest.dart';
import 'package:my_fuel/features/stations/Services/StationsServicesForManager.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class StationFormController extends GetxController {
  final String? stationId;
  StationFormController({this.stationId});

  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final RxBool isEditMode = false.obs;

  final stationNameCtrl = TextEditingController();
  final stationLocationCtrl = TextEditingController();
  final stationAboutCtrl = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxBool isActive = true.obs;
  String? currentImageUrl;
  StationFormRequest? requestData;

  @override
  void onInit() {
    super.onInit();
    if (stationId != null) {
      isEditMode.value = true;
      _loadStationData(stationId!);
    }
  }

  @override
  void onClose() {
    stationNameCtrl.dispose();
    stationLocationCtrl.dispose();
    stationAboutCtrl.dispose();
    imageFile.close();
    isActive.close();
    super.onClose();
  }

  Future<void> _loadStationData(String id) async {
    isLoading.value = true;
    try {
      final existingStation = Get.find<StationsManagementController>().stations
          .firstWhereOrNull((s) => s.id.toString() == id);

      if (existingStation != null) {
        _fillFormWithData(existingStation);
      } else {
        final result = await StationsServicesForManager.getStationById(id);
        if (result.success && result.data != null) {
          _fillFormWithData(result.data!);
        } else {
          MuAlerts.showError(result.message);
          Get.back();
        }
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to load station data");
      MuAlerts.showError(
        'فشل تحميل بيانات المحطة. يرجى المحاولة مرة أخرى لاحقاً.',
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _fillFormWithData(StationResponseForManager station) {
    stationNameCtrl.text = station.name ?? '';
    stationLocationCtrl.text = station.location ?? '';
    stationAboutCtrl.text = station.about ?? '';
    isActive.value = station.isActive ?? false;
    currentImageUrl = station.imageUrl;
  }

  Future<void> handleStationSubmission() async {
    if (isLoading.value) return;

    isSuccess.value = false;

    if (stationNameCtrl.text.trim().isEmpty ||
        stationLocationCtrl.text.trim().isEmpty) {
      MuAlerts.showWarning('الرجاء ملء جميع الحقول المطلوبة.');
      return;
    }
    requestData = StationFormRequest(
      name: stationNameCtrl.text.trim(),
      location: stationLocationCtrl.text.trim(),
      about: stationAboutCtrl.text.trim(),
      imageFile: imageFile.value,
      isActive: isActive.value,
    );

    isLoading.value = true;
    try {
      ApiResponse result;
      if (isEditMode.value) {
        result = await StationsServicesForManager.updateStation(
          stationId!,
          requestData!,
        );
      } else {
        result = await StationsServicesForManager.addNewStation(requestData!);
      }

      if (result.success) {
        isSuccess.value = true;
        MuAlerts.showSuccess(result.message);
        if (isEditMode.value) {
          //Get.back();
          // AppRoutes.goBack();
          //   Get.find<StationsManagementController>().fetchAllStations();
        }
      } else {
        isSuccess.value = false;
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Error processing station form");
      isSuccess.value = false;
      MuAlerts.showError('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقاً.');
    } finally {
      if (!isEditMode.value) {
        resetForm();
      }

      isLoading.value = false;
    }
  }

  void updateImageFile(File? file) {
    imageFile.value = file;
  }

  void resetForm() {
    stationNameCtrl.clear();
    stationLocationCtrl.clear();
    stationAboutCtrl.clear();
    imageFile.value = null;
    isActive.value = true;
    currentImageUrl = null;
    isSuccess.value = false;
  }
}
