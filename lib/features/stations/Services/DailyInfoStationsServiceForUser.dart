import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';

class DailyInfoStationsServiceForUser {
  /// Get all daily station info records
  static Future<ApiResponse<List<DailyInfoStationsForUserModel>>>
  stationsDailyInfo() async {
    final api = await ApiService.getInstance();

    final result = await api.getList<DailyInfoStationsForUserModel>(
      ApiConstants.stationDailyInfo.stationsDailyInfoForUser,
      DailyInfoStationsForUserModel.fromJson,
    );

    return result;
  }
}
