import 'package:my_fuel/features/vehicles/Models/AddNewVehicleRequest.dart';
import 'package:my_fuel/features/vehicles/Models/UservehicleswithdetailsModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/EmptyResponseModel.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';

class VehicleService {
  static Future<ApiResponse<List<UservehicleswithdetailsModel>>>
  getUserVehiclesWithDetails() async {
    final api = await ApiService.getInstance();
    final result = await api.getList<UservehicleswithdetailsModel>(
      ApiConstants.vehicle.userVehiclesWithDetails,
      UservehicleswithdetailsModel.fromJson,
    );
    return result;
  }

  static Future<ApiResponse<EmptyResponseModel>> addNewVehicle(
    AddNewVehicleRequest request,
  ) async {
    final api = await ApiService.getInstance();
    final response = await api.post(
      ApiConstants.vehicle.store,
      fromJson: (json) => EmptyResponseModel.fromJson(json),
      body: request.toJson(),
    );
    return response;
  }
}
