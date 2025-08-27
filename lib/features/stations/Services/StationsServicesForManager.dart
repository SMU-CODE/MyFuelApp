import 'package:dio/dio.dart';
import 'package:my_fuel/features/stations/Models/StationFormRequest.dart';
import 'package:my_fuel/features/stations/Models/StationResponseForManager.dart';
import 'package:my_fuel/features/stations/Models/StationsDropdownModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/EmptyModel.dart';

class StationsServicesForManager {
  StationsServicesForManager();

  static Future<ApiResponse<EmptyModel>> addNewStation(
    StationFormRequest requestData,
  ) async {
    final api = await ApiService.getInstance();

    FormData formData = FormData.fromMap({
      'name': requestData.name,
      'location': requestData.location,
      'about': requestData.about,
      //note: Convert boolean to string "1" or "0" for Laravel's boolean validation
      'is_active': requestData.isActive == true ? '1' : '0',

      if (requestData.imageFile != null)
        'image': await MultipartFile.fromFile(
          requestData.imageFile!.path,
          filename: requestData.imageFile!.path.split('/').last,
        ),
    });

    final result = await api.post(
      ApiConstants.station.addNew,
      body: formData,
      fromJson: EmptyModel.fromJson,
    );

    return result;
  }

  static Future<ApiResponse<EmptyModel>> updateStation(
    String stationId,
    StationFormRequest requestData,
  ) async {
    final api = await ApiService.getInstance();

    final Map<String, dynamic> formDataMap = {};

    if (requestData.name != null) formDataMap['name'] = requestData.name;
    if (requestData.location != null) {
      formDataMap['location'] = requestData.location;
    }
    if (requestData.about != null) formDataMap['about'] = requestData.about;
    if (requestData.isActive != null) {
      formDataMap['is_active'] = requestData.isActive == true ? '1' : '0';
    }

    if (requestData.imageFile != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        requestData.imageFile!.path,
        filename: requestData.imageFile!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final result = await api.post(
      ApiConstants.station.update(stationId),
      body: formData,
      fromJson: EmptyModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<List<StationResponseForManager>>> getAllStations() async {
    final api = await ApiService.getInstance();
    final result = await api.getList(
      ApiConstants.station.showAll,
      StationResponseForManager.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<StationResponseForManager>> getStationById(
    String stationId,
  ) async {
    final api = await ApiService.getInstance();
    final result = await api.get(
      ApiConstants.station.show(stationId),
      fromJson: (json) => StationResponseForManager.fromJson(json),
    );
    return result;
  }

  static Future<ApiResponse<EmptyModel>> deleteStation(String stationId) async {
    final api = await ApiService.getInstance();
    final result = await api.delete(
      ApiConstants.station.destroy(stationId),
      fromJson: EmptyModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<List<StationsDropdownModel>>>
  stationsDropDown() async {
    final api = await ApiService.getInstance();
    final result = await api.getList<StationsDropdownModel>(
      ApiConstants.station.dropdown,
      StationsDropdownModel.fromJson,
    );
    return result;
  }
}
