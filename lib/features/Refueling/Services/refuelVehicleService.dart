import 'package:my_fuel/features/vehicles/Models/VehicleWithInfoModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/features/Refueling/Models/RefuelingRequest.dart';
import 'package:my_fuel/shared/api/EmptyModel.dart';

class RefuelVehicleService {
  static Future<ApiResponse<EmptyModel>> refuelVehicle({
    required String vehicleQrCode,
    required String notes,
  }) async {
    final requestData = RefuelingRequest(
      vehicleQrCode: vehicleQrCode,
      notes: notes,
    );
    final api = await ApiService.getInstance();

    final result = await api.post(
      ApiConstants.refuel.refuel,
      body: requestData.toJson(),
      fromJson: EmptyModel.fromJson,
    );

    return result;
  }

  static Future<ApiResponse<VehicleWithInfoModel>> getVehicleInfoByQr(
    String qrCode,
  ) async {
    final api = await ApiService.getInstance();
    final response = await api.post(
      ApiConstants.refuel.getVehicleInfoByQr,
      body: RefuelingRequest(vehicleQrCode: qrCode),
      fromJson: VehicleWithInfoModel.fromJson,
    );
    return response;
  }
}
