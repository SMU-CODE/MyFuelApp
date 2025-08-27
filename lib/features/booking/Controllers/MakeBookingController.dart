import 'package:get/get.dart';
import 'package:my_fuel/features/booking/Models/MakeBookingRequest.dart';
import 'package:my_fuel/features/booking/Services/MakeBookingService.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';

class MakeBookingController extends GetxController {
  final int stationId;
  final String stationName;

  // final GetStorage _storage = GetStorage();
  final _api = MakeBookingService();

  // Rx variables
  var username = RxnString();
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  var selectedPeriodId = 1.obs;
  var selectedVehicleId = RxnInt();

  var selectedLinkedStationId = RxnInt();

  var linkedVehicles = <Map<String, String>>[].obs;
  var periods = <Map<String, String>>[].obs;

  MakeBookingController({required this.stationId, required this.stationName});

  @override
  Future<void> onReady() async {
    _periodsDropdown();
    await _fetchUserVehicles();
    super.onReady();
  }

  Future<void> _fetchUserVehicles() async {
    final result = await MakeBookingService.getUserVehiclesDropdown();

    _isLoading.value = true;

    MuLogger.success('Vehicles result: ${result.data}');
    if (result.success && result.data != null) {
      linkedVehicles.assignAll(
        result.data!
            .map(
              (v) => {
                'id': v.vehicleId.toString(),
                'name': v.vehicleDetails ?? '',
              },
            )
            .toList(),
      );

      MuLogger.success('Vehicles: $linkedVehicles');
    } else {
      MuLogger.error('Vehicle fetch error: ');
      MuAlerts.showError('تعذر تحميل المركبات الخاصة بك');
    }

    _isLoading.value = false;
  }

  Future<void> _periodsDropdown() async {
    final result = await MakeBookingService.periodsDropdown();

    _isLoading.value = true;

    if (result.success && result.data != null) {
      periods.assignAll(
        result.data!
            .map((v) => {'id': v.id.toString(), 'name': v.name})
            .toList(),
      );
    } else {}

    _isLoading.value = false;
  }

  void updateSelectedVehicle(int? id) => selectedVehicleId.value = id;

  void updateSelectedPeriod(int id) => selectedPeriodId.value = id;

  Future<void> submitBooking({required int selectedStationId}) async {
    _isLoading.value = true;

    try {
      if (selectedVehicleId.value == null) {
        MuAlerts.showError('يرجى تحديد مركية ما');
        return;
      }
      print(selectedStationId);

      final response = await _api.makeBooking(
        MakeBookingRequest(
          stationDailyInfoId: selectedStationId,
          vehicleId: selectedVehicleId.value ?? 0,
          periodId: selectedPeriodId.value,
          fuelTypeId: 1,
          notes: "55555",
        ),
      );

      //TODO;
      if (response.success) {
        MuAlerts.showSuccess(response.message);
        AppRoutes.goTo(AppRoutes.home);
      } else {
        MuAlerts.showError(response.message);
      }
    } catch (e) {
      MuAlerts.showError('حدث خطأ أثناء إرسال الحجز');
    } finally {
      //   AppRoutes.goBack();
      _isLoading.value = false;
    }
  }
}
