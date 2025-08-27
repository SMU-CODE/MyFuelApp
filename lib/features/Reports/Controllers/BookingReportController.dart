// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:my_fuel/features/Reports/Models/BookingReportRequest.dart';
import 'package:my_fuel/features/Reports/Models/booking_report_item.dart';
import 'package:my_fuel/features/Reports/Services/BookingReportService.dart';
import 'package:my_fuel/features/stations/services/StationsServicesForManager.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class BookingReportController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<BookingReportItem> _reportItems = <BookingReportItem>[].obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<BookingReportItem> get reportItems => _reportItems.value;
  bool get hasData => _reportItems.isNotEmpty;
  bool get hasError => _errorMessage.isNotEmpty;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final RxList<int> selectedStationIds = <int>[].obs;
  final RxList<int> selectedFuelTypeIds = <int>[].obs;
  final RxList<String> selectedStatuses = <String>[].obs;
  final Rx<int?> selectedUserId = Rx<int?>(null);
  final Rx<String?> selectedGroupBy = Rx<String?>(null);

  RxList<Map<String, dynamic>> stationsDropdown = <Map<String, dynamic>>[].obs;

  Future<void> _loadStationsDropdown() async {
    try {
      _isLoading.value = true;

      final result = await StationsServicesForManager.stationsDropDown();

      if (result.success && result.data != null) {
        stationsDropdown.assignAll(
          result.data!.map((v) => {'id': v.id, 'name': v.name ?? ''}).toList(),
        );
      } else {
        // Handle the case where the API call was not successful or data is null
        MuAlerts.showWarning('فشل تحميل قائمة المحطات: ${result.message}');
      }
    } catch (e) {
      MuLogger.exception(e);
      _errorMessage.value = 'حدث خطأ أثناء تحميل المحطات: ${e.toString()}';
      MuAlerts.showError('فشل تحميل المحطات. الرجاء المحاولة لاحقاً.');
    } finally {
      _isLoading.value = false;
    }
  }

  final List<Map<String, dynamic>> availableFuelTypes = [
    {'id': 1, 'name': 'بنزين 91'},
    {'id': 2, 'name': 'ديزل'},
    {'id': 3, 'name': 'بنزين 95'},
  ];

  final List<String> availableStatuses = [
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];
  final List<Map<String, dynamic>> availableGroupBys = [
    {'value': null, 'label': 'لا يوجد تجميع'},
    {'value': 'station', 'label': 'حسب المحطة'},
    {'value': 'fuel_type', 'label': 'حسب نوع الوقود'},
    {'value': 'status', 'label': 'حسب الحالة'},
    {'value': 'user', 'label': 'حسب المستخدم'},
    {'value': 'date', 'label': 'حسب التاريخ'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadStationsDropdown();
    fetchReport();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('ar', 'AR'),
    );

    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().split('T')[0];
    }
  }

  Future<void> fetchReport() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final request = BookingReportRequest(
        startDate:
            startDateController.text.isEmpty ? null : startDateController.text,
        endDate: endDateController.text.isEmpty ? null : endDateController.text,
        stationIds:
            selectedStationIds.isEmpty ? null : selectedStationIds.toList(),
        fuelTypeIds:
            selectedFuelTypeIds.isEmpty ? null : selectedFuelTypeIds.toList(),
        status: selectedStatuses.isEmpty ? null : selectedStatuses.toList(),
        userId: selectedUserId.value,
        groupBy: selectedGroupBy.value,
      );

      final ApiResponse<List<BookingReportItem>> response =
          await BookingReportService.getUserVehiclesWithDetails(request);

      if (response.success && response.data != null) {
        _reportItems.assignAll(response.data!);
        if (response.data!.isEmpty) {
          _errorMessage.value = 'لا توجد بيانات متاحة للتقرير المحدد.';
        } else {
          MuAlerts.showSuccess('تم تحديث التقرير بنجاح.');
        }
      } else {
        _errorMessage.value = response.message;
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to fetch booking report");
      _errorMessage.value = 'حدث خطأ غير متوقع: ${e.toString()}';
      MuAlerts.showError('فشل جلب التقرير. الرجاء المحاولة لاحقاً.');
    } finally {
      _isLoading.value = false;
    }
  }

  void resetFilters() {
    startDateController.clear();
    endDateController.clear();
    selectedStationIds.clear();
    selectedFuelTypeIds.clear();
    selectedStatuses.clear();
    selectedUserId.value = null;
    selectedGroupBy.value = null;
    fetchReport();
  }
}
