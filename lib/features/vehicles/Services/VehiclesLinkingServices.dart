import 'package:my_fuel/features/vehicles/Models/LinkingVehicleRequest.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/EmptyResponseModel.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';

class VehiclesLinkingServices {
  static Future<ApiResponse<EmptyResponseModel>> linkVehicle(
    LinkingVehicleRequest request,
  ) async {
    final api = await ApiService.getInstance();
    final response = await api.post(
      ApiConstants.vehicle.link,
     fromJson:(json) =>  EmptyResponseModel.fromJson(json),
      body: request.toJson(),
    );
    return response;
  }

  static Future<ApiResponse<EmptyResponseModel>> unlinkVehicle(
    LinkingVehicleRequest request,
  ) async {
    final api = await ApiService.getInstance();
    final response = await api.post(
      ApiConstants.vehicle.unlink,
     fromJson:(json) =>  EmptyResponseModel.fromJson(json),
      body: request.toJson(),
    );
    return response;
  }
}
