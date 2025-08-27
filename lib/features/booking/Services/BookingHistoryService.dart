// هذا الملف يجب أن يكون موجودًا بالفعل ولديه التغييرات المذكورة سابقًا
import 'package:my_fuel/features/booking/Models/BookingHistoryModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';

class BookingHistoryService {
  static Future<ApiResponse<List<BookingHistoryModel>>>
  fetchBookingHistory2() async {
    final api = await ApiService.getInstance();
    final response = await api.getList<BookingHistoryModel>(
      ApiConstants.booking.index,
      BookingHistoryModel.fromJson,
    );

    return response;
  }

  static Future<ApiResponse<List<BookingHistoryModel>>>
  fetchBookingHistory() async {
    final api = await ApiService.getInstance();
    final response = await api.getList<BookingHistoryModel>(
      ApiConstants.booking.userBookings,
      BookingHistoryModel.fromJson,
    );

    return response;
  }
}
