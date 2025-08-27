import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Controllers/StationDailyInfoManagementController.dart';
import 'package:my_fuel/features/stations/Models/DailyInfoManegerModel.dart';
import 'package:my_fuel/features/stations/Views/DailyInfoStationFormScreen.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class DailyInfoStationManegerScreen extends StatelessWidget {
  final StationDailyInfoManagementController controller = Get.put(
    StationDailyInfoManagementController(),
  );

  DailyInfoStationManegerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة معلومات المحطات اليومية',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchAllStationDailyInfos(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.dailyInfos.isEmpty) {
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

        if (controller.dailyInfos.isEmpty) {
          return Center(
            child: Text(
              'لا توجد معلومات يومية لعرضها حالياً.',
              style: AppTextStyles.body,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSize.spacingMedium),
          itemCount: controller.dailyInfos.length,
          itemBuilder: (context, index) {
            final dailyInfo = controller.dailyInfos[index];
            return _buildDailyInfoCard(dailyInfo);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DailyInfoStationFormScreen());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDailyInfoCard(DailyInfoManegerModel dailyInfo) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSize.spacingMedium),
      elevation: AppSize.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' ${dailyInfo.stationName}', style: AppTextStyles.heading3),
            SizedBox(height: AppSize.spacingSmall),
            Text(
              'نوع الوقود: ${dailyInfo.dailyInfoFuelTypeName}',
              style: AppTextStyles.body.copyWith(color: AppColors.grey),
            ),
            SizedBox(height: AppSize.spacingSmall),
            Text(
              'التاريخ: ${Parser.parseDateTime(dailyInfo.dailyInfoDate)}',
              style: AppTextStyles.body.copyWith(color: AppColors.grey),
            ),
            SizedBox(height: AppSize.spacingSmall),
            Text(
              'الحجوزات: ${dailyInfo.totalBookingsCount}',
              style: AppTextStyles.body,
            ),
            Text(
              'الكمية المشحونة: ${dailyInfo.dailyInfoShippedAmount}',
              style: AppTextStyles.body,
            ),
            Text(
              'الكمية المستلمة: ${dailyInfo.dailyInfoReceivedAmount}',
              style: AppTextStyles.body,
            ),
            if (dailyInfo.dailyInfoRemainingAmount != 0)
              Text(
                'الكمية المتبقية: ${dailyInfo.dailyInfoRemainingAmount}',
                style: AppTextStyles.body,
              ),
            if (dailyInfo.dailyInfoExpectedShipment != 0)
              Text(
                'الشحنة المتوقعة: ${dailyInfo.dailyInfoExpectedShipment}',
                style: AppTextStyles.body,
              ),
            Text(
              'الحالة: ${dailyInfo.stationIsActive == true ? 'نشط' : 'غير نشط'}',
              style: AppTextStyles.body.copyWith(
                color:
                    dailyInfo.stationIsActive == true
                        ? AppColors.success
                        : AppColors.error,
                fontWeight: AppFont.wbold,
              ),
            ),
            Divider(height: AppSize.spacingLarge, color: AppColors.greyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => DailyInfoStationFormScreen(
                        dailyInfoId: dailyInfo.dailyInfoId.toString(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('تعديل'),
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
                          "هل أنت متأكد من رغبتك في حذف هذا السجل اليومي؟ لا يمكن التراجع عن هذا الإجراء.",
                      backgroundColor: Colors.white,
                      titleStyle: AppTextStyles.heading3,
                      middleTextStyle: AppTextStyles.body,
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
                            controller.deleteStationDailyInfo(
                              Parser.parseString(dailyInfo.dailyInfoId),
                            );
                            Get.back();
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
                  icon: const Icon(Icons.delete, size: 20),
                  label: const Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusSmall),
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
