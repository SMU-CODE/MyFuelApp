import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/features/stations/Services/DailyInfoStationsServiceForUser.dart';

import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared/helper/Parser.dart';

class StationsDailyInfoController extends GetxController {
  bool _isFetchingData = false;
  bool get isFetchingData => _isFetchingData;

  bool _fetchFailed = false;
  bool get fetchFailed => _fetchFailed;

  List<DailyInfoStationsForUserModel> _dailyStationInfos = [];
  List<DailyInfoStationsForUserModel> get dailyStationInfos =>
      _dailyStationInfos;
  String? errorMessage;

  @override
  Future<void> onReady() async {
    await fetchDailyStationData();
    super.onReady();
  }

  Future<void> fetchDailyStationData({DateTime? date}) async {
    _fetchFailed = false;
    errorMessage = null;
    _setLoadingState(true);
    final todday = Parser.formatDateTime(DateTime.now());

    try {
      final result = await DailyInfoStationsServiceForUser.stationsDailyInfo();

      if (result.success && result.data != null) {
        _dailyStationInfos = result.data!;

        MuLogger.success(result.message);
        if (_dailyStationInfos.isNotEmpty) {}
      } else {
        _fetchFailed = true;

        errorMessage = result.message;
      }
    } catch (e, stack) {
      _fetchFailed = true;
      MuLogger.exception(e, stack);
      errorMessage = "لا توجد محطات متاحة بمعلومات يومية أو حجوزات  لهذا اليوم";

      MuAlerts.showError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool value) {
    if (_isFetchingData != value) {
      _isFetchingData = value;
      update();
    }
  }
}
