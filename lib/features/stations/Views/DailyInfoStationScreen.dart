import 'package:flutter/material.dart';
import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/features/stations/Controllers/StationsDailyInfoController.dart';
import 'package:my_fuel/features/stations/Widgets/DailyInfoStationsCard.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class DailyInfoStationScreen extends StatelessWidget {
  const DailyInfoStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("محطات الوقود", style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              size: AppSize.iconSmall,
            ),
            onPressed: () => AppRoutes.goTo(AppRoutes.notifications),
          ),
        ],
      ),
      body: GetBuilder<StationsDailyInfoController>(
        init: StationsDailyInfoController(),
        builder: (controller) {
          if (controller.isFetchingData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.fetchFailed) {
            return Center(child: _buildErrorDisplay(context, controller));
          }

          return RefreshIndicator(
            onRefresh: controller.fetchDailyStationData,
            color: AppColors.primary,
            child: ListView.separated(
              padding: AppSize.pagePadding,
              itemCount: controller.dailyStationInfos.length,
              separatorBuilder:
                  (_, __) => SizedBox(height: AppSize.spacingMedium),
              itemBuilder: (context, index) {
                final stationInfo = controller.dailyStationInfos[index];
                return DailyInfoStationsCard(station: stationInfo);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorDisplay(
    BuildContext context,
    StationsDailyInfoController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: controller.fetchDailyStationData,
      color: AppColors.error,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height:
              MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          alignment: Alignment.center,
          padding: AppSize.paddingAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: AppSize.iconLarge * 1.5,
                color: AppColors.error,
              ),
              SizedBox(height: AppSize.spacingLarge),
              Text(
                controller.errorMessage ??
                    "عذراً، لم نتمكن من تحميل بيانات المحطات. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.",
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.error,
                  fontWeight: AppFont.wmedium,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSize.spacingLarge),
              ElevatedButton.icon(
                onPressed: controller.fetchDailyStationData,
                icon: Icon(Icons.refresh_rounded, size: AppSize.iconMedium),
                label: Text(
                  "إعادة المحاولة",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFont.wbold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.onError,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.spacingLarge,
                    vertical: AppSize.spacingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSize.borderRadiusLarge,
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
