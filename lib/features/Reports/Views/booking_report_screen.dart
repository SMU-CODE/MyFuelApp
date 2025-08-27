import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Reports/Controllers/BookingReportController.dart';

import 'package:my_fuel/shared/theme/app_colors.dart'; // Assuming you have AppColors
import 'package:my_fuel/shared/constant/app_fonts.dart'; // Assuming you have AppFont
import 'package:my_fuel/shared/theme/app_size.dart'; // Assuming you have AppSize

class BookingReportScreen extends GetView<BookingReportController> {
  const BookingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if not already done (e.g., in GetX Bindings)
    Get.put(
      BookingReportController(),
    ); // You might put this in your routes or bindings instead

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تقارير الحجوزات',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontSize: AppSize.largeFont,
            fontWeight: AppFont.wbold,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // For RTL layout
        child: Padding(
          padding: EdgeInsets.all(AppSize.elevationMedium),
          child: Column(
            children: [
              // --- Filters Section ---
              _buildFiltersCard(context),
              SizedBox(height: AppSize.spacingMedium),
              // --- Report Display Section ---
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    );
                  } else if (controller.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 50,
                          ),
                          SizedBox(height: AppSize.spacingSmall),
                          Text(
                            controller.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: AppSize.mediumFont,
                            ),
                          ),
                          SizedBox(height: AppSize.spacingMedium),
                          ElevatedButton.icon(
                            onPressed: controller.fetchReport,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!controller.hasData) {
                    return Center(
                      child: Text(
                        'لا توجد بيانات لعرضها. يرجى تعديل الفلاتر.',
                        style: TextStyle(
                          fontSize: AppSize.mediumFont,
                          color: AppColors.surface,
                        ),
                      ),
                    );
                  } else {
                    return _buildReportDataTable();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      ),
      margin: EdgeInsets.only(bottom: AppSize.spacingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppSize.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الفلاتر',
              style: TextStyle(
                fontSize: AppSize.largeFont,
                fontWeight: AppFont.wbold,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Date Range Filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.startDateController,
                    readOnly: true,
                    onTap:
                        () => controller.pickDate(
                          context,
                          controller.startDateController,
                        ),
                    decoration: InputDecoration(
                      labelText: 'تاريخ البدء',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusSmall,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.spacingSmall),
                Expanded(
                  child: TextField(
                    controller: controller.endDateController,
                    readOnly: true,
                    onTap:
                        () => controller.pickDate(
                          context,
                          controller.endDateController,
                        ),
                    decoration: InputDecoration(
                      labelText: 'تاريخ الانتهاء',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusSmall,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Station Filter
            Obx(
              () => DropdownButtonFormField<int?>(
                initialValue:
                    controller.selectedStationIds.isEmpty
                        ? null
                        : controller
                            .selectedStationIds
                            .first, // For single selection dropdown example
                decoration: InputDecoration(
                  labelText: 'المحطة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    //horizontal: AppSize.paddingHorizontal,
                    vertical: AppSize.spacingSmall,
                  ),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('جميع المحطات'),
                  ),
                  ...controller.stationsDropdown().map(
                    (station) => DropdownMenuItem<int>(
                      value: station['id'] as int,
                      child: Text(station['name'] as String),
                    ),
                  ),
                ],
                onChanged: (int? newValue) {
                  controller.selectedStationIds.clear();
                  if (newValue != null) {
                    controller.selectedStationIds.add(newValue);
                  }
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Fuel Type Filter
            Obx(
              () => DropdownButtonFormField<int?>(
                initialValue:
                    controller.selectedFuelTypeIds.isEmpty
                        ? null
                        : controller.selectedFuelTypeIds.first,
                decoration: InputDecoration(
                  labelText: 'نوع الوقود',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.spacingSmall,
                    vertical: AppSize.spacingSmall,
                  ),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('جميع أنواع الوقود'),
                  ),
                  ...controller.availableFuelTypes.map(
                    (fuelType) => DropdownMenuItem<int>(
                      value: fuelType['id'] as int,
                      child: Text(fuelType['name'] as String),
                    ),
                  ),
                ],
                onChanged: (int? newValue) {
                  controller.selectedFuelTypeIds.clear();
                  if (newValue != null) {
                    controller.selectedFuelTypeIds.add(newValue);
                  }
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Status Filter (using CheckboxListTile for multiple selection, or Dropdown for single)
            // For simplicity, let's use a Dropdown for single status selection for now.
            // If multi-select is critical, you'd need a custom multi-select dropdown.
            Obx(
              () => DropdownButtonFormField<String?>(
                initialValue:
                    controller.selectedStatuses.isEmpty
                        ? null
                        : controller.selectedStatuses.first,
                decoration: InputDecoration(
                  labelText: 'الحالة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.spacingSmall,
                    vertical: AppSize.spacingSmall,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('جميع الحالات'),
                  ),
                  ...controller.availableStatuses.map(
                    (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  controller.selectedStatuses.clear();
                  if (newValue != null) {
                    controller.selectedStatuses.add(newValue);
                  }
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Group By Filter
            Obx(
              () => DropdownButtonFormField<String?>(
                initialValue: controller.selectedGroupBy.value,
                decoration: InputDecoration(
                  labelText: 'التجميع حسب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSmall),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.spacingSmall,
                    vertical: AppSize.spacingSmall,
                  ),
                ),
                items:
                    controller.availableGroupBys
                        .map(
                          (option) => DropdownMenuItem<String?>(
                            value: option['value'] as String?,
                            child: Text(option['label'] as String),
                          ),
                        )
                        .toList(),
                onChanged: (String? newValue) {
                  controller.selectedGroupBy.value = newValue;
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: AppSize.spacingMedium),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.fetchReport;
                      // controller.openHtmlReportInApp();
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('تطبيق الفلاتر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.spacingSmall,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.spacingSmall),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.resetFilters,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('مسح الفلاتر'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.spacingSmall,
                      ),
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

  Widget _buildReportDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSize.spacingSmall),
          child: DataTable(
            columnSpacing: 16.0,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 60,
            headingRowHeight: 50,
            dividerThickness: 1,
            horizontalMargin: 12,
            border: TableBorder.all(
              color: AppColors.outline,
              width: 1,
              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
            ),
            columns: const [
              DataColumn(
                label: Expanded(
                  child: Text(
                    'المجموعة',
                    style: TextStyle(fontWeight: AppFont.wbold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'إجمالي الحجوزات',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: AppFont.wbold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'إجمالي الوقود (لتر)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: AppFont.wbold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'إجمالي الإيرادات',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: AppFont.wbold),
                  ),
                ),
              ),
            ],
            rows:
                controller.reportItems.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item.groupName ?? 'غير معروف')),
                      DataCell(
                        Text(
                          item.maxBookings.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          item.totalFuelAmount.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          item.totalRevenue.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
