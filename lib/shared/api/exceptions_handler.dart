// File: exceptions_handler.dart

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_http_status.dart';

/// Handles various exceptions and returns a standardized ApiResponse.
class ExceptionsHandler {
  /// Handles Dio-specific exceptions.
  static ApiResponse<T> handleDioException<T>(dio.DioException e) {
    String message = 'حدث خطأ غير متوقع.';
    int statusCode = ApiHttpStatus.internalServerError;
    Map<String, dynamic>? errors;
    ExceptionDetails? exceptionDetails;
    dynamic responseData;

    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
        message = 'انتهت مهلة الاتصال بالخادم';
        statusCode = ApiHttpStatus.requestTimeout;
        break;
      case dio.DioExceptionType.sendTimeout:
        message = 'انتهت مهلة إرسال البيانات';
        statusCode = ApiHttpStatus.requestTimeout;
        break;
      case dio.DioExceptionType.receiveTimeout:
        message = 'انتهت مهلة استقبال البيانات';
        statusCode = ApiHttpStatus.requestTimeout;
        break;
      case dio.DioExceptionType.badCertificate:
        message = 'خطأ في شهادة الأمان';
        statusCode = ApiHttpStatus.badRequest;
        break;
      case dio.DioExceptionType.badResponse:
        // سيتم معالجته أدناه إن وجد response
        break;
      case dio.DioExceptionType.cancel:
        message = 'تم إلغاء الطلب';
        statusCode = ApiHttpStatus.clientClosedRequest;
        break;
      case dio.DioExceptionType.connectionError:
        message = 'تعذر الاتصال بالخادم';
        statusCode = ApiHttpStatus.serviceUnavailable;
        break;
      case dio.DioExceptionType.unknown:
        message = 'خطأ غير معروف';
        break;
    }

    if (e.response != null) {
      statusCode = e.response!.statusCode ?? statusCode;
      responseData = e.response!.data;

      if (responseData is Map<String, dynamic>) {
        final errorData = responseData;
        message = errorData['message'] ?? message;
        errors =
            errorData['errors'] != null
                ? Map<String, dynamic>.from(errorData['errors'])
                : null;

        if (errorData['exception'] != null) {
          exceptionDetails = ExceptionDetails.fromJson(errorData['exception']);
        }
      }
    }

    Get.log('''
🚫 API Request Error:
Status: $statusCode
Message: $message
${errors != null ? 'Errors: $errors' : ''}
${exceptionDetails != null ? 'Exception: ${exceptionDetails.toString()}' : ''}
''');

    return ApiResponse<T>(
      success: false,
      statusCode: statusCode,
      message: message,
      errors: errors,
      exception: exceptionDetails,
      data: responseData,
    );
  }

  /// Handles general exceptions.
  static ApiResponse<T> handleGeneralException<T>(
    Object e,
    StackTrace stack,
    String file,
  ) {
    final errorMessage = e.toString();
    final stackTrace = stack.toString();

    Get.log('''
💥 Unexpected Error:
Error: $errorMessage
File: $file
Stack Trace: $stackTrace
''');

    return ApiResponse<T>(
      success: false,
      statusCode: ApiHttpStatus.internalServerError,
      message: 'حدث خطأ غير متوقع أثناء معالجة طلبك.',
      exception: ExceptionDetails(
        message: errorMessage,
        type: e.runtimeType.toString(),
      ),
      data: null,
    );
  }
}
