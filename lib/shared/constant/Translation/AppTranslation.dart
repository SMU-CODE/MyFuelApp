import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
class AppTranslation extends Translations {
  static Map<String, Map<String, String>> translations = {};

  static Future<void> init() async {
    translations = {
      'en_US': await _loadJson('assets/translations/en_US.json'),
      'ar_AR': await _loadJson('assets/translations/ar_AR.json'),
    };
  }

  static Future<Map<String, String>> _loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
