import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/vehicles/Controllers/AddNewVehicleController.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/widgets/MuTextField.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';
import 'package:my_fuel/shared/widgets/customDropdown.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class AddNewVehicleScreen extends StatelessWidget {
  AddNewVehicleScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AddNewVehicleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مركبة جديدة', style: AppTextStyles.appBarTitle),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: AppSize.elevationSmall,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSize.pagePadding,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown(context),
                  SizedBox(height: AppSize.spacingMedium),
                  _buildFields(context),
                  SizedBox(height: AppSize.spacingLarge),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return customDropdown(
      items: MyDropdownItems.fuelTypes,
      selectedId: Parser.parseString(controller.selectedFuelTypeId.value),
      onChanged: (val) {
        controller.selectedFuelTypeId.value = Parser.parseInt(val);
      },
      labelText: 'نوع الوقود',
      icon: Icons.local_gas_station_rounded,
      validationMessage: 'الرجاء اختيار نوع الوقود',
    );
  }

  Widget _buildFields(BuildContext context) {
    return Column(
      children: [
        MuTextField(
          controller: controller.ownerNameCtrl,
          label: 'اسم المالك',
          prefixIcon: Icon(Icons.person_rounded),
          validator: _required('اسم المالك'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.vehicleTypeCtrl,
          label: 'نوع المركبة',
          prefixIcon: Icon(Icons.directions_car_rounded),
          validator: _required('نوع المركبة'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.engineNumberCtrl,
          label: 'رقم المحرك',
          prefixIcon: Icon(Icons.engineering_rounded),
          keyboardType: TextInputType.number,
          validator: _numberValidator('رقم المحرك'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.plateNumberCtrl,
          label: 'رقم اللوحة',
          prefixIcon: Icon(Icons.confirmation_num_rounded),
          keyboardType: TextInputType.text, // Plate numbers can contain letters
          validator: _required('رقم اللوحة'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.ownerPhoneCtrl,
          label: 'رقم هاتف المالك',
          prefixIcon: Icon(Icons.phone_rounded),
          keyboardType: TextInputType.phone,
          validator: _phoneValidator('رقم هاتف المالك'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.modelYearCtrl,
          label: 'سنة الصنع',
          prefixIcon: Icon(Icons.calendar_today_rounded),
          keyboardType: TextInputType.number,
          validator: _yearValidator('سنة الصنع'),
        ),
        SizedBox(height: AppSize.spacingSmall),
        MuTextField(
          controller: controller.colorCtrl,
          label: 'اللون',
          prefixIcon: Icon(Icons.color_lens_rounded),
          validator: _required('اللون'),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (controller.isLoading.value) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.check_circle_outline_rounded, color: AppColors.onPrimary),
            label: Text('إضافة المركبة', style: AppTextStyles.button.copyWith(color: AppColors.onPrimary)),
            onPressed: () => _submit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: AppSize.borderRadiusLarge,
              ),
              elevation: AppSize.elevationMedium,
            ),
          ),
        ),
        SizedBox(width: AppSize.spacingMedium),
        ElevatedButton.icon(
          icon: Icon(Icons.clear_rounded, color: AppColors.error),
          label: Text(
            'إلغاء',
            style: AppTextStyles.button.copyWith(color: AppColors.error),
          ),
          onPressed: () {
            controller.resetForm();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.error,
            padding: EdgeInsets.symmetric(horizontal: AppSize.spacingMedium, vertical: AppSize.spacingMedium),
            shape: RoundedRectangleBorder(
              borderRadius: AppSize.borderRadiusLarge,
            ),
            elevation: AppSize.elevationSmall,
          ),
        ),
      ],
    );
  }

  void _submit(BuildContext context) async {
  if (_formKey.currentState?.validate() ?? false) {
    if (controller.selectedFuelTypeId.value == 0) {
      MuAlerts.showError('الرجاء اختيار نوع الوقود.');
      return;
    }
    
    await controller.addNewVehicle();
    
  }
}

  String? Function(String?) _required(String field) {
    return (val) =>
        (val == null || val.trim().isEmpty) ? 'الرجاء إدخال $field.' : null;
  }

  String? Function(String?) _numberValidator(String field) {
    return (val) {
      if (val == null || val.trim().isEmpty) return 'الرجاء إدخال $field.';
      if (int.tryParse(val.trim()) == null) return '$field يجب أن يكون رقماً.';
      if (int.parse(val.trim()) <= 0) return '$field يجب أن يكون أكبر من صفر.';
      return null;
    };
  }

  String? Function(String?) _phoneValidator(String field) {
    return (val) {
      if (val == null || val.trim().isEmpty) return 'الرجاء إدخال $field.';
      if (!GetUtils.isPhoneNumber(val.trim())) return 'الرجاء إدخال رقم هاتف صالح.';
      return null;
    };
  }

  String? Function(String?) _yearValidator(String field) {
    return (val) {
      if (val == null || val.trim().isEmpty) return 'الرجاء إدخال $field.';
      final year = int.tryParse(val.trim());
      if (year == null || year < 1900 || year > DateTime.now().year + 1) {
        return 'الرجاء إدخال سنة صنع صالحة.';
      }
      return null;
    };
  }
}
