import 'package:my_fuel/features/booking/Models/MakeBookingRequest.dart';
import 'package:my_fuel/features/booking/Models/PeriodsDropdownModel.dart';
import 'package:my_fuel/features/booking/Models/UserVehiclesDropdownModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/EmptyModel.dart';

class MakeBookingService {
  Future<ApiResponse<EmptyModel?>> makeBooking(
    MakeBookingRequest requestData,
  ) async {
    final api = await ApiService.getInstance();

    final response = await api.post(
      ApiConstants.booking.make,
      body: requestData.toJson(),
      fromJson: EmptyModel.fromJson,
    );

    return response;
  }

  static Future<ApiResponse<List<UserVehiclesDropdownModel>>>
  getUserVehiclesDropdown() async {
    final api = await ApiService.getInstance();

    final result = await api.getList<UserVehiclesDropdownModel>(
      ApiConstants.vehicle.userVehiclesDropdown,
      UserVehiclesDropdownModel.fromJson,
    );

    return result;
  }

  static Future<ApiResponse<List<PeriodsDropdownModel>>>
  periodsDropdown() async {
    final api = await ApiService.getInstance();

    final result = await api.getList<PeriodsDropdownModel>(
      ApiConstants.period.periodsDropdown,
      PeriodsDropdownModel.fromJson,
    );

    return result;
  }
}
