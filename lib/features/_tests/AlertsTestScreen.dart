import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AlertsTestScreen extends StatelessWidget {
  const AlertsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار التنبيهات والأوامر'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Dialog Methods ---
              const Center(
                child: Text(
                  'النوافذ المنبثقة (Dialogs)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () async {
                  bool? result = await MuAlerts.showConfirmDialog(
                    title: 'تأكيد الإجراء',
                    contentText: 'هل أنت متأكد من المتابعة بهذا الإجراء؟',
                    confirmText: 'تأكيد',
                    cancelText: 'إلغاء',
                    confirmColor: AppColors.primary,
                  );
                  if (result == true) {
                    MuAlerts.showSuccess('تم تأكيد الإجراء!');
                  } else {
                    MuAlerts.showInfo('تم إلغاء الإجراء.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار حوار التأكيد (Confirm Dialog)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showInfoDialog(
                    title: 'معلومة هامة',
                    content: 'هذه رسالة معلوماتية تهدف لتوضيح نقطة معينة.',
                    icon: Icons.info_outline,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار حوار المعلومات (Info Dialog)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () async {
                  String? inputText = await MuAlerts.showInputDialog(
                    title: 'إدخال نص',
                    hintText: 'اكتب شيئًا هنا...',
                    confirmText: 'إرسال',
                    cancelText: 'تراجع',
                  );
                  if (inputText != null && inputText.isNotEmpty) {
                    MuAlerts.showSuccess('تم إدخال: "$inputText"');
                  } else if (inputText != null) {
                    MuAlerts.showWarning('لم يتم إدخال أي نص.');
                  } else {
                    MuAlerts.showError('تم إلغاء الإدخال.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار حوار الإدخال (Input Dialog)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showCustomDialog(
                    content: Padding(
                      padding: EdgeInsets.all(AppSize.spacingMedium),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: AppSize.iconLarge,
                            color: AppColors.warning,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          Text(
                            'هذه نافذة منبثقة مخصصة!',
                            style: TextStyle(
                              fontSize: AppSize.largeFont,
                              fontWeight: AppFont.wbold,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          Text(
                            'يمكنك وضع أي محتوى تريده هنا.',
                            style: TextStyle(
                              fontSize: AppSize.mediumFont,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                            ),
                            child: const Text('إغلاق'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onTertiary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار حوار مخصص (Custom Dialog)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () async {
                  bool? confirm = await MuAlerts.confirmDelete('تقرير يونيو');
                  if (confirm == true) {
                    MuAlerts.showSuccess('تم حذف تقرير يونيو.');
                  } else {
                    MuAlerts.showInfo('تم إلغاء عملية الحذف.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'تأكيد الحذف (confirmDelete)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),

              SizedBox(height: AppSize.spacingMedium * 2),
              const Divider(),
              SizedBox(height: AppSize.spacingMedium * 2),

              // --- Loading Widgets & Methods ---
              const Center(
                child: Text(
                  'مؤشرات التحميل (Loading Indicators)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showLoading(
                    message: 'جاري التحميل، الرجاء الانتظار...',
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    MuAlerts.hideLoading();
                    MuAlerts.showInfo('تم الانتهاء من التحميل الوهمي.');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  foregroundColor: AppColors.onTertiary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار مؤشر التحميل (showLoading)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              Center(child: MuAlerts.circularLoading()),

              SizedBox(height: AppSize.spacingMedium * 2),
              const Divider(),
              SizedBox(height: AppSize.spacingMedium * 2),

              // --- Snackbar Methods ---
              const Center(
                child: Text(
                  'رسائل الإشعارات (Snackbar)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showSnackBar(
                    title: 'إشعار مخصص',
                    message: 'هذه رسالة إشعار عامة ومخصصة.',
                    backgroundColor: AppColors.backgroundInverse,
                    icon: Icons.notifications_active,
                    duration: const Duration(seconds: 4),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.outline,
                  foregroundColor: AppColors.onSurface,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار إشعار مخصص (showSnackBar)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showSuccess('تم حفظ البيانات بنجاح!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار إشعار النجاح (showSuccess)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showError(
                    'حدث خطأ أثناء معالجة طلبك.',
                    details: 'الخادم لا يستجيب في الوقت الحالي.',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار إشعار الخطأ (showError)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showWarning(
                    'بياناتك تحتاج إلى مراجعة قبل المتابعة.',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار إشعار التحذير (showWarning)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showInfo('هذه معلومة مفيدة لمساعدتك.');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار إشعار معلومة (showInfo)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),

              SizedBox(height: AppSize.spacingMedium * 2),
              const Divider(),
              SizedBox(height: AppSize.spacingMedium * 2),

              // --- Bottom Sheet Methods ---
              const Center(
                child: Text(
                  'الأوراق السفلية (Bottom Sheets)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing),
              ElevatedButton(
                onPressed: () {
                  MuAlerts.showCustomBottomSheet(
                    content: Container(
                      padding: EdgeInsets.all(AppSize.spacingMedium),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu,
                            size: AppSize.iconLarge,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          Text(
                            'هذه ورقة سفلية مخصصة!',
                            style: TextStyle(
                              fontSize: AppSize.largeFont,
                              fontWeight: AppFont.wbold,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          Text(
                            'يمكنك وضع أي أدوات واجهة مستخدم هنا.',
                            style: TextStyle(
                              fontSize: AppSize.mediumFont,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.verticalSpacing),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                            ),
                            child: const Text('إغلاق الورقة'),
                          ),
                        ],
                      ),
                    ),
                    isScrollControlled:
                        false, // Set to true if content can be large
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: EdgeInsets.all(AppSize.spacingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                  ),
                ),
                child: Text(
                  'إظهار ورقة سفلية مخصصة (Custom Bottom Sheet)',
                  style: TextStyle(fontSize: AppSize.mediumFont),
                ),
              ),
              SizedBox(height: AppSize.verticalSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
