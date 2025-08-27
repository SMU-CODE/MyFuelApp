import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/home/widgets/CardsWidget.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class AdminSection extends StatelessWidget {
  const AdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Text("شاشة المسؤول ", style: AppTextStyles.bodyLarge),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              HomeCards(
                icon: Icons.analytics,
                title: 'يومية المحطة',
                onTap: () => AppRoutes.goTo(AppRoutes.stationDailyInfoManeger),
              ),
              HomeCards(
                icon: Icons.add_home_work_outlined,
                title: 'إدارة المحطات',
                onTap: () => AppRoutes.goTo(AppRoutes.stationsManeger),
              ),
              HomeCards(
                icon: Icons.add_business,
                title: 'إضافة محطة',
                onTap: () => AppRoutes.goTo(AppRoutes.stationAddOrUpdate),
              ),
              HomeCards(
                icon: Icons.add_box,
                title: 'إضافة شاحنة',
                onTap: () => AppRoutes.goTo(AppRoutes.vehicleNew),
              ),
              HomeCards(
                icon: Icons.qr_code_2,
                title: 'توليد QR',
                onTap: () {
                  Get.to(QRGeneratorPage(key: key));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QRGeneratorPage extends StatelessWidget {
  QRGeneratorPage({super.key});

  final TextEditingController qrCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "توليد رمز الاستجابة السريعة",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أدخل النص لتوليد QR Code",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qrCodeController,
                      decoration: InputDecoration(
                        hintText: 'يجب أن يبدأ النص بـ "QR"',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor:
                            isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        prefixIcon: Icon(
                          Icons.qr_code,
                          color: theme.primaryColor,
                        ),
                      ),
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: theme.primaryColor.withValues(alpha:0.3),
              ),
              onPressed: () {
                final text = qrCodeController.text.trim();
                if (text.isEmpty) {
                  Get.snackbar(
                    "حقل فارغ",
                    "الرجاء إدخال نص لتوليد QR Code",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade700,
                    colorText: Colors.white,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(16),
                  );
                } else if (!text.toUpperCase().startsWith("QR")) {
                  Get.snackbar(
                    "نص غير صالح",
                    "يجب أن يبدأ النص بـ 'QR'",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.shade700,
                    colorText: Colors.white,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(16),
                  );
                } else {
                  Get.toNamed(AppRoutes.qrDisplay, arguments: {'qrCode': text});
                  qrCodeController.clear();
                }
              },
              child: Text(
                'توليد الرمز',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "ملاحظة: سيتم توليد رمز QR فقط للنصوص التي تبدأ بـ 'QR'",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
