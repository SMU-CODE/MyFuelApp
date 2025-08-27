// my_fuel/shared/api/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_interceptors.dart';

enum HttpMethod { get, post, put, delete, upload, patch }

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;
  CancelToken _globalCancelToken = CancelToken();

  ApiService._internal();

  static Future<ApiService> getInstance() async {
    if (_instance != null) return _instance!;
    _instance = ApiService._internal();
    await _instance!._init();
    return _instance!;
  }

  Future<void> _init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.defaultHeaders,
        validateStatus:
            (status) => status != null && (status < 500 || status == 422),
      ),
    );

    ApiInterceptors(dio: _dio).addAuthInterceptor();

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: false,
        ),
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? fromJson,
  }) async {
    return await _request<T>(
      method: HttpMethod.get,
      path: path,
      queryParameters: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? fromJson,
  }) async {
    return await _request<T>(
      method: HttpMethod.post,
      path: path,
      data: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? fromJson,
  }) async {
    return await _request<T>(
      method: HttpMethod.put,
      path: path,
      data: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? fromJson,
  }) async {
    return await _request<T>(
      method: HttpMethod.delete,
      path: path,
      data: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? fromJson,
  }) async {
    return await _request<T>(
      method: HttpMethod.patch,
      path: path,
      data: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _request<T>({
    required HttpMethod method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      late Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _globalCancelToken,
          );
          break;
        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _globalCancelToken,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            cancelToken: cancelToken ?? _globalCancelToken,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            cancelToken: cancelToken ?? _globalCancelToken,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            cancelToken: cancelToken ?? _globalCancelToken,
          );
          break;
        case HttpMethod.upload:
          throw UnimplementedError();
      }

      return ApiResponse<T>.fromDioResponse(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse<T>.fromDioException(e);
    } catch (e, stack) {
      if (kDebugMode) {
        print('Unhandled error: $e\n$stack');
      }
      return ApiResponse<T>.error('حدث خطأ في التطبيق');
    }
  }

  void cancelAllRequests() {
    _globalCancelToken.cancel('تم إلغاء جميع الطلبات');
    _globalCancelToken = CancelToken();
  }
}

extension ApiListExtensions on ApiService {
  Future<ApiResponse<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
        {Map<String, dynamic>? query}
  ) async {
    try {
      final response = await _dio.get(path, queryParameters: query,cancelToken: _globalCancelToken);

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        return ApiResponse<List<T>>.error('Invalid response format');
      }

      if (responseData['data'] is! List) {
        return ApiResponse<List<T>>(
          success: responseData['success'] ?? false,
          statusCode: response.statusCode ?? 200,
          message: responseData['message'] ?? '',
          data: [],
          errors:
              responseData['errors'] != null
                  ? Map<String, dynamic>.from(responseData['errors'])
                  : null,
        );
      }

      final List<dynamic> dataList = responseData['data'] as List;
      final List<T> result =
          dataList.map((item) {
            try {
              return fromJson(item as Map<String, dynamic>);
            } catch (e) {
              throw Exception('Failed to parse item: $e');
            }
          }).toList();

      return ApiResponse<List<T>>(
        success: responseData['success'] ?? true,
        statusCode: response.statusCode ?? 200,
        message: responseData['message'] ?? 'Success',
        data: result,
        errors:
            responseData['errors'] != null
                ? Map<String, dynamic>.from(responseData['errors'])
                : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<T>>.fromDioException(e);
    } catch (e) {
      return ApiResponse<List<T>>.error('Failed to load data: $e');
    }
  }
}
