import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/booking/Controllers/MakeBookingController.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/customDropdown.dart';

class MakeBookingDialogContent extends StatelessWidget {
  const MakeBookingDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MakeBookingController>();
    final textTheme = Theme.of(context).textTheme;

    return Obx(
      () => Container(
        padding: AppSize.paddingLarge,
        constraints: BoxConstraints(maxWidth: AppSize.screenWidth * 0.8),
        decoration: BoxDecoration(
          borderRadius: AppSize.borderRadiusLarge,
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.1),
              blurRadius: AppSize.elevationLarge,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildDialogHeader(context, controller.stationName),
            const Divider(height: 24),

            // Time Period Selection
            _buildSectionTitle(context, "الفترة الزمنية"),
            SizedBox(height: AppSize.spacingSmall),
            _buildDropdown(
              items:
                  controller.periods
                      .cast<Map<String, dynamic>>(), // Explicitly cast here
              selectedId: Parser.parseString(controller.selectedPeriodId),
              onChanged:
                  (val) =>
                      controller.updateSelectedPeriod(Parser.parseInt(val)),
              loading: controller.periods.isEmpty && controller.isLoading,
              placeholder: 'اختر الفترة',
              icon: Icons.access_time_rounded,
            ),

            SizedBox(height: AppSize.spacingLarge),

            // Vehicle Selection
            _buildSectionTitle(context, "المركبات المرتبطة"),
            SizedBox(height: AppSize.spacingSmall),
            _buildDropdown(
              items:
                  controller.linkedVehicles
                      .cast<Map<String, dynamic>>(), // Explicitly cast here
              selectedId: Parser.parseString(controller.selectedVehicleId),
              onChanged: (val) {
                controller.updateSelectedVehicle(Parser.parseInt(val));
              },
              loading:
                  controller.linkedVehicles.isEmpty && controller.isLoading,
              placeholder: 'اختر المركبة',
              icon: Icons.directions_car_rounded,
            ),

            SizedBox(height: AppSize.spacingExtraLarge),

            // Confirmation Button
            _buildConfirmationButton(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context, String stationName) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          Icons.local_gas_station_rounded,
          size: AppSize.iconLarge,
          color: AppColors.primary,
        ),
        SizedBox(width: AppSize.spacingSmall),
        Expanded(
          child: Text(
            stationName,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildDropdown({
    // Changed List<dynamic> to List<Map<String, dynamic>>
    required List<Map<String, dynamic>> items,
    required String? selectedId,
    // Changed ValueChanged<String> to void Function(String?)
    required void Function(String?) onChanged,
    required bool loading,
    required String placeholder,
    required IconData icon,
  }) {
    if (loading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.verticalSpacing),
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return customDropdown(
      labelText: placeholder,
      items: items,
      selectedId: selectedId,
      onChanged: onChanged,
      icon: icon,
    );
  }

  Widget _buildConfirmationButton(
    BuildContext context,
    MakeBookingController controller,
  ) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: ElevatedButton.icon(
        onPressed:
            controller.isLoading
                ? null
                : () => controller.submitBooking(
                  selectedStationId: controller.stationId,
                ),
        icon:
            controller.isLoading
                ? SizedBox(
                  height: AppSize.iconMedium,
                  width: AppSize.iconMedium,
                  child: CircularProgressIndicator(
                    color: AppColors.onPrimary,
                    strokeWidth: 2,
                  ),
                )
                : Icon(Icons.check_circle_outline, size: AppSize.iconMedium),
        label: Text(
          "ارسال الحجز",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color:
                controller.isLoading
                    ? AppColors.onSurface.withValues(alpha: 0.6)
                    : AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.outline.withValues(alpha: 0.2),
          disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: AppSize.borderRadiusLarge,
          ),
          elevation: controller.isLoading ? 0 : AppSize.elevationMedium,
        ),
      ),
    );
  }
}
