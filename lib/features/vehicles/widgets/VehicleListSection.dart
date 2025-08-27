import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/vehicles/Controllers/LinkingVehicleController.dart';
import 'package:my_fuel/features/vehicles/Models/UservehicleswithdetailsModel.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';

class VehicleListSection extends StatelessWidget {
  final LinkingVehicleController controller;
  final Function(UservehicleswithdetailsModel, BuildContext) buildVehicleCard;

  const VehicleListSection({
    required this.controller,
    required this.buildVehicleCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      return Expanded(
        child:
            controller.userVehicles.isEmpty
                ? RefreshIndicator(
                  onRefresh: () async => await controller.loadLinkedVehicles(),
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: AppSize.paddingAll,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: AppSize.iconLarge * 1.5,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          SizedBox(height: AppSize.spacingMedium),
                          Text(
                            'لا توجد مركبات مرتبطة بحسابك حاليًا.',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.outline,
                              fontWeight: AppFont.wmedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSize.spacingSmall),
                          TextButton(
                            onPressed:
                                () async =>
                                    await controller.loadLinkedVehicles(),
                            child: Text(
                              "أعد التحميل",
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppFont.wbold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () async {
                    await controller.loadLinkedVehicles();
                  },
                  color: AppColors.primary,
                  child: ListView.separated(
                    padding: AppSize.paddingAll,
                    itemCount: controller.userVehicles.length,
                    separatorBuilder:
                        (_, __) => SizedBox(height: AppSize.spacingMedium),
                    itemBuilder: (context, index) {
                      return buildVehicleCard(
                        controller.userVehicles[index],
                        context,
                      );
                    },
                  ),
                ),
      );
    });
  }
}
