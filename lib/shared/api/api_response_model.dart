// File: api_response_model.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'api_http_status.dart';

class ExceptionDetails {
  final String message;
  final String type;

  ExceptionDetails({required this.message, required this.type});

  factory ExceptionDetails.fromJson(Map<String, dynamic> json) {
    return ExceptionDetails(
      message: json['message'] ?? 'خطأ غير معروف',
      type: json['type'] ?? 'نوع غير معروف',
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final ExceptionDetails? exception;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
    this.exception,
  });
  factory ApiResponse.fromDioResponse(
    Response response,
    T Function(Map<String, dynamic> json)? dataDeserializer,
  ) {
    final dynamic responseData = response.data;
    final Map<String, dynamic> json =
        responseData is Map ? Map<String, dynamic>.from(responseData) : {};

    ExceptionDetails? exceptionDetails;
    if (json['exception'] != null && json['exception'] is Map) {
      exceptionDetails = ExceptionDetails.fromJson(json['exception']);
    }

    dynamic processedData;
    if (responseData != null && dataDeserializer != null) {
      try {
        if (responseData is Map && responseData['data'] is List) {
          processedData =
              (responseData['data'] as List)
                  .map((e) => dataDeserializer(e as Map<String, dynamic>))
                  .toList();
        } else if (responseData is Map && responseData['data'] is Map) {
          processedData = dataDeserializer(
            responseData['data'] as Map<String, dynamic>,
          );
        } else if (responseData is List) {
          processedData =
              responseData
                  .map((e) => dataDeserializer(e as Map<String, dynamic>))
                  .toList();
        }
      } catch (e, stack) {
        debugPrint('Error deserializing data: $e\n$stack');
      }
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      statusCode:
          json['status_code'] ??
          response.statusCode ??
          ApiHttpStatus.internalServerError,
      message: json['message'] ?? 'حدث خطأ غير متوقع',
      data: processedData as T?,
      errors:
          json['errors'] != null
              ? Map<String, dynamic>.from(json['errors'])
              : null,
      exception: exceptionDetails,
    );
  }

  factory ApiResponse.fromDioException(DioException e) {
    String message = 'حدث خطأ غير متوقع.';
    int statusCode = ApiHttpStatus.internalServerError;
    Map<String, dynamic>? errors;
    ExceptionDetails? exceptionDetails;

    if (e.response != null) {
      statusCode = e.response!.statusCode ?? ApiHttpStatus.internalServerError;
      if (e.response!.data is Map<String, dynamic>) {
        final Map<String, dynamic> errorData = e.response!.data;
        message = errorData['message'] ?? message;
        errors =
            errorData['errors'] != null
                ? Map<String, dynamic>.from(errorData['errors'])
                : null;
        if (errorData['exception'] != null && errorData['exception'] is Map) {
          exceptionDetails = ExceptionDetails.fromJson(errorData['exception']);
        }
      }
    } else {
      message = 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.';
    }

    return ApiResponse<T>(
      success: false,
      statusCode: statusCode,
      message: message,
      errors: errors,
      exception: exceptionDetails,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      statusCode: ApiHttpStatus.internalServerError,
      message: message,
    );
  }
}
