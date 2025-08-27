import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Reports/Views/booking_report_screen.dart';
import 'package:my_fuel/features/home/widgets/CardsWidget.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/features/stations/Views/DailyInfoStationManegerScreen.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),

        Text("شاشة الإختبار", style: AppTextStyles.bodyLarge),
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
                icon: Icons.local_gas_station,
                title: 'اختبار 1',
                onTap: () {
                  Get.to(() => BookingReportScreen());
                },
              ),
              HomeCards(
                icon: Icons.local_gas_station,
                title: 'اختبار 2',
                onTap: () {
                  Get.to(() => DailyInfoStationManegerScreen());
                },
              ),
              HomeCards(
                icon: Icons.telegram_sharp,
                title: 'اختبار 3',
                onTap: () {
                  AppRoutes.goTo(
                    AppRoutes.qrDisplay,
                    arguments: {'plateNumber': "452755", 'qrCode': "QR50"},
                  );
                },
              ),
              HomeCards(
                icon: Icons.swap_vertical_circle,
                title: 'اختبار 4',
                onTap: () {
                  AppRoutes.goTo(AppRoutes.vehicleLinking);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
