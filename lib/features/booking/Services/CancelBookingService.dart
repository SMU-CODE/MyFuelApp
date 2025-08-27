import 'package:my_fuel/features/booking/Models/CancelBookingRequest.dart';

import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/EmptyModel.dart';

class CancelBookingService {
  static Future<ApiResponse<EmptyModel>> cancelBooking(
    int bookingId,
    String cancellationReason,
  ) async {
    final api = await ApiService.getInstance();
    CancelBookingRequest requestData = CancelBookingRequest(
      bookingId: bookingId,
      cancellationReason: cancellationReason,
    );
    final response = await api.post<EmptyModel>(
      ApiConstants.booking.cancel,
      body: requestData.toJson(),
      fromJson: EmptyModel.fromJson,
    );

    return response;
  }
}
