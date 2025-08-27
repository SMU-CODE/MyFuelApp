import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/notifications/NotificationModel.dart';
import 'package:my_fuel/shared/notifications/NotificationService.dart'; // تأكد من المسار الصحيح لـ 
// متحكم الإشعارات باستخدام GetX - مدمج بكل الميزات
class NotificationController extends GetxController {
  // للوصول السهل إلى المتحكم من أي مكان
  static NotificationController get to => Get.find();

  // الحصول على NotificationService الذي تم تهيئته مسبقًا
  final NotificationService _notificationService = Get.find<NotificationService>();

  // قائمة الإشعارات التي ستعرض في واجهة المستخدم
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  // قائمة الفلاتر النشطة لتصفية الإشعارات
  final RxList<NotificationType> activeFilters = <NotificationType>[].obs;

  // getter للحصول على قائمة الإشعارات المفلترة
  List<NotificationModel> get filteredNotifications {
    if (activeFilters.isEmpty) return notifications;
    return notifications.where((n) => activeFilters.contains(n.type)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // تهيئة NotificationService عند بدء تشغيل المتحكم
    _notificationService.initialize();
    // تحميل الإشعارات الأولية
    loadNotifications();
    // تفعيل جميع أنواع الإشعارات افتراضياً عند البدء
    activeFilters.addAll(NotificationType.values);
  }

  // --- دوال التفاعل مع NotificationService (الإشعارات المحلية) ---

  // تهيئة خدمة الإشعارات المحلية (يمكن استدعاؤها مرة أخرى إذا لزم الأمر)
  Future<void> initializeLocalNotifications() async {
    await _notificationService.initialize();
  }

  // عرض إشعار فوري
  Future<void> showInstantNotification({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    await _notificationService.showSimpleNotification(
      title: title,
      body: body,
      id: id,
      payload: payload,
    );
  }

  // جدولة إشعار لوقت محدد في المستقبل
  Future<void> scheduleSingleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    int id = 0,
    String? payload,
  }) async {
    await _notificationService.showScheduledNotification(
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      id: id,
      payload: payload,
    );
  }

  // إلغاء إشعار محدد بواسطة المعرف الخاص به
  Future<void> cancelSpecificNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }

  // إلغاء جميع الإشعارات المجدولة (من نظام التشغيل)
  Future<void> clearAllScheduledNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  // --- دوال إدارة قائمة الإشعارات (لواجهة المستخدم) ---

  // تحميل الإشعارات (هنا مثال ببيانات وهمية، يمكن استبدالها بجلب من API/قاعدة بيانات)
  void loadNotifications() {
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'رسالة جديدة',
        message: 'لديك رسالة جديدة من المستخدم أحمد',
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.message,
      ),
      NotificationModel(
        id: '2',
        title: 'تنبيه مهم',
        message: 'حاول محمد الدخول إلى حسابك',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.alert,
      ),
      NotificationModel(
        id: '3',
        title: 'حدث جديد',
        message: 'لديك اجتماع غداً الساعة 10 صباحاً',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.event,
      ),
      NotificationModel(
        id: '4',
        title: 'تحديث النظام',
        message: 'نسخة جديدة من التطبيق متاحة الآن',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.system,
        hasAction: true,
      ),
    ]);
  }

  // تحديد إشعار كمقروء
  void markAsRead(NotificationModel notification) {
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      notifications[index].read = true;
      notifications.refresh(); // لتحديث واجهة المستخدم
    }
  }

  // إزالة إشعار من القائمة المعروضة في واجهة المستخدم
  void removeNotification(int index) {
    notifications.removeAt(index);
    Get.snackbar(
      'تم الحذف',
      'تم حذف الإشعار بنجاح',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // مسح جميع الإشعارات من القائمة المعروضة في واجهة المستخدم
  void clearAllNotifications() {
    notifications.clear();
    Get.snackbar(
      'تم الحذف',
      'تم حذف جميع الإشعارات من القائمة',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // تبديل حالة الفلتر لنوع إشعار معين
  void toggleFilter(NotificationType type) {
    if (activeFilters.contains(type)) {
      activeFilters.remove(type);
    } else {
      activeFilters.add(type);
    }
  }

  // --- دوال مساعدة للحصول على الرموز والألوان والأسماء لأنواع الإشعارات ---
  // تم وضعها هنا لتجنب تكرارها في الشاشات الأخرى

  static IconData getNotificationIcon(NotificationType type) {
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

  static Color getNotificationColor(NotificationType type) {
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

  static String getNotificationTypeName(NotificationType type) {
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
}
