import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Models/StationResponseForManager.dart';
import 'package:my_fuel/features/stations/Models/StationFormRequest.dart';
import 'package:my_fuel/features/stations/Services/StationsServicesForManager.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class StationsManagementController extends GetxController {
  final RxList<StationResponseForManager> stations = <StationResponseForManager>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStations();
  }

  Future<void> fetchAllStations() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await StationsServicesForManager.getAllStations();
      if (result.success && result.data != null) {
        stations.assignAll(result.data as Iterable<StationResponseForManager>);
      } else {
        errorMessage.value = result.message;
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to fetch stations");
      errorMessage.value = 'حدث خطأ في جلب المحطات. الرجاء المحاولة لاحقاً.';
      MuAlerts.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStation(
    String stationId,
    StationFormRequest requestData,
  ) async {
    isLoading.value = true;
    try {
      final result = await StationsServicesForManager.updateStation(
        stationId,
        requestData,
      );
      if (result.success) {
        MuAlerts.showSuccess(result.message);
        await fetchAllStations();
        Get.back();
      } else {
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to update station $stationId");
      MuAlerts.showError('فشل في تحديث المحطة. الرجاء المحاولة لاحقاً.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStation(String stationId) async {
    isLoading.value = true;
    try {
      final result = await StationsServicesForManager.deleteStation(stationId);
      if (result.success) {
        MuAlerts.showSuccess(result.message);
        stations.removeWhere(
          (station) => station.id.toString() == stationId,
        ); // Remove from list
      } else {
        MuAlerts.showError(result.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to delete station $stationId");
      MuAlerts.showError('فشل في حذف المحطة. الرجاء المحاولة لاحقاً.');
    } finally {
      isLoading.value = false;
    }
  }
}
