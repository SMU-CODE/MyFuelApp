import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_fuel/features/stations/Controllers/StationFormController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

Widget buildStationImageField(StationFormController controller) {
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.updateImageFile(File(pickedFile.path));
    }
  }

  return Column(
    children: [
      InkWell(
        onTap: pickImage,
        child: Obx(
          () {
            Widget imageContent;
            if (controller.imageFile.value != null) {
              imageContent = ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                child: Image.file(
                  controller.imageFile.value!,
                  fit: BoxFit.cover,
                ),
              );
            } else if (controller.currentImageUrl != null && controller.currentImageUrl!.isNotEmpty) {
              imageContent = ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                child: Image.network(
                  controller.currentImageUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 80, color: AppColors.grey),
                ),
              );
            } else {
              imageContent = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: AppColors.primary),
                  SizedBox(height: AppSize.spacingSmall),
                  Text('إضافة صورة', style: TextStyle(color: AppColors.primary)),
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
          },
        ),
      ),
      Obx(
        () => (controller.imageFile.value != null || (controller.currentImageUrl != null && controller.currentImageUrl!.isNotEmpty))
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
