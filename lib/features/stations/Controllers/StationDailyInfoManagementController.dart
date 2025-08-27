import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoManegerModel.dart';
import 'package:my_fuel/features/stations/Services/DailyInfoStationsServicesForManager.dart';

import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class StationDailyInfoManagementController extends GetxController {
  final RxList<DailyInfoManegerModel> dailyInfos =
      <DailyInfoManegerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStationDailyInfos();
  }

  Future<void> fetchAllStationDailyInfos() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result =
          await DailyInfoStationsServicesForManager.getAllStationDailyInfos();
      if (result.success && result.data != null) {
        dailyInfos.assignAll(result.data as Iterable<DailyInfoManegerModel>);
      } else {
        errorMessage.value = result.message;
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to fetch station daily infos");
      errorMessage.value =
          'حدث خطأ في جلب معلومات المحطات اليومية. الرجاء المحاولة لاحقاً.';
      MuAlerts.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStationDailyInfo(String dailyInfoId) async {
    isLoading.value = true;
    try {
      final result =
          await DailyInfoStationsServicesForManager.deleteStationDailyInfo(
            dailyInfoId,
          );
      if (result.success) {
        MuAlerts.showSuccess(result.message);
        dailyInfos.removeWhere(
          (info) => info.dailyInfoId.toString() == dailyInfoId,
        );
      } else {
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(
        e,
        st,
        "Failed to delete station daily info $dailyInfoId",
      );
      MuAlerts.showError('فشل في حذف السجل اليومي. الرجاء المحاولة لاحقاً.');
    } finally {
      isLoading.value = false;
    }
  }
}
