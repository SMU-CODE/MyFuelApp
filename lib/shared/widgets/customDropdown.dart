import 'package:flutter/material.dart' show BorderSide, DropdownButtonFormField, DropdownMenuItem, EdgeInsets, Icon, IconData, InputDecoration, Key, OutlineInputBorder, Text, TextEditingController, TextFormField, TextInputType, TextOverflow, TextStyle, Widget;
import 'package:my_fuel/shared/theme/app_colors.dart'; 
import 'package:my_fuel/shared/theme/app_size.dart'; 
import 'package:my_fuel/shared/constant/app_fonts.dart'; 
Widget customDropdown({
  required List<Map<String, dynamic>> items,
  required void Function(String?) onChanged,
  String? selectedId,
  String idKey = 'id',
  String nameKey = 'name',
  String labelText = 'اختر قيمة',
  IconData? icon,
  String? validationMessage,
  Key? key,
  String? helperMessage,
}) {
  final bool isValidValue =
      selectedId != null && items.any((item) => item[idKey] == selectedId);

  return DropdownButtonFormField<String>(
    key: key,
    initialValue: isValidValue ? selectedId : null,
    items:
        items.map((item) {
          final String itemValue = item[idKey]?.toString() ?? '';
          final String itemText = item[nameKey]?.toString() ?? 'غير معروف';

          return DropdownMenuItem<String>(
            value: itemValue,
            child: Text(
              itemText,
              style: TextStyle(
                fontSize: AppSize.mediumFont,
                color: AppColors.onSurface,    ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      helperText: helperMessage,
      labelText: labelText,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: TextStyle(
        fontSize: AppSize.largeFont,
        color: AppColors.onSurface,
        fontWeight: AppFont.wregular, 
      ),
      hintStyle: TextStyle(
        fontSize: AppSize.smallFont, 
        color: AppColors.onSurface.withValues(alpha:  0.6),
        fontWeight: AppFont.wlight, 
      ),
      border: OutlineInputBorder(
        borderRadius: AppSize.borderRadiusMedium,
        borderSide: BorderSide.none,
      ),
      contentPadding: AppSize.paddingAll,
    ),
    validator:
        (value) =>
            value == null || value.isEmpty
                ? (validationMessage ?? 'هذا الحقل مطلوب')
                : null,
    isExpanded: true,
    menuMaxHeight: AppSize.screenHeight * 0.4,
  );
}

Widget numberField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
    validator:
        (value) =>
            value == null || value.isEmpty
                ? 'الرجاء إدخال $label'
                : double.tryParse(value) == null
                ? 'يجب أن يكون $label رقمًا صحيحًا'
                : null,
  );
}

class MyDropdownItems {
  const MyDropdownItems();

  static const fuelTypes = [
    {'id': '1', 'name': 'بترول'},
    {'id': '2', 'name': 'ديزل'},
    {'id': '3', 'name': 'غاز'},
  ];

  static const periodTypes = [
    {'id': '1', 'name': 'الفترة الصباحية'},
    {'id': '2', 'name': 'الفترة المسائية'},
  ];
  static const statusTypes = [
    {'id': '1', 'name': 'نشطة'},
    {'id': '2', 'name': "غير نشطة"},
  ];
}
