import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/stations/Controllers/StationDailyInfoFormController.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';
import 'package:my_fuel/shared/widgets/customDropdown.dart';

class DailyInfoStationFormScreen extends StatelessWidget {
  final String? dailyInfoId;
  final _formKey = GlobalKey<FormState>();

  DailyInfoStationFormScreen({super.key, this.dailyInfoId});

  @override
  Widget build(BuildContext context) {
    final StationDailyInfoFormController controller = Get.put(
      StationDailyInfoFormController(dailyInfoId: dailyInfoId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value
                ? 'تعديل معلومات يومية'
                : 'إضافة معلومات يومية جديدة',
            style: AppTextStyles.appBarTitle,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && !controller.isEditMode.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.isSuccess.value && !controller.isEditMode.value) {
          return _buildSuccessView(controller);
        }
        return _buildFormView(controller, _formKey);
      }),
    );
  }

  Widget _buildSuccessView(StationDailyInfoFormController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: AppSize.scaleFont(80),
            color: AppColors.success,
          ),
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
            child: Text('إضافة سجل آخر', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(
    StationDailyInfoFormController controller,
    GlobalKey<FormState> formKey,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSize.spacingMedium),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (!controller.isEditMode.value) _buildStationIdField(controller),
            if (!controller.isEditMode.value)
              SizedBox(height: AppSize.spacingLarge),
            if (!controller.isEditMode.value) _buildFuelTypeIdField(controller),
            if (!controller.isEditMode.value)
              SizedBox(height: AppSize.spacingLarge),
            _buildInfoDateField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildTotalBookingsField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildShippedAmountField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildReceivedAmountField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildRemainingAmountField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildExpectedShipmentField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildNotesField(controller),
            SizedBox(height: AppSize.spacingLarge),
            _buildStatusSwitch(controller),
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

  Widget _buildStationIdField(StationDailyInfoFormController controller) {
    return Form(
      child: Column(
        children: [
          Obx(
            () => customDropdown(
              items: controller.stationsDropdown,
              selectedId: Parser.parseString(controller.selectedStationId),
              onChanged: (val) {
                controller.selectedStationId = (Parser.parseInt(val));
              },
              labelText: 'المحطة',
              icon: Icons.business,
              validationMessage: 'الرجاء اختيار محطة ما',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelTypeIdField(StationDailyInfoFormController controller) {
    return customDropdown(
      items: MyDropdownItems.fuelTypes,
      selectedId: Parser.parseString(controller.selectedFuelTypeId),
      onChanged: (val) {
        controller.selectedFuelTypeId = Parser.parseInt(val);
      },
      labelText: 'نوع الوقود',
      icon: Icons.local_gas_station_rounded,
      validationMessage: 'الرجاء اختيار نوع الوقود',
    );
  }

  // Build info date input field (yyyy-MM-dd)
  Widget _buildInfoDateField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.infoDateCtrl,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('ar'),
          helpText: 'اختر تاريخ المعلومات',
          cancelText: 'إلغاء',
          confirmText: 'تأكيد',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDatePickerMode: DatePickerMode.day,
        );

        if (pickedDate != null) {
          controller.infoDateCtrl.text = Parser.formatDateTime(
            pickedDate,
            format: 'yyyy-MM-dd',
          );
        }
      },
      decoration: InputDecoration(
        labelText: 'تاريخ المعلومات (yyyy-MM-dd)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى اختيار تاريخ المعلومات';
        }
        try {
          DateTime.parse(value);
        } catch (_) {
          return 'صيغة تاريخ المعلومات غير صحيحة';
        }
        return null;
      },
    );
  }

  Widget _buildTotalBookingsField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.totalBookingsCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'إجمالي الحجوزات',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.list_alt, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال إجمالي الحجوزات';
        }
        if (int.tryParse(value) == null || int.parse(value) < 0) {
          return 'يجب أن يكون رقمًا صحيحًا غير سالب';
        }
        return null;
      },
    );
  }

  Widget _buildShippedAmountField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.shippedAmountCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'الكمية المشحونة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.local_shipping, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال الكمية المشحونة';
        }
        if (double.tryParse(value) == null || double.parse(value) < 0) {
          return 'يجب أن يكون رقمًا غير سالب';
        }
        return null;
      },
    );
  }

  Widget _buildReceivedAmountField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.receivedAmountCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'الكمية المستلمة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.receipt_long, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال الكمية المستلمة';
        }
        if (double.tryParse(value) == null || double.parse(value) < 0) {
          return 'يجب أن يكون رقمًا غير سالب';
        }
        return null;
      },
    );
  }

  Widget _buildRemainingAmountField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.remainingAmountCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'الكمية المتبقية ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.inventory, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال الكمية المتبقية';
        }
        if ((double.tryParse(value) == null || double.parse(value) < 0)) {
          return 'يجب أن يكون رقمًا غير سالب';
        }
        return null;
      },
    );
  }

  Widget _buildExpectedShipmentField(
    StationDailyInfoFormController controller,
  ) {
    return TextFormField(
      controller: controller.expectedShipmentCtrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'الشحنة المتوقعة (اختياري)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.delivery_dining, color: AppColors.primary),
      ),
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            (double.tryParse(value) == null || double.parse(value) < 0)) {
          return 'يجب أن يكون رقمًا غير سالب';
        }
        return null;
      },
    );
  }

  Widget _buildNotesField(StationDailyInfoFormController controller) {
    return TextFormField(
      controller: controller.notesCtrl,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'الملاحظات (اختياري)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        prefixIcon: Icon(Icons.notes, color: AppColors.primary),
      ),
      validator: (value) {
        if (value != null && value.length > 1000) {
          return 'الملاحظات لا يمكن أن تتجاوز 1000 حرف';
        }
        return null;
      },
    );
  }

  Widget _buildStatusSwitch(StationDailyInfoFormController controller) {
    return Obx(
      () => Row(
        children: [
          Text('السجل نشط', style: AppTextStyles.body),
          SizedBox(width: AppSize.spacingSmall),
          Switch(
            value: controller.status.value == '1',
            onChanged: (bool value) {
              controller.status.value = value ? '1' : '0';
            },
            activeThumbColor: AppColors.success,
            inactiveThumbColor: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    StationDailyInfoFormController controller,
    GlobalKey<FormState> formKey,
  ) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    if (formKey.currentState?.validate() ?? false) {
                      controller.handleDailyInfoSubmission();
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
            ),
          ),
          child:
              controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                    controller.isEditMode.value
                        ? 'تحديث يومية'
                        : 'إضافة يومية ',
                    style: AppTextStyles.button,
                  ),
        ),
      ),
    );
  }

  Widget _buildResetButton(
    StationDailyInfoFormController controller,
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
