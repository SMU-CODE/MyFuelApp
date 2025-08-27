import 'dart:io';
import 'package:my_fuel/shared/helper/Parser.dart';

class StationFormRequest {
  final String? name;
  final String? location;
  final String? about;
  final File? imageFile;
  final bool? isActive;

  const StationFormRequest({
    this.name,
    this.location,
    this.about,
    this.imageFile,
    this.isActive,
  });

  factory StationFormRequest.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for AddNewStationRequestModel',
      );
    }
    return StationFormRequest(
      name: Parser.parseString(json['name']),
      location: Parser.parseString(json['location']),
      about: Parser.parseString(json['about']),
      isActive: Parser.parseBool(json['is_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'about': about,
      'is_active': isActive,
    };
  }

  @override
  String toString() {
    return 'AddNewStationRequestModel('
        'name: $name, '
        'location: $location, '
        'about: $about, '
        'imageFile: ${imageFile?.path}, '
        'isActive: $isActive'
        ')';
  }
}
