import 'package:flutter/material.dart';
import 'package:my_fuel/features/home/widgets/CardsWidget.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class WorkerSection extends StatelessWidget {
  const WorkerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),

        Text("شاشة عامل المحطة", style: AppTextStyles.bodyLarge),
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
                icon: Icons.fact_check,
                title: 'إتمام التعبئة',
                onTap: () => AppRoutes.goTo(AppRoutes.vehicleRefuel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
