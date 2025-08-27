// lib/shared/middleware/GlobalMiddleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/features/Auth/Views/AuthScreen.dart';
import 'package:my_fuel/shared/constant/AppKeys.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/screens/ErrorScreen.dart';
import 'package:my_fuel/shared/services/StorageService.dart';

class GlobalMiddleware extends GetMiddleware {
  final AuthController _authController = Get.find<AuthController>();

  // القوائم المحددة مسبقًا كـ static const لتحسين الأداء
  static const List<String> _publicRoutes = [
    AppRoutes.initial,
    AppRoutes.auth,
    AppRoutes.settings,
    AppRoutes.authVerifyOtp,
  ];

  static const List<String> _authRoutes = [
    AppRoutes.auth,
    AppRoutes.authVerifyOtp,
  ];

  @override
  RouteSettings? redirect(String? route) {
    try {
      if (route == null) return null;

      final isPublic = _publicRoutes.contains(route);
      final isAuthRoute = _authRoutes.contains(route);
      final isLoggedIn = _authController.isAuthenticated;

      // حالة: مسجل دخول ويحاول الوصول إلى شاشات Auth
      if (isLoggedIn && isAuthRoute) {
        return const RouteSettings(name: AppRoutes.home);
      }

      // حالة: غير مسجل دخول ويحاول الوصول إلى شاشات خاصة
      if (!isLoggedIn && !isPublic) {
        return RouteSettings(
          name: AppRoutes.auth,
          arguments: {'redirect': route, 'message': 'يجب تسجيل الدخول أولاً'},
        );
      }

      return null;
    } catch (e, st) {
      MuLogger.exception(
        "GlobalMiddleware redirect error , extra: {'route': $route}",
        st,
      );
      return const RouteSettings(name: AppRoutes.error);
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    try {
      // إضافة تحقق إضافي من التوكن قبل تحميل الصفحة
      if (page != null && !_publicRoutes.contains(page.name)) {
        final token = StorageService.read<String>(AppKeys.authToken);
        if (token == null || token.isEmpty) {
          return GetPage(
            name: AppRoutes.auth,
            page: () =>const  AuthScreen(),
            arguments: {'redirect': page.name},
          );
        }
      }
      return super.onPageCalled(page);
    } catch (e, st) {
      MuLogger.exception(
        "GlobalMiddleware page error   extra: {'page': ${page?.name}}",
        st,
      );
      return GetPage(
        name: AppRoutes.error,
        page:
            () => ErrorScreen(
              error: 'حدث خطأ غير متوقع',
              //  showRetry: true,
            ),
      );
    }
  }

  @override
  void onPageDispose() {
    // تنظيف الموارد عند إغلاق الصفحة
    _authController.disposeTemporaryResources();
    super.onPageDispose();
  }
}
