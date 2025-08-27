import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Settings/SettingsController.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize or find your SettingsController
    // Get.put() is good for screens where the controller's lifecycle matches the screen's.
    final SettingsController controller = Get.put(SettingsController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          // Colors are now inherited from AppTheme, no hardcoding
        ),
        body: Container(
          // Use theme colors for background gradient
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface, // Use background color
                Theme.of(context).colorScheme.surface, // Use surface color
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'التفضيلات العامة'),
              // --- Notifications Switch ---
              Obx(
                () => _buildSwitchSetting(
                  context: context,
                  icon: Icons.notifications,
                  title: 'الإشعارات',
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
              // --- Dark Mode Switch ---
              Obx(
                () => _buildSwitchSetting(
                  context: context,
                  icon: Icons.dark_mode,
                  title: 'الوضع الليلي',
                  value:
                      controller
                          .isDarkModeEnabled, // From ThemeController via SettingsController
                  onChanged: controller.toggleDarkMode,
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionHeader(context, 'حول التطبيق'),
              // --- Privacy Policy ---
              _buildActionSetting(
                context: context,
                icon: Icons.privacy_tip,
                title: 'سياسة الخصوصية',
                onTap: controller.launchPrivacyPolicy,
              ),
              // --- Contact Us ---
              _buildActionSetting(
                context: context,
                icon: Icons.contact_support,
                title: 'اتصل بنا',
                onTap: controller.launchContactUs,
              ),
              // --- App Version ---
              _buildActionSetting(
                context: context,
                icon: Icons.info,
                title: 'إصدار التطبيق',
                subtitle:
                    controller.getAppVersion(), // Get version from controller
                onTap: () {
                  // Optionally show an about dialog or more details
                  Get.dialog(
                    AlertDialog(
                      title: Text(
                        'إصدار التطبيق',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      content: Text(
                        'النسخة الحالية: ${controller.getAppVersion()}\n\nتم التطوير بواسطة فريق MyFuel',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('إغلاق'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildAppInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (moved to be methods of the StatelessWidget) ---
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .7),
        ),
      ),
    );
  }

  // Original parameters are good
  Widget _buildSwitchSetting({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: Theme.of(context).cardTheme.elevation,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: Theme.of(context).cardTheme.shape,
      color: Theme.of(context).colorScheme.surface, // Use surface color
      child: ListTile(
        // Changed from SwitchListTile to ListTile
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ), // Icon as leading
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ), // Title text
        trailing: Switch(
          // The switch goes in the trailing property
          value: value,
          onChanged: onChanged,
          activeThumbColor:
              Theme.of(
                context,
              ).colorScheme.primary, // Themed active switch color
        ),
        onTap:
            () => onChanged(!value), // Make the whole tile tappable to toggle
      ),
    );
  }

  Widget _buildDropdownSetting({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      elevation: Theme.of(context).cardTheme.elevation,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: Theme.of(context).cardTheme.shape,
      color: Theme.of(context).colorScheme.surface, // Use surface color
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ), // Adjust padding for dropdown
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
            ), // Use themed icon color
            const SizedBox(width: 16), // Adjusted spacing
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ), // Display title clearly
            ),
            Expanded(
              flex: 2, // Give more space to dropdown
              child: DropdownButtonHideUnderline(
                // Hide default underline
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  items:
                      items.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium, // Themed text style
                          ),
                        );
                      }).toList(),
                  onChanged: onChanged,
                  dropdownColor:
                      Theme.of(
                        context,
                      ).colorScheme.surface, // Themed dropdown background
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyMedium, // Themed dropdown item text style
                  iconEnabledColor:
                      Theme.of(
                        context,
                      ).colorScheme.primary, // Themed dropdown arrow color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSetting({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: Theme.of(context).cardTheme.elevation,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: Theme.of(context).cardTheme.shape,
      color: Theme.of(context).colorScheme.surface, // Use surface color
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ), // Use themed icon color
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ), // Use themed text style
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
                : null,
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Column(
      children: [
        // Consider dynamic asset loading for logo based on theme
        // Image.asset(
        //   Theme.of(context).brightness == Brightness.light
        //       ? 'assets/logo_light.png'
        //       : 'assets/logo_dark.png',
        //   width: 80,
        //   height: 80,
        // ),
        const SizedBox(height: 10),
        Text(
          'تطبيق وقودي',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          '© 2025 جميع الحقوق محفوظة',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
