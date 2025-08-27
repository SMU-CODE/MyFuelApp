import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/vehicles/Controllers/LinkingVehicleController.dart';
import 'package:my_fuel/features/vehicles/Models/UservehicleswithdetailsModel.dart';
import 'package:my_fuel/features/vehicles/Views/LinkingOTPForm.dart';
import 'package:my_fuel/features/vehicles/widgets/vehicle_list_section.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/features/vehicles/widgets/add_vehicle_form.dart';

class LinkingWithVehicleScreen extends StatelessWidget {
  const LinkingWithVehicleScreen({super.key});

  Widget _buildVehicleCard(
    UservehicleswithdetailsModel userVehicle,
    BuildContext context,
  ) {
    final isActive = userVehicle.isActive == true;
    final lastRefuelDateStr = userVehicle.lastRefuelDate;

    final lastRefuelDate = DateTime.tryParse(lastRefuelDateStr ?? '');

    final canBook =
        lastRefuelDateStr != null &&
        lastRefuelDateStr.trim().isEmpty &&
        lastRefuelDateStr != 'N/A' &&
        lastRefuelDate != null &&
        lastRefuelDate.isAfter(
          DateTime.now().subtract(const Duration(days: 5)),
        );

    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: AppSize.elevationSmall,
      shape: RoundedRectangleBorder(borderRadius: AppSize.borderRadiusMedium),
      color: AppColors.surface,
      child: InkWell(
        borderRadius: AppSize.borderRadiusMedium,
        onTap: () {
          Get.snackbar(
            'معلومات المركبة',
            'سيتم عرض تفاصيل المركبة ${Parser.parseString(userVehicle.ownerName)}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.info.withValues(alpha: 0.7),
            colorText: AppColors.onPrimary,
            margin: AppSize.paddingAll,
          );
        },
        child: Padding(
          padding: AppSize.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    Parser.parseString(userVehicle.ownerName),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: AppFont.wbold,
                      color: isActive ? AppColors.onSurface : AppColors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.outline.withValues(alpha: 0.2),
                    radius: AppSize.circleAvatarRadiusMedium,
                    child: Icon(
                      Icons.directions_car_filled_rounded,
                      color: isActive ? AppColors.primary : AppColors.outline,
                      size: AppSize.iconMedium,
                    ),
                  ),
                  SizedBox(width: AppSize.spacingMedium),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Parser.parseString(userVehicle.type),
                          style: textTheme.bodySmall?.copyWith(
                            color:
                                isActive
                                    ? AppColors.onSurface.withValues(alpha: 0.7)
                                    : AppColors.outline.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.spacingSmall,
                      vertical: AppSize.spacingExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      color:
                          canBook
                              ? AppColors.success.withValues(alpha: 0.2)
                              : AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: AppSize.borderRadiusSmall,
                    ),
                    child: Text(
                      canBook ? 'جاهزة للحجز' : 'غير مؤهلة',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: AppFont.wbold,
                        color: canBook ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.spacingSmall),
                  IconButton(
                    icon: Icon(
                      Icons.link_off_rounded,
                      size: AppSize.iconSmall,
                      color: AppColors.error,
                    ),
                    onPressed: () {
                      if (userVehicle.isActive ?? false) {
                        Get.find<LinkingVehicleController>().unlinkVehicle(
                          Parser.parseString(userVehicle.qrCode),
                        );
                      } else {
                        MuAlerts.showWarning("المركبة المختارة غير نشطة");
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: AppSize.spacingMedium),

              _infoRow(
                Icons.qr_code_rounded,
                'الكود: ${Parser.parseString(userVehicle.qrCode)}',
                isActive,
                context,
              ),
              _infoRow(
                Icons.local_gas_station_rounded,
                'الوقود: ${Parser.parseString(userVehicle.fuelTypeId)}',
                isActive,
                context,
              ),
              _infoRow(
                Icons.confirmation_num_rounded,
                'رقم اللوحة: ${Parser.parseString(userVehicle.plateNumber)}',
                isActive,
                context,
              ),
              _infoRow(
                Icons.engineering_rounded,
                'رقم المحرك: ${Parser.parseString(userVehicle.engineNumber)}',
                isActive,
                context,
              ),
              if (!canBook && isActive)
                Padding(
                  padding: EdgeInsets.only(top: AppSize.spacingSmall),
                  child: Text(
                    'يمكنك الحجز بعد تاريخ ${Parser.parseString(userVehicle.lastRefuelDate)} بخمسة أيام',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: AppFont.wbold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
    bool isActive,
    BuildContext context,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingExtraSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSize.iconExtraSmall,
            color:
                isActive
                    ? AppColors.onSurface.withValues(alpha: 0.7)
                    : AppColors.outline.withValues(alpha: 0.7),
          ),
          SizedBox(width: AppSize.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: isActive ? AppColors.onSurface : AppColors.outline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LinkingVehicleController controller = Get.put(
      LinkingVehicleController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة المركبات',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppColors.background,
        elevation: AppSize.elevationNone,
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isOtp.value
            ? const LinkingOTPForm() // واجهة OTP
            : Column(
              children: [
                AddVehicleForm(controller: controller),
                SizedBox(height: AppSize.spacingLarge),
                VehicleListSection(
                  controller: controller,
                  buildVehicleCard: _buildVehicleCard,
                ),
              ],
            );
      }),
    );
  }
}
