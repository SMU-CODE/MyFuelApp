import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/constant/AppKeys.dart';
import 'package:my_fuel/shared/theme/ThemeController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final ThemeController _themeController = Get.find();
  final GetStorage _storage = GetStorage();

  Widget _buildUserHeader() {
    final username = _storage.read(AppKeys.userName) ?? 'زائر';
    final phoneNumber = _storage.read(AppKeys.phoneNumber) ?? 'غير مسجل';

    return UserAccountsDrawerHeader(
      currentAccountPictureSize: AppSize.avatarSize * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: (0.8)),
          ],
        ),
      ),
      arrowColor: Colors.red,
      accountName: Row(
        children: [
          SizedBox(height: 8),
          Text(
            username,
            style: TextStyle(
              fontSize: AppSize.mediumFont,
              fontWeight: AppFont.wbold,
              fontFamily: AppFont.primaryFont,
            ),
          ),
        ],
      ),
      accountEmail: Text(
        textDirection: TextDirection.ltr,
        phoneNumber,
        style: TextStyle(
          fontSize: AppSize.mediumFont,
          fontFamily: AppFont.primaryFont,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          username != 'زائر' ? Icons.person : Icons.person_outline,
          size: AppSize.iconExtraLarge,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildThemeSwitch() {
    return Obx(() {
      final currentTheme = _themeController.themeMode;
      IconData icon;
      String label;

      switch (currentTheme) {
        case ThemeMode.light:
          icon = Icons.light_mode;
          label = 'الوضع الفاتح';
          break;
        case ThemeMode.dark:
          icon = Icons.dark_mode;
          label = 'الوضع الداكن';
          break;
        case ThemeMode.system:
          icon = Icons.brightness_auto;
          label = 'تلقائي';
      }

      return _buildMenuItem(
        icon: icon,
        title: label,
        onTap: _themeController.toggleTheme,
      );
    });
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: AppSize.iconMedium,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSize.mediumFont,
          fontWeight: AppFont.wmedium,
          fontFamily: AppFont.primaryFont,
        ),
      ),
      hoverColor: AppColors.primarySwatch,
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppSize.isMediumDevice ? Get.width * 0.65 : Get.width * 0.75,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildUserHeader(),

                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'الإعدادات',
                  onTap: () => Get.toNamed(AppRoutes.settings),
                ),
                // const Divider(),
                _buildThemeSwitch(),
                const Divider(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSize.spacingMedium),
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout, size: AppSize.iconMedium),
              label: Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: AppSize.mediumFont),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, AppSize.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.spacingMedium,
                  vertical: AppSize.spacingSmall,
                ),
              ),
              onPressed:
                  () async => await Get.dialog(
                    GetBuilder<AuthController>(
                      builder:
                          (controller) => AlertDialog(
                            title: Text(
                              'تأكيد الخروج',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: AppSize.mediumFont,
                              ),
                            ),
                            icon: Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: AppSize.iconMedium,
                            ),
                            content: Text(
                              'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                              style: TextStyle(fontSize: AppSize.subtitleFont),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    fontSize: AppSize.subtitleFont,
                                  ),
                                ),
                                onPressed: () => Get.back(result: false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.spacingMedium,
                                    vertical: AppSize.spacingSmall,
                                  ),
                                ),
                                child: Text(
                                  'تأكيد الخروج',
                                  style: TextStyle(
                                    fontSize: AppSize.subtitleFont,
                                  ),
                                ),
                                onPressed: () => controller.logout(),
                              ),
                            ],
                          ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
