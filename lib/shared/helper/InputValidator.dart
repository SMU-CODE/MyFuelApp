import 'package:flutter/material.dart';

enum InputType {
  username,
  email,
  phone,
  password,
  confirmPassword,
  general,
  name,
  otp,
  digitsOnly,
  arabicOnly,
  englishOnly,
  date,
  time,
}

class InputValidator {
  static String? validate({
    required String value,
    List<InputType> types = const [InputType.general],
    int? minLength,
    int? maxLength,
    String? fieldName,
    String? passwordToMatch,
    String? customRegex,
    String? customErrorMessage,
    bool isRequired = true,
    bool trimValue = true,
  }) {
    final processedValue = trimValue ? value.trim() : value;
    final label = fieldName ?? "هذا الحقل";

    if (isRequired && processedValue.isEmpty) {
      return customErrorMessage ?? "يجب تعبئة $label";
    }

    if (!isRequired && processedValue.isEmpty) {
      return null;
    }

    if (minLength != null && processedValue.length < minLength) {
      return customErrorMessage ??
          "$label قصير جداً (الحد الأدنى $minLength أحرف)";
    }

    if (maxLength != null && processedValue.length > maxLength) {
      return customErrorMessage ??
          "$label طويل جداً (الحد الأقصى $maxLength أحرف)";
    }

    for (var type in types) {
      final result = _validateByType(
        processedValue,
        type,
        label,
        passwordToMatch,
        customRegex,
        customErrorMessage,
      );
      if (result != null) return result;
    }

    return null;
  }

  static String? _validateByType(
    String value,
    InputType type,
    String label,
    String? passwordToMatch,
    String? customRegex,
    String? customErrorMessage,
  ) {
    switch (type) {
      case InputType.username:
        if (!RegExp(r'^[\p{L}0-9_\-\.]+$', unicode: true).hasMatch(value)) {
          return customErrorMessage ??
              "يسمح بالأحرف والأرقام والنقاط والشرطات فقط";
        }
        break;
      case InputType.email:
        if (!RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(value)) {
          return customErrorMessage ??
              "بريد إلكتروني غير صحيح (مثال: user@example.com)";
        }
        break;
      case InputType.phone:
        if (!RegExp(r'^7[0137]\d{7}$').hasMatch(value)) {
          return customErrorMessage ??
              "رقم هاتف يمني صحيح مطلوب (9 أرقام تبدأ ب 70 أو 71 أو 73 أو 77)";
        }
        break;
      case InputType.password:
        if (!RegExp(
          r'^(?=.*[\p{L}])(?=.*\d).{4,}$',
          unicode: true,
        ).hasMatch(value)) {
          return customErrorMessage ??
              "يجب أن تحتوي كلمة المرور على حروف وأرقام (4 أحرف على الأقل)";
        }
        break;
      case InputType.confirmPassword:
        if (passwordToMatch != null && value != passwordToMatch) {
          return customErrorMessage ?? "كلمات المرور غير متطابقة";
        }
        break;
      case InputType.name:
        if (!RegExp(r'^[\p{L}\s_\-]{1,20}$', unicode: true).hasMatch(value)) {
          return customErrorMessage ??
              "يجب أن يحتوي الاسم على أحرف عربية/إنجليزية فقط (20 حرفًا كحد أقصى)";
        }
        break;
      case InputType.otp:
        if (!RegExp(r'^\d{4,6}$').hasMatch(value)) {
          return customErrorMessage ?? "يجب أن يكون رمزاً رقمياً (4-6 أرقام)";
        }
        break;
      case InputType.digitsOnly:
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return customErrorMessage ?? "يسمح بالأرقام فقط";
        }
        break;
      case InputType.arabicOnly:
        if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(value)) {
          return customErrorMessage ?? "يسمح بالأحرف العربية فقط";
        }
        break;
      case InputType.englishOnly:
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return customErrorMessage ?? "يسمح بالأحرف الإنجليزية فقط";
        }
        break;
      case InputType.date:
        if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
          return customErrorMessage ?? "صيغة التاريخ غير صحيحة (YYYY-MM-DD)";
        }
        break;
      case InputType.time:
        if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
          return customErrorMessage ?? "صيغة الوقت غير صحيحة (HH:MM)";
        }
        break;
      case InputType.general:
        break;
    }

    if (customRegex != null) {
      try {
        if (!RegExp(customRegex).hasMatch(value)) {
          return customErrorMessage ?? "القيمة المدخلة غير مطابقة للمتطلبات";
        }
      } catch (e) {
        debugPrint("Regex Error: $e");
        return "خطأ في التحقق من الصحة";
      }
    }

    return null;
  }

  static String? validateSingle({
    required String value,
    required InputType type,
    String? fieldName,
    bool isRequired = true,
  }) {
    return validate(
      value: value,
      types: [type],
      fieldName: fieldName,
      isRequired: isRequired,
    );
  }

  static bool isValid({
    required String value,
    required InputType type,
    bool isRequired = true,
  }) {
    return validateSingle(value: value, type: type, isRequired: isRequired) ==
        null;
  }
}
