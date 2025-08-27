import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Views/OTPScreen.dart';
import 'package:my_fuel/features/home/HomeBinding.dart';
import 'package:my_fuel/features/stations/Views/DailyInfoStationManegerScreen.dart';
import 'package:my_fuel/features/stations/Views/StationsManagerScreen.dart';
import 'package:my_fuel/shared/screens/QRCodeDisplayScreen.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

// 🛠 Shared
import 'package:my_fuel/shared/notifications/NotificationManagerScreen.dart';
import 'package:my_fuel/shared/notifications/NotificationScreen.dart';
import 'package:my_fuel/shared/screens/ErrorScreen.dart';
import 'package:my_fuel/shared/screens/splash_screen.dart';

// 🔐 Auth
import 'package:my_fuel/features/Auth/Views/AuthScreen.dart';

// 🏠 Home & Settings
import 'package:my_fuel/features/home/home_screen.dart';
import 'package:my_fuel/features/Settings/SettingsScreen.dart';
import 'package:my_fuel/features/_tests/MyAlertsTestScreen.dart';
import 'package:my_fuel/features/_tests/CameraScreen.dart';

// ⛽️ Stations
import 'package:my_fuel/features/stations/Views/StationFormScreen.dart';
import 'package:my_fuel/features/stations/Views/DailyInfoStationScreen.dart';

// 🚗 Vehicles
import 'package:my_fuel/features/vehicles/Views/AddNewVehicleScreen.dart';
import 'package:my_fuel/features/vehicles/Views/LinkingWithVehicleScreen.dart';
import 'package:my_fuel/features/Refueling/Views/RefuelScreen.dart';

// 📅 Booking
import 'package:my_fuel/features/booking/Views/BookingHistoryScreen.dart';

class AppRoutes {
  // Basic
  static const String initial = '/';
  static const String error = '/error';
  static const String qrGenerator = '/qrGenerator';

  // Auth & Main
  static const String auth = '/auth';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String alertsTest = '/alerts-test';
  static const String authVerifyOtp = '/auth-verifyOtpt';

  // Stations
  static const String stationList = '/stations/list';
  static const String stationAddOrUpdate = '/stations/add-or-update';
  static const String stationsManeger = '/stations/maneger';

  static const String stationDailyInfo = '/stations/daily-info';
  static const String stationReports = '/stations/reports';
  static const String stationDailyInfoManeger = '/stationDailyInfoManeger';

  // Vehicles
  static const String vehicleLinking = '/vehicles/link-user';
  static const String vehicleRefuel = '/vehicles/refuel';
  static const String vehicleNew = '/vehicles/new';
  static const String vehicleDropdown = '/vehicles/dropdown';

  // Booking
  static const String bookingHistory = '/booking/history';

  // Testing
  static const String camera = '/test/camera';
  static const String qrDisplay = '/qr_display';

  static const String notificationsTest = '/notificationsTest';
  // App Pages
  static final List<GetPage> routes = [
    // --- Basic
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: error, page: () => ErrorScreen(error: 'حدث خطأ غير معروف')),

    // --- Auth & Main
    GetPage(
      name: auth,
      page: () => AuthScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: authVerifyOtp,
      page: () => AuthOTPScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      //  middlewares: [GlobalMiddleware()],
    ),

    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      //  middlewares: [GlobalMiddleware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: notifications,
      page: () => NotificationManagerScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: notificationsTest,
      page: () => NotificationScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: stationDailyInfoManeger,
      page: () => DailyInfoStationManegerScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: alertsTest,
      page: () => const MyAlertsTestScreen(),
      transition: Transition.fade,
      //  middlewares: [GlobalMiddleware()],
    ),

    // --- Stations
    GetPage(
      name: stationList,
      page: () => const DailyInfoStationScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: stationAddOrUpdate,
      page: () {
        final args = Get.arguments ?? {};
        return StationFormScreen(stationId: args['stationId']);
      },
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      //  middlewares: [GlobalMiddleware()],
    ),
    /* GetPage(
      name: stationDailyInfo,
      page: () => OldManageStationDailyInfoScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 300),
    //  middlewares: [GlobalMiddleware()],
    ), */
    GetPage(
      name: stationsManeger,
      page: () => StationsManagerScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    /*  GetPage(
      name: stationReports,
      page: () => XStationReportScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      //  middlewares: [GlobalMiddleware()],
    ), */

    // --- Vehicles
    GetPage(
      name: vehicleLinking,
      page: () => LinkingWithVehicleScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: vehicleRefuel,
      page: () => RefuelScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: vehicleNew,
      page: () => AddNewVehicleScreen(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),

    // --- Booking
    GetPage(
      name: bookingHistory,
      page: () => BookingHistoryScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      //  middlewares: [GlobalMiddleware()],
    ),

    // --- Testing
    GetPage(
      name: camera,
      page: () => CameraScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      //  middlewares: [GlobalMiddleware()],
    ),
    GetPage(
      name: qrDisplay,
      page: () {
        final args = Get.arguments;
        return QRCodeDisplayScreen(
          //  plateNumber: args['plateNumber'],
          qrCodeData: args["qrCode"],
        );
      },
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      //  middlewares: [GlobalMiddleware()],
    ),
  ];

  // Navigation Helpers: Safe and Semantic Routing Layer

  /// Navigate to the error page with a custom error message.
  static Future<void> showErrorPage(String message) async {
    await Get.toNamed(error, arguments: {'error': message});
  }

  /// Navigate to a named route safely (with existence check).
  static Future<void> goTo(String route, {dynamic arguments}) async {
    try {
      final routeExists = routes.any((page) => page.name == route);
      if (!routeExists) {
        await showErrorPage("Route '$route' is not registered.");
        return;
      }

      await Get.toNamed(route, arguments: arguments);
    } catch (e) {
      MuLogger.exception(e.toString());
      await showErrorPage(e.toString());
    }
  }

  /// Replace the current screen with a new one.
  static Future<void> replaceWith(String route, {dynamic arguments}) async {
    try {
      await Get.offNamed(route, arguments: arguments);
    } catch (e) {
      MuLogger.exception(e);
      await showErrorPage(e.toString());
    }
  }

  /// Clear the entire navigation stack and go to a new screen.
  static Future<void> clearStackAndGoTo(
    String route, {
    dynamic arguments,
  }) async {
    try {
      await Get.offAllNamed(route, arguments: arguments);
    } catch (e) {
      MuLogger.exception(e);
      await showErrorPage(e.toString());
    }
  }

  /// Go back to the previous screen if possible.
  static void goBack({dynamic result}) {
    if (Navigator.of(Get.context!).canPop()) {
      Get.back(result: result);
    } else {
      MuLogger.error('No screen to go back to.');
    }
  }

  /// Go to a named route and remove previous routes until condition is met.
  static Future<void> goToAndRemoveUntil(
    String route,
    bool Function(Route<dynamic>) predicate, {
    dynamic arguments,
  }) async {
    try {
      await Get.offNamedUntil(route, predicate, arguments: arguments);
    } catch (e) {
      MuLogger.exception(e);
      await showErrorPage(e.toString());
    }
  }

  /// Try navigating to a named route without validation (fallback on error).
  static Future<void> tryTo(String route, {dynamic arguments}) async {
    try {
      await Get.toNamed(route, arguments: arguments);
    } catch (e) {
      MuLogger.exception(e);
      await showErrorPage(e.toString());
    }
  }
}
