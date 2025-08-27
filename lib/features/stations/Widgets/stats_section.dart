import 'package:flutter/material.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class StatsSection extends StatelessWidget {
  final DailyInfoStationsForUserModel station;

  const StatsSection({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.paddingMedium,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: AppSize.borderRadiusMedium,
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: AppSize.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            "إجمالي الحجوزات",
            station.bookings!.total,
            AppColors.primary,
            Icons.bar_chart_rounded,
          ),
          _StatItem(
            "متاحة",
            station.dailyInfo!.maxBookings - (station.bookings?.count ?? 0),
            AppColors.primary,
            Icons.event_available_rounded,
          ),
          _StatItem(
            "معلقة",
            station.bookings!.statusCounts!.pending,
            AppColors.warning,
            Icons.access_time_filled_rounded,
          ),
          _StatItem(
            "مؤكدة",
            station.bookings!.statusCounts!.confirmed,
            AppColors.success,
            Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  const _StatItem(this.title, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSize.iconLarge * 1.2,
          height: AppSize.iconLarge * 1.2,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Icon(icon, size: AppSize.iconMedium, color: color),
        ),
        SizedBox(height: AppSize.verticalSpacing / 1.5),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: AppSize.largeFont,
          ),
        ),
      ],
    );
  }
}
