import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_fuel/shared/notifications/NotificationController.dart';
import 'package:my_fuel/shared/notifications/NotificationModel.dart';

// شاشة عرض الإشعارات الرئيسية
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.alert:
        return Icons.warning;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.system:
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.alert:
        return Colors.orange;
      case NotificationType.event:
        return Colors.green;
      case NotificationType.system:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getNotificationTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return 'رسائل';
      case NotificationType.alert:
        return 'تنبيهات';
      case NotificationType.event:
        return 'أحداث';
      case NotificationType.system:
        return 'نظام';
      default:
        return 'أخرى';
    }
  }

  void _openNotificationDetails(NotificationModel notification) {
    NotificationController.to.markAsRead(notification);
    Get.to(() => NotificationDetailsPage(notification: notification));
  }

  void _markAsRead(NotificationModel notification) {
    NotificationController.to.markAsRead(notification);
    Get.snackbar(
      'تم التحديث',
      'تم تحديد الإشعار كمقروء',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showFilterOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تصفية الإشعارات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Obx(
              () => Column(
                children:
                    NotificationType.values.map((type) {
                      return CheckboxListTile(
                        title: Text(_getNotificationTypeName(type)),
                        value: NotificationController.to.activeFilters.contains(
                          type,
                        ),
                        onChanged:
                            (value) =>
                                NotificationController.to.toggleFilter(type),
                      );
                    }).toList(),
              ),
            ),
            ElevatedButton(onPressed: Get.back, child: const Text('تم')),
          ],
        ),
      ),
    );
  }

  void _clearAllNotifications() {
    Get.defaultDialog(
      title: 'حذف الكل',
      middleText: 'هل أنت متأكد من حذف جميع الإشعارات؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () {
        NotificationController.to.clearAllNotifications();
        Get.back();
        Get.snackbar(
          'تم الحذف',
          'تم حذف جميع الإشعارات',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // يجب تهيئة NotificationController قبل استخدامه
    Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(),
            tooltip: 'تصفية الإشعارات',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _clearAllNotifications(),
            tooltip: 'حذف الكل',
          ),
        ],
      ),
      body: Obx(
        () =>
            NotificationController.to.notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount:
                      NotificationController.to.filteredNotifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification =
                        NotificationController.to.filteredNotifications[index];
                    return _buildNotificationItem(notification, index);
                  },
                ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: Get.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => NotificationController.to.loadNotifications(),
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, int index) {
    return Dismissible(
      key: Key('notification_${notification.id}'), // استخدام معرف فريد للإشعار
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => NotificationController.to.removeNotification(index),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              DateFormat('yyyy/MM/dd - hh:mm a').format(notification.date),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing:
            notification.read
                ? null
                : const CircleAvatar(radius: 5, backgroundColor: Colors.red),
        onTap: () => _openNotificationDetails(notification),
        onLongPress: () => _markAsRead(notification),
      ),
    );
  }
}

// صفحة تفاصيل الإشعار
class NotificationDetailsPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsPage({super.key, required this.notification});

  // يجب تكرار هذه الدوال أو جعلها متاحة بشكل عام إذا لم تكن في نفس الملف
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.alert:
        return Icons.warning;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.system:
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.alert:
        return Colors.orange;
      case NotificationType.event:
        return Colors.green;
      case NotificationType.system:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getNotificationTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return 'رسائل';
      case NotificationType.alert:
        return 'تنبيهات';
      case NotificationType.event:
        return 'أحداث';
      case NotificationType.system:
        return 'نظام';
      default:
        return 'أخرى';
    }
  }

  void _handleAction(NotificationModel notification) {
    Get.back();
    Get.snackbar(
      'تم التنفيذ',
      'تم تنفيذ الإجراء المطلوب',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الإشعار')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getNotificationColor(notification.type),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _getNotificationTypeName(notification.type),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              notification.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(notification.message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Text(
              'التاريخ: ${DateFormat('yyyy/MM/dd - hh:mm a').format(notification.date)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            if (notification.hasAction)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleAction(notification),
                  child: const Text('تنفيذ الإجراء'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
