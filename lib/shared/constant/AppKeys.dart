// lib/shared/constants/app_keys.dart
class AppKeys {
  // Private constructor to prevent instantiation
  AppKeys._();

  // Authentication related keys
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String phoneNumber = 'user_phone';
  static const String userRole = 'user_role';
  static const String userRoleId = 'user_role_id';
  
  // App settings keys
  static const String appTheme = 'app_theme';
  static const String appLanguage = 'app_language';
  static const String firstLaunch = 'first_launch';
  
  // Feature-specific keys
  static const String lastFuelUpdate = 'last_fuel_update';
  static const String notificationPrefs = 'notification_prefs';
  
  // Secure storage keys (for sensitive data)
  static const String securePinCode = 'secure_pin_code';
  static const String biometricAuthEnabled = 'biometric_auth_enabled';
}
