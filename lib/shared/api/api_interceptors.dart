// Your existing ApiInterceptors.dart file remains correct as is
import 'package:dio/dio.dart';
import 'package:my_fuel/shared/constant/AppKeys.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared//services/StorageService.dart';

class ApiInterceptors {
  final Dio dio;

  ApiInterceptors({required this.dio});

  void addAuthInterceptor() {
    dio.interceptors.add(
      QueuedInterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

final token = await StorageService.readAsync<String>(AppKeys.authToken);
  
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      MuLogger.important("Unauthorized error - removing token: $error");

      await StorageService.remove(AppKeys.authToken);

      // يمكنك توجيه المستخدم هنا عند الحاجة
      // TODO: مثل Get.offAllNamed(AppRoutes.auth);

      handler.next(error);
    } else {
      handler.next(error);
    }
  }
}
