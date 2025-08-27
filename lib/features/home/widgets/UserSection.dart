import 'package:flutter/material.dart';
import 'package:my_fuel/features/home/widgets/CardsWidget.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class UserSection extends StatelessWidget {
  const UserSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),

        Text("شاشة المستخدم", style: AppTextStyles.bodyLarge),
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
                title: 'المحطات المتاحة',
                onTap: () => AppRoutes.goTo(AppRoutes.stationList),
              ),

              HomeCards(
                icon: Icons.swap_vertical_circle,
                title: 'المركبات المرتبطة',
                onTap: () => AppRoutes.goTo(AppRoutes.vehicleLinking),
              ),
              HomeCards(
                icon: Icons.history,
                title: 'سجل الحجوزات',
                onTap: () => AppRoutes.goTo(AppRoutes.bookingHistory),
              ),
              HomeCards(
                icon: Icons.settings,
                title: 'الإعدادات',
                onTap: () => AppRoutes.goTo(AppRoutes.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
