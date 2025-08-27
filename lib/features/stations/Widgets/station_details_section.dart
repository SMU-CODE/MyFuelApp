import 'package:flutter/material.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/features/stations/Widgets/details_grid.dart';
import 'package:my_fuel/features/stations/Widgets/stats_section.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class StationDetailsSection extends StatelessWidget {
  final DailyInfoStationsForUserModel station;

  const StationDetailsSection({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.paddingMedium.copyWith(top: 0),
      child: Column(
        children: [
          Divider(
            height: AppSize.spacingSmall,
            thickness: 0.8,
            color: AppColors.outline.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppSize.spacingMedium),
          DetailsGrid(station: station),
          SizedBox(height: AppSize.spacingMedium),
          StatsSection(station: station),
          SizedBox(height: AppSize.spacingMedium),
          if ((station.station!.imageUrl != null &&
                  station.station!.imageUrl!.isNotEmpty) ||
              (station.dailyInfo!.notes != null &&
                  station.dailyInfo!.notes!.isNotEmpty)) ...[
            SizedBox(height: AppSize.spacingMedium),
            Divider(
              height: AppSize.spacingSmall,
              thickness: 0.8,
              color: AppColors.outline.withValues(alpha: 0.3),
            ),
            SizedBox(height: AppSize.spacingMedium),
            _AdditionalInfo(station: station),
          ],
        ],
      ),
    );
  }
}

class _AdditionalInfo extends StatelessWidget {
  final DailyInfoStationsForUserModel station;

  const _AdditionalInfo({required this.station});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String? imageUrl = station.station!.imageUrl;
    final String? description = station.dailyInfo?.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "معلومات إضافية",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: AppSize.spacingSmall),
        if (imageUrl != null && imageUrl.isNotEmpty) ...[
          Container(
            height: AppSize.scaleHeight(150),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: AppSize.borderRadiusMedium,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.1),
                  blurRadius: AppSize.elevationLarge,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.spacingSmall),
        ],
        if (description != null && description.isNotEmpty)
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(height: 1.5),
            textAlign: TextAlign.justify,
          )
        else if ((imageUrl == null || imageUrl.isEmpty) &&
            (description == null || description.isEmpty))
          Text(
            "لا توجد معلومات إضافية متوفرة.",
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }
}
