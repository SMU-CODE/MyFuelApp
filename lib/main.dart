// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/notifications/NotificationController.dart';
import 'package:my_fuel/shared/notifications/NotificationService.dart';
import 'package:my_fuel/shared/services/StorageService.dart';
import 'package:my_fuel/shared/theme/ThemeController.dart';
import 'package:my_fuel/shared/theme/app_theme.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Arabic date formatting
  await initializeDateFormatting('ar');

  await StorageService.init();
  Get.put(StorageService());
  final NotificationService notificationService = Get.put(
    NotificationService(),
  );
  await notificationService.initialize();

  // NotificationController
  Get.put(NotificationController());

  // 3. Initialize other essential services that might depend on StorageService
  await Get.putAsync(() => ThemeController().init());

  Get.put(ApiService.getInstance());
  // ApiService might read tokens from StorageService
  Get.put(
    AuthController(),
  ); // AuthControllerImp will now correctly find StorageService
  // تهيئة NotificationService

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(390, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'وقــــــــودي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.initial,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          locale: const Locale('ar'),
          builder:
              (context, widget) => Directionality(
                textDirection: TextDirection.rtl,
                child: widget ?? const SizedBox.shrink(),
              ),
        );
      },
    );
  }
}
