import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: StationsDropdownModel
class StationsDropdownModel {
  final int? id;
  final String? name;

  const StationsDropdownModel({this.id, this.name});

  /// Parse JSON to model
  factory StationsDropdownModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return StationsDropdownModel(
    id: Parser.parseInt(json['id']),
    name: Parser.parseString(json['name']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'StationsDropdownModel(id: $id, name: $name)';
}

// << MU-CODE | © 2025-07-25 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
