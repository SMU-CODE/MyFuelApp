import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: PeriodsDropdownModel
class PeriodsDropdownModel {
  final int id;
  final String name;

  const PeriodsDropdownModel({required this.id, required this.name});

  /// Parse JSON to model
  factory PeriodsDropdownModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return PeriodsDropdownModel(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
    );
  }

  @override
  String toString() => 'PeriodsDropdownModel(id: $id, name: $name)';
}

// << MU-CODE | © 2025-07-30 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
