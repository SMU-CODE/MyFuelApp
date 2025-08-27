import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNamedRouteError = error.contains("Could not find a route named");

    return Scaffold(
      appBar: AppBar(title: const Text('حدث خطأ')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                isNamedRouteError
                    ? 'الصفحة المطلوبة غير موجودة '
                    : 'حدث خطأ أثناء التنقل:',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                icon: const Icon(Icons.home),
                label: Text(
                  'العودة للصفحة الرئيسية',
                  style: TextStyle(fontSize: AppSize.titleFont),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
