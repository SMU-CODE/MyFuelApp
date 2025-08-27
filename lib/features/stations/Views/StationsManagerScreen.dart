// stations_manager_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Controllers/StationsManagementController.dart';
import 'package:my_fuel/features/stations/Models/StationResponseForManager.dart';
import 'package:my_fuel/features/stations/Views/StationFormScreen.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class StationsManagerScreen extends StatelessWidget {
  final StationsManagementController controller = Get.put(
    StationsManagementController(),
  );

  StationsManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المحطات', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchAllStations(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stations.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: AppTextStyles.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (controller.stations.isEmpty) {
          return Center(
            child: Text(
              'لا توجد محطات لعرضها حالياً.',
              style: AppTextStyles.body,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSize.spacingMedium),
          itemCount: controller.stations.length,
          itemBuilder: (context, index) {
            final station = controller.stations[index];
            return _buildStationCard(station);
          },
        );
      }),
    );
  }

  Widget _buildStationCard(StationResponseForManager station) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSize.spacingMedium),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                station.imageUrl != null && station.imageUrl!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                      child: Image.network(
                        station.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 80,
                              color: AppColors.grey,
                            ),
                      ),
                    )
                    : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusSmall,
                        ),
                      ),
                      child: Icon(
                        Icons.local_gas_station,
                        size: 40,
                        color: AppColors.grey,
                      ),
                    ),
                SizedBox(width: AppSize.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name ?? 'لا يوجد اسم',
                        style: AppTextStyles.heading3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSize.spacingSmall),
                      Text(
                        station.location ?? 'لا يوجد موقع',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSize.spacingSmall),
                      Text(
                        station.isActive == true ? 'نشطة' : 'غير نشطة',
                        style: AppTextStyles.body.copyWith(
                          color:
                              station.isActive == true
                                  ? AppColors.success
                                  : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.spacingMedium),
            Text(
              station.about ?? 'لا يوجد وصف.',
              style: AppTextStyles.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Divider(height: AppSize.spacingLarge, color: AppColors.greyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => StationFormScreen(stationId: station.id.toString()),
                    );
                  },
                  icon: Icon(Icons.edit, size: 20),
                  label: Text('تعديل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.spacingSmall),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "تأكيد الحذف",
                      middleText:
                          "هل أنت متأكد من رغبتك في حذف المحطة '${Parser.parseString(station.name)}'؟ لا يمكن التراجع عن هذا الإجراء.",
                      backgroundColor: Colors.white,
                      titleStyle: AppTextStyles.heading3,
                      middleTextStyle: AppTextStyles.body,
                      // Added an explicit `radius` for the dialog for better aesthetics.
                      radius: AppSize.radiusMedium,
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'إلغاء',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Using a more direct approach for calling the controller method.
                            // Consider if `Parser.parseString(station.id)` is always necessary here.
                            controller.deleteStation(
                              Parser.parseString(station.id),
                            );
                            controller.fetchAllStations();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('حذف', style: AppTextStyles.button),
                        ),
                      ],
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  ), // Added `const` for performance.
                  label: const Text('حذف'), // Added `const` for performance.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                    ),
                    // Added padding for better visual spacing within the button.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
