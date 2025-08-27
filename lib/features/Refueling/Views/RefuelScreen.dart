import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Refueling/Controllers/RefuelController.dart';
import 'package:my_fuel/features/Refueling/Views/ScanQRScreen.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/widgets/MuTextField.dart';

class RefuelScreen extends StatelessWidget {
  RefuelScreen({super.key});

  final RefuelController controller = Get.put(RefuelController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تعبئة الوقود',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: AppSize.elevationNone,
        ),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: AppSize.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleCodeField(context),
                    SizedBox(height: AppSize.spacingMedium),
                    if (controller.isLoading.value) _buildLoadingIndicator(),
                    if (!controller.isLoading.value) ...[
                      SizedBox(height: AppSize.spacingMedium),
                      _buildVehicleInfoCard(context),
                      SizedBox(height: AppSize.spacingMedium),
                      _buildFuelAmountField(context),
                      SizedBox(height: AppSize.spacingLarge),
                      _buildSubmitButton(context),
                    ],
                  ],
                ),
              ),
              if (controller.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingSmall),
      child: LinearProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildVehicleCodeField(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "كود المركبة",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: AppFont.wbold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: AppSize.spacingExtraSmall),
        Row(
          children: [
            Expanded(
              child: MuTextField(
                controller: controller.vehicleCodeCtrl,

                hintText: "اضغط على أيقونة المسح",
              ),
            ),

            SizedBox(width: AppSize.spacingSmall),
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary,
                size: AppSize.iconMedium,
              ),
              onPressed: () => _startQrScan(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleInfoCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vehicle = controller.vehicleInfo.value;

    return Card(
      elevation: AppSize.elevationSmall,
      shape: RoundedRectangleBorder(borderRadius: AppSize.borderRadiusMedium),
      color: AppColors.surface,
      child: Padding(
        padding: AppSize.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: Text(
                'بيانات المركبة',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: AppFont.wbold,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () => controller.fetchVehicleInfo(),
            ),
            SizedBox(height: AppSize.spacingSmall),
            if (vehicle == null)
              Text(
                'يرجى مسح رمز QR للمركبة لعرض معلوماتها.',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.outline),
              )
            else ...[
              _infoRow(
                Icons.person_rounded,
                'المالك: ${Parser.parseString(vehicle.ownerName)}',
                context,
              ),
              _infoRow(
                Icons.directions_car_rounded,
                'نوع المركبة: ${Parser.parseString(vehicle.type)}',
                context,
              ),
              _infoRow(
                Icons.model_training,
                'الموديل: ${Parser.parseString(vehicle.modelYear)}',
                context,
              ),
              _infoRow(
                Icons.local_gas_station_rounded,
                'نوع الوقود: ${Parser.parseString(vehicle.fuelType?.name)}',
                context,
              ),
              _infoRow(
                Icons.confirmation_num_rounded,
                'رقم اللوحة: ${Parser.parseString(vehicle.plateNumber)}',
                context,
              ),
              _infoRow(
                Icons.confirmation_num_rounded,
                'رقم المحرك: ${Parser.parseString(vehicle.engineNumber)}',
                context,
              ),
              _infoRow(
                Icons.model_training,
                'اخر تعبئة: ${Parser.parseString(vehicle.lastRefuelDate)}',
                context,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.spacingExtraSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSize.iconSmall,
            color: AppColors.onSurface.withValues(alpha: 0.7),
          ),
          SizedBox(width: AppSize.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelAmountField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "كمية الوقود (لتر)",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: AppFont.wbold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: AppSize.spacingExtraSmall),
        MuTextField(
          controller: controller.fuelAmountCtrl,
          hintText: "أدخل الكمية",

          prefixIcon: Icon(
            Icons.local_gas_station_rounded,
            color: AppColors.primary,
            size: AppSize.iconMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.performRefuel(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
          shape: RoundedRectangleBorder(
            borderRadius: AppSize.borderRadiusLarge,
          ),
          elevation: AppSize.elevationMedium,
        ),
        child:
            controller.isLoading.value
                ? CircularProgressIndicator(color: AppColors.onPrimary)
                : Text(
                  "تعبئة الوقود",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: AppSize.mediumFont,
                    fontWeight: AppFont.wbold,
                    color: AppColors.onPrimary,
                  ),
                ),
      ),
    );
  }

  Future<void> _startQrScan(BuildContext context) async {
    final scannedCode = await Get.to<String?>(() => ScanQRScreen());
    if (scannedCode != null && scannedCode.isNotEmpty) {
      controller.vehicleCodeCtrl.text = scannedCode;
      await controller.fetchVehicleInfo(qrCode: scannedCode);
    }
  }
}
