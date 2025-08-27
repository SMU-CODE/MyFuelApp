import 'package:flutter/material.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class DetailsGrid extends StatelessWidget {
  final DailyInfoStationsForUserModel station;

  const DetailsGrid({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSize.isSmallDevice ? 1 : 2,
        childAspectRatio: AppSize.isSmallDevice ? 4.5 : 5.5,
        crossAxisSpacing: AppSize.spacingSmall,
        mainAxisSpacing: AppSize.spacingSmall,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _DetailItem(
              Icons.location_on_outlined,
              "الموقع",
              station.station!.location,
            );
          case 1:
            return _DetailItem(
              Icons.access_time_rounded,
              "آخر تحديث",
              Parser.formatDateTime(station.dailyInfo!.updatedAt),
            );
          case 2:
            return _DetailItem(
              Icons.calendar_today_outlined,
              "تاريخ المعلومات",
              Parser.formatDateTime(station.dailyInfo!.date),
            );
          case 3:
            return _DetailItem(
              Icons.local_gas_station_outlined,
              "الكمية المتبقية",
              "${(station.dailyInfo!.remainingAmount)} لتر",
            );
          case 4:
            return _DetailItem(
              Icons.gas_meter_outlined,
              "نوع الوقود",
              station.dailyInfo!.fuelType,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSize.iconMedium, color: AppColors.primary),
        SizedBox(width: AppSize.spacingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
