import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/theme/ThemeController.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxString selectedLanguage = 'العربية'.obs;
  final List<String> languages = ['العربية', 'English']; // Available languages

  late final ThemeController _themeController;

  // --- Getters for UI access ---
  bool get isDarkModeEnabled =>
      _themeController.isDarkMode; // Directly from ThemeController

  @override
  void onInit() {
    super.onInit();
    // Ensure MyAlerts is properly initialized and bound (e.g., in InitialBindings).
    // If not, you might need: Get.lazyPut(() => MyAlerts()); in InitialBindings
    // or a different initialization strategy based on how MyAlerts is set up.
    // MuAlerts = Get.find<MyAlerts>(); // Find MyAlerts instance
    _themeController =
        Get.find<ThemeController>(); // Find the ThemeController instance
    _loadSettings(); // Load settings when controller is initialized
  }

  // --- Settings Management (using GetStorage for consistency if needed, or keeping SharedPreferences for other settings) ---
  // For non-theme settings, you can keep using SharedPreferences or switch to GetStorage for all.
  // Let's keep SharedPreferences for these non-theme specific settings for now as per your original code.
  Future<void> _loadSettings() async {
    final prefs =
        GetStorage(); // Use GetStorage for consistency if available, or SharedPreferences.getInstance()
    notificationsEnabled.value =
        prefs.read<bool>('notifications') ?? true; // Use .read for GetStorage
    selectedLanguage.value =
        prefs.read<String>('language') ?? 'العربية'; // Use .read for GetStorage
    // Dark mode is loaded and managed directly by ThemeController
  }

  Future<void> _saveSettings() async {
    final prefs = GetStorage(); // Use GetStorage for consistency
    await prefs.write(
      'notifications',
      notificationsEnabled.value,
    ); // Use .write for GetStorage
    await prefs.write(
      'language',
      selectedLanguage.value,
    ); // Use .write for GetStorage
    // Dark mode is saved directly by ThemeController when it toggles
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _saveSettings();
    Get.snackbar(
      'الإشعارات',
      value ? 'تم تفعيل الإشعارات' : 'تم تعطيل الإشعارات',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          Get
              .theme
              .colorScheme
              .primaryContainer, // Use primaryContainer for snackbar background
      colorText:
          Get
              .theme
              .colorScheme
              .onPrimaryContainer, // Use onPrimaryContainer for text color
    );
  }

  void toggleDarkMode(bool value) {
    // This directly calls the toggle method in your ThemeController
    _themeController.toggleTheme();
    MuAlerts.showSuccess(
      'تم تغيير الوضع الليلي',
    ); // Ensure MyAlerts displays themed alerts
  }

  void setLanguage(String? newLanguage) {
    if (newLanguage != null) {
      selectedLanguage.value = newLanguage;
      _saveSettings();
      // You would typically update the app's locale here using GetX's updateLocale
      // Get.updateLocale(Locale(newLanguage == 'العربية' ? 'ar' : 'en'));
      MuAlerts.showSuccess(
        'تم تغيير اللغة إلى $newLanguage',
      ); // Ensure MyAlerts displays themed alerts
    }
  }

  // --- External Link Functions ---
  Future<void> launchPrivacyPolicy() async {
    const url =
        'https://example.com/privacy-policy'; // Replace with your actual policy URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      MuAlerts.showError('تعذر فتح سياسة الخصوصية');
    }
  }

  Future<void> launchContactUs() async {
    const email =
        'mailto:support@example.com'; // Replace with your actual support email
    if (await canLaunchUrl(Uri.parse(email))) {
      await launchUrl(Uri.parse(email));
    } else {
      MuAlerts.showError('تعذر فتح تطبيق البريد');
    }
  }

  // --- Other Utility Functions (e.g., App Version) ---
  String getAppVersion() {
    // In a real app, you'd get this from package_info_plus
    return '1.0.0';
  }
}
