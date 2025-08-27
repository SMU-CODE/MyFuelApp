import 'package:flutter/material.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';

class MyAlertsTestScreen extends StatelessWidget {
  const MyAlertsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختبار التنبيهات'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          // استخدام SingleChildScrollView للسماح بالتمرير إذا زادت الأزرار
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // لجعل الأزرار تمتد على عرض الشاشة
            children: [
              _buildTestButton(
                'تنبيه ناجح (MyAlerts)',
                Icons.check_circle,
                Colors.green,
                () =>
                    MuAlerts.showSuccess('هذه رسالة نجاح تجريبية من MyAlerts'),
              ),
              _buildTestButton(
                'تنبيه خطأ (MyAlerts)',
                Icons.error,
                Colors.red,
                () => MuAlerts.showError(
                  'هذه رسالة خطأ تجريبية من MyAlerts',
                  details: 'تفاصيل إضافية للخطأ هنا.',
                ),
              ),
              _buildTestButton(
                'تنبيه تحذير (MyAlerts)',
                Icons.warning,
                Colors.orange,
                () =>
                    MuAlerts.showWarning('هذه رسالة تحذير تجريبية من MyAlerts'),
              ),
              _buildTestButton(
                'تنبيه معلومة (MyAlerts)',
                Icons.info,
                Colors.blue,
                () =>
                    MuAlerts.showInfo('هذه رسالة معلومات تجريبية من MyAlerts'),
              ),
              // --- اختبار حوارات التأكيد ---
              _buildTestButton(
                'حوار تأكيد بسيط (GetX)',
                Icons.access_alarm_outlined,
                Colors.deepPurple,
                () async {
                  // The function must be async to use await
                  bool? confirmed = await MuAlerts.showConfirmDialog(
                    title: 'سؤال تأكيد',
                    contentText: 'هل أنت متأكد من المتابعة في هذا الإجراء؟',
                    confirmText: 'نعم، تابع',
                    cancelText: 'لا، تراجع',
                    confirmColor: Colors.deepPurple,
                    // REMOVE the 'onResult' parameter completely from here
                  );

                  // Now, 'confirmed' will directly hold true or false (or null if dismissed)
                  // Check if a result was actually returned
                  MuAlerts.showInfo(
                    'تم الرد على التأكيد: ${confirmed ? "نعم" : "لا"}',
                  );
                },
              ),
              _buildTestButton(
                'حوار معلومات حديث',
                Icons.lightbulb,
                Colors.teal,
                () => MuAlerts.showInfoDialog(
                  title: 'معلومة هامة',
                  content: 'هذا حوار معلومات بتصميم حديث مع أيقونة.',
                  icon: Icons.info_outline,
                  iconColor: Colors.teal,
                ),
              ),
              _buildTestButton(
                'حوار تأكيد حديث (محتوى Widget)',
                Icons.gavel,
                Colors.brown,
                () async {
                  bool? result = await MuAlerts.showConfirmDialog(
                    title: 'تأكيد خاص',
                    contentWidget: Text(
                      'هذا محتوى بسيط جداً للاختبار.',
                    ), // هنا التغيير
                    confirmText: 'موافق',
                    cancelText: 'إلغاء',
                    confirmColor: Colors.brown,
                  );
                  MuAlerts.showInfo(
                    'تم الرد على التأكيد الخاص: ${result ? "موافق" : "إلغاء"}',
                  );
                },
              ),
              _buildTestButton(
                'تأكيد حذف (نموذج جاهز)',
                Icons.delete_forever,
                Colors.redAccent,
                () async {
                  bool? result = await MuAlerts.confirmDelete('تقرير شهري');
                  MuAlerts.showInfo(
                    'حذف تقرير شهري: ${result ? "تم الحذف" : "إلغاء الحذف"}',
                  );
                },
              ),
              // --- اختبار مؤشر التحميل ---
              _buildTestButton(
                'عرض مؤشر التحميل',
                Icons.hourglass_empty,
                Colors.purple,
                () {
                  MuAlerts.showLoading();
                  Future.delayed(const Duration(seconds: 3), () {
                    MuAlerts.hideLoading();
                    MuAlerts.showInfo('تم إخفاء التحميل بعد 3 ثوانٍ.');
                  });
                },
              ),
              _buildTestButton(
                'إخفاء مؤشر التحميل',
                Icons.hourglass_full,
                Colors.purple.shade900,
                () => MuAlerts.hideLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // مسافة أقل بين الأزرار
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ), // حجم خط أصغر
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50), // ارتفاع ثابت
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  /* 
  // هذه الدالة كانت تستخدم BuildContext صريحًا، الآن نستخدم GetX methods في MyAlerts
  // لذا قد لا تكون هذه الدالة نفسها ضرورية إذا كنت تستخدم MuAlerts.showConfirmDialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    // هذا مجرد مثال على كيفية استخدام showConfirmDialog من MyAlerts
    // بدلاً من showDialog المباشر.
    bool? confirmed = await MuAlerts.showConfirmDialog(
      title: 'تأكيد الإجراء',
      contentText: 'هل أنت متأكد من تنفيذ هذا الإجراء؟',
      confirmText: 'تأكيد',
      cancelText: 'إلغاء',
      confirmColor: Colors.orange,
    );

    if (confirmed ) {
      MuAlerts.showSuccess('تم التأكيد بنجاح');
    } else {
      MuAlerts.showInfo('تم إلغاء الإجراء.');
    }
  }
 */
}
