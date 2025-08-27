// my_fuel/features/Reports/Services/BookingReportService.dart
import 'package:my_fuel/features/Reports/Models/BookingReportRequest.dart';
import 'package:my_fuel/features/Reports/Models/booking_report_item.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';

class BookingReportService {
  static Future<ApiResponse<List<BookingReportItem>>>
  getUserVehiclesWithDetails(BookingReportRequest request) async {
    final api = await ApiService.getInstance();
    final result = await api.post<List<BookingReportItem>>(
      ApiConstants.reporting.bookings,
      body: request.toJson(),
      fromJson: (dynamic json) {
        if (json is List) {
          return json.map((item) => BookingReportItem.fromJson(item)).toList();
        } else if (json is Map<String, dynamic>) {
          return [BookingReportItem.fromJson(json)];
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }
   // ************* دالة جديدة لجلب تقرير HTML *************
  static Future<ApiResponse<String>> getHtmlReport(BookingReportRequest request) async {
    final api = await ApiService.getInstance();
    // يجب أن تكون هذه الاستدعاء من نوع POST إذا كان الخادم يتوقع POST
    // وتتوقع استجابة نصية (HTML)
    final result = await api.post<String>(
      ApiConstants.reporting.bookings,
      body: request.toJson(),
      // تأكد أن الخادم يرسل header لـ Content-Type: text/html
      // و ApiService الخاص بك يمكنه التعامل مع استجابة String
      fromJson: (dynamic json) {
        // إذا كان الخادم يرسل HTML مباشرة كـ body، هنا ستستقبل الـ String
        if (json is String) {
          return json;
        }
        throw Exception('Expected HTML string, but got different format');
      },
    );
    return result;
  }
}
