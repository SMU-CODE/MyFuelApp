import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/notifications/NotificationController.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationManagerScreen extends StatelessWidget {
  NotificationManagerScreen({super.key});

  final NotificationController _notificationController = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final Rx<DateTime> _selectedDate = Rx<DateTime>(
    DateTime.now().add(const Duration(seconds: 10)),
  );
  final RxBool _hasNotificationPermission = false.obs;

  @override
  Widget build(BuildContext context) {
    _checkAndRequestPermissions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدير الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: openAppSettings,
            tooltip: 'فتح إعدادات التطبيق',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPermissionCard(),
            const SizedBox(height: 16),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildBodyField(),
            const SizedBox(height: 16),
            _buildScheduleCard(),
            const SizedBox(height: 16),
            _buildCancelAllButton(),
            TextButton(
            
              onPressed: () => {
                         
              AppRoutes.goTo(AppRoutes.notificationsTest)},
              child: Text("اختبر الان "),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard() {
    return Obx(
      () => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                _hasNotificationPermission.value
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color:
                    _hasNotificationPermission.value
                        ? Colors.green
                        : Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _hasNotificationPermission.value
                      ? 'الإشعارات مفعلة'
                      : 'الإشعارات معطلة',
                  style: Get.textTheme.bodyLarge,
                ),
              ),
              FilledButton.tonal(
                onPressed: _checkAndRequestPermissions,
                child: const Text('التحقق من الأذونات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'عنوان الإشعار',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBodyField() {
    return TextField(
      controller: _bodyController,
      decoration: const InputDecoration(
        labelText: 'نص الإشعار',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'مجدول لـ: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate.value)}',
                      style: Get.textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                    tooltip: 'تحديد التاريخ',
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectTime,
                    tooltip: 'تحديد الوقت',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () => _showNotification(false),
                  child: const Text('عرض الآن'),
                ),
                FilledButton(
                  onPressed: () => _showNotification(true),
                  child: const Text('جدولة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelAllButton() {
    return FilledButton(
      onPressed: _cancelAllNotifications,
      style: FilledButton.styleFrom(
        backgroundColor: Get.theme.colorScheme.error,
      ),
      child: const Text('إلغاء جميع الإشعارات'),
    );
  }

  Future<void> _checkAndRequestPermissions() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final newStatus = await Permission.notification.request();
      _hasNotificationPermission.value = newStatus.isGranted;

      if (!newStatus.isGranted) {
        Get.snackbar(
          'الإذن مطلوب',
          'أذونات الإشعارات مطلوبة لهذه الميزة',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      _hasNotificationPermission.value = true;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: _selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _selectedDate.value = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDate.value.hour,
        _selectedDate.value.minute,
      );
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(_selectedDate.value),
    );
    if (picked != null) {
      _selectedDate.value = DateTime(
        _selectedDate.value.year,
        _selectedDate.value.month,
        _selectedDate.value.day,
        picked.hour,
        picked.minute,
      );
    }
  }

  Future<void> _showNotification(bool scheduled) async {
    if (!_hasNotificationPermission.value) {
      await _checkAndRequestPermissions();
      return;
    }

    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      Get.snackbar(
        'الإدخال مطلوب',
        'الرجاء إدخال كل من العنوان والنص للإشعار.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
      );
      return;
    }

    try {
      if (scheduled) {
        await _notificationController.scheduleSingleNotification(
          title: _titleController.text,
          body: _bodyController.text,
          scheduledTime: _selectedDate.value,
        );
      } else {
        await _notificationController.showInstantNotification(
          title: _titleController.text,
          body: _bodyController.text,
        );
      }

      Get.snackbar(
        'نجاح',
        scheduled
            ? 'تم جدولة الإشعار لـ ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate.value)}'
            : 'تم عرض الإشعار بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في ${scheduled ? 'جدولة' : 'عرض'} الإشعار: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _cancelAllNotifications() async {
    _notificationController.clearAllNotifications();
    Get.snackbar(
      'نجاح',
      'تم إلغاء جميع الإشعارات',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
