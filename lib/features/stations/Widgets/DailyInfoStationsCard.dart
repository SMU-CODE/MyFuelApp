import 'package:flutter/material.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoStationsForUserModel.dart';
import 'package:my_fuel/features/booking/Controllers/MakeBookingController.dart';
import 'package:my_fuel/features/booking/Views/MakeBookingDialog.dart';
import 'package:my_fuel/features/stations/Widgets/station_details_section.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:get/get.dart';

class DailyInfoStationsCard extends StatefulWidget {
  final DailyInfoStationsForUserModel station;
  const DailyInfoStationsCard({super.key, required this.station});

  @override
  State<DailyInfoStationsCard> createState() => _DailyInfoStationsCardState();
}

class _DailyInfoStationsCardState extends State<DailyInfoStationsCard> {
  bool _isExpanded = false;
  bool get _isActive => widget.station.station!.isActive;

  void _handleBooking() {
    if (_isActive) {
      if (Get.isRegistered<MakeBookingController>()) {
        Get.delete<MakeBookingController>();
      }

      Get.put(
        MakeBookingController(
          stationId: widget.station.dailyInfo!.id,
          stationName: widget.station.station!.name,
        ),
      );

      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              insetPadding: AppSize.pagePadding,
              shape: RoundedRectangleBorder(
                borderRadius: AppSize.borderRadiusLarge,
              ),
              child: const MakeBookingDialogContent(),
            ),
      );
    } else {
      MuAlerts.showInfo("المحطة ليست نشطة حاليًا. لا يمكن الحجز.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppSize.paddingMedium,
      elevation: _isExpanded ? AppSize.elevationLarge : AppSize.elevationSmall,
      shape: RoundedRectangleBorder(borderRadius: AppSize.borderRadiusLarge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: AppSize.borderRadiusLarge,
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              _StationHeaderSection(
                station: widget.station,
                isActive: _isActive,
                onBookingPressed: _handleBooking,
              ),
              if (_isExpanded) StationDetailsSection(station: widget.station),
              _FooterIndicator(isExpanded: _isExpanded),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationHeaderSection extends StatelessWidget {
  final DailyInfoStationsForUserModel station;
  final bool isActive;
  final VoidCallback onBookingPressed;

  const _StationHeaderSection({
    required this.station,
    required this.isActive,
    required this.onBookingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive ? AppColors.success : AppColors.error;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSize.paddingMedium,
      child: Column(
        children: [
          Text(
            station.station!.name,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSize.spacingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppSize.avatarMedium,
                height: AppSize.avatarMedium,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: AppSize.elevationLarge,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_gas_station_rounded,
                  size: AppSize.iconMedium,
                  color: AppColors.onPrimary,
                ),
              ),
              SizedBox(width: AppSize.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSize.verticalSpacing / 2),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.spacingSmall,
                            vertical: AppSize.verticalSpacing / 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: AppSize.borderRadiusSmall,
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive
                                    ? Icons.check_circle_rounded
                                    : Icons.error_outline_rounded,
                                size: AppSize.iconSmall,
                                color: statusColor,
                              ),
                              SizedBox(width: AppSize.spacingExtraSmall),
                              Text(
                                isActive ? "نشط" : "غير نشط",
                                style: textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSize.spacingSmall),
                        if (station.dailyInfo!.notes != null &&
                            station.dailyInfo!.notes!.isNotEmpty)
                          Icon(
                            Icons.info_outline_rounded,
                            size: AppSize.iconSmall,
                            color: AppColors.info,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSize.spacingMedium),
              _BookingButton(isActive: isActive, onPressed: onBookingPressed),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const _BookingButton({required this.isActive, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.3),
        foregroundColor:
            isActive
                ? AppColors.onPrimary
                : AppColors.onSurface.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: AppSize.borderRadiusLarge),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.spacingMedium,
          vertical: AppSize.spacingSmall,
        ),
        elevation: isActive ? AppSize.elevationLarge : AppSize.elevationNone,
        shadowColor:
            isActive
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_outlined, size: AppSize.iconSmall),
          SizedBox(width: AppSize.verticalSpacing / 2),
          Text(
            "احجز",
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FooterIndicator extends StatelessWidget {
  final bool isExpanded;

  const _FooterIndicator({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.verticalSpacing / 2),
      color: AppColors.surface.withValues(alpha: 0.3),
      child: Center(
        child: Icon(
          isExpanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: AppSize.iconLarge,
          color: AppColors.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
