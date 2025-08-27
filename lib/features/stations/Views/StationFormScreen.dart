// station_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_fuel/features/stations/Controllers/StationFormController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';

class StationFormScreen extends StatelessWidget {
  final String? stationId;
  final _formKey = GlobalKey<FormState>();

  StationFormScreen({super.key, this.stationId});

  @override
  Widget build(BuildContext context) {
    final StationFormController controller = Get.put(
      StationFormController(stationId: stationId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value
                ? 'تعديل المحطة'
                : 'إضافة محطة وقود جديدة',
            style: AppTextStyles.appBarTitle,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isSuccess.value && !controller.isEditMode.value) {
          return _buildSuccessView(controller);
        }
        if (controller.isLoading.value && !controller.isEditMode.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return _buildFormView(controller, _formKey);
      }),
    );
  }

  Widget _buildSuccessView(StationFormController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: AppColors.success),
          SizedBox(height: AppSize.spacingMedium),
          Text(
            'تمت العملية بنجاح',
            style: AppTextStyles.heading2.copyWith(color: AppColors.success),
          ),
          SizedBox(height: AppSize.spacingLarge),
          ElevatedButton(
            onPressed: controller.resetForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.spacingLarge,
                vertical: AppSize.spacingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
              ),
            ),
            child: Text('إضافة محطة أخرى', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(
    StationFormController controller,
    GlobalKey<FormState> formKey,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSize.spacingMedium),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildStationImageField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildNameField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildLocationField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildAboutField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildIsActiveSwitch(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildSubmitButton(controller, formKey),
            SizedBox(height: AppSize.spacingMedium),
            if (!controller.isEditMode.value)
              _buildResetButton(controller, formKey),
          ],
        ),
      ),
    );
  }

  Widget _buildStationImageField(StationFormController controller) {
    Future<void> pickImage() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        controller.updateImageFile(File(pickedFile.path));
      }
    }

    return Column(
      children: [
        InkWell(
          onTap: pickImage,
          child: Obx(() {
            Widget imageContent;
            if (controller.imageFile.value != null) {
              imageContent = ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                child: Image.file(
                  controller.imageFile.value!,
                  fit: BoxFit.cover,
                ),
              );
            } else if (controller.currentImageUrl != null &&
                controller.currentImageUrl!.isNotEmpty) {
              imageContent = ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                child: Image.network(
                  controller.currentImageUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 80,
                    color: AppColors.grey,
                  ),
                ),
              );
            } else {
              imageContent = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: AppColors.primary),
                  SizedBox(height: AppSize.spacingSmall),
                  Text(
                    'إضافة صورة',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              );
            }

            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                border: Border.all(color: AppColors.primary),
              ),
              child: imageContent,
            );
          }),
        ),
        Obx(
          () =>
              (controller.imageFile.value != null ||
                      (controller.currentImageUrl != null &&
                          controller.currentImageUrl!.isNotEmpty))
                  ? TextButton(
                      onPressed: pickImage,
                      child: Text(
                        'تغيير الصورة',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildNameField(StationFormController controller) {
    return TextFormField(
      controller: controller.stationNameCtrl,
      decoration: InputDecoration(
        labelText: 'اسم المحطة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.local_gas_station, color: AppColors.primary),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'يرجى إدخال اسم المحطة' : null,
    );
  }

  Widget _buildLocationField(StationFormController controller) {
    return TextFormField(
      controller: controller.stationLocationCtrl,
      decoration: InputDecoration(
        labelText: 'الموقع',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'يرجى إدخال موقع المحطة' : null,
    );
  }

  Widget _buildAboutField(StationFormController controller) {
    return TextFormField(
      controller: controller.stationAboutCtrl,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'وصف المحطة (اختياري)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.description, color: AppColors.primary),
      ),
    );
  }

  Widget _buildIsActiveSwitch(StationFormController controller) {
    return Obx(
      () => Row(
        children: [
          Text('المحطة نشطة', style: AppTextStyles.body),
          SizedBox(width: AppSize.spacingSmall),
          Switch(
            value: controller.isActive.value,
            onChanged: (bool value) {
              controller.isActive.value = value;
            },
            activeThumbColor: AppColors.success,
            inactiveThumbColor: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    StationFormController controller,
    GlobalKey<FormState> formKey,
  ) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (formKey.currentState?.validate() ?? false) {
                    controller.handleStationSubmission();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  controller.isEditMode.value
                      ? 'تحديث المحطة'
                      : 'إضافة المحطة',
                  style: AppTextStyles.button,
                ),
        ),
      ),
    );
  }

  Widget _buildResetButton(
    StationFormController controller,
    GlobalKey<FormState> formKey,
  ) {
    return TextButton(
      onPressed: () {
        controller.resetForm();
        formKey.currentState?.reset();
      },
      child: Text(
        'مسح النموذج',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: AppSize.scaleFont(16),
        ),
      ),
    );
  }
}
