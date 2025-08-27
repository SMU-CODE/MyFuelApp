import 'package:my_fuel/features/stations/Models/DailyInfoStationFormRequest.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationByIdModel.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoManegerModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/EmptyModel.dart';

class DailyInfoStationsServicesForManager {
  DailyInfoStationsServicesForManager();

  static Future<ApiResponse<EmptyModel>> addNewStationDailyInfo(
    DailyInfoStationFormRequest requestData,
  ) async {
    final api = await ApiService.getInstance();
    final result = await api.post(
      ApiConstants.stationDailyInfo.addNew,
      body: requestData.toJson(),
      fromJson: EmptyModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<EmptyModel>> updateStationDailyInfo(
    String dailyInfoId,
    DailyInfoStationFormRequest requestData,
  ) async {
    final api = await ApiService.getInstance();
    final result = await api.patch(
      ApiConstants.stationDailyInfo.update(dailyInfoId),
      body: requestData.toJson(),
      fromJson: EmptyModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<List<DailyInfoManegerModel>>>
  getAllStationDailyInfos() async {
    final api = await ApiService.getInstance();
    final result = await api.getList(
      ApiConstants.stationDailyInfo.getAllStationsDailyInfoForDate(),
      DailyInfoManegerModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<DailyInfoStationByIdModel>> getStationDailyInfoById(
    String dailyInfoId,
  ) async {
    final api = await ApiService.getInstance();
    final result = await api.get(
      ApiConstants.stationDailyInfo.show(dailyInfoId),
      fromJson: DailyInfoStationByIdModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<EmptyModel>> deleteStationDailyInfo(
    String dailyInfoId,
  ) async {
    final api = await ApiService.getInstance();
    final result = await api.delete(
      ApiConstants.stationDailyInfo.destroy(dailyInfoId),
      fromJson: EmptyModel.fromJson,
    );
    return result;
  }
}
