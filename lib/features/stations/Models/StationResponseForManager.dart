import 'package:my_fuel/shared/helper/Parser.dart';

class StationResponseForManager {
  final int id;
  final String? name;
  final String? location;
  final String? about;
  final String? image;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  StationResponseForManager({
    required this.id,
    this.name,
    this.location,
    this.about,
    this.image,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory StationResponseForManager.fromJson(Map<String, dynamic> json) {
    return StationResponseForManager(
      id: Parser.parseInt(json['id'], variableName: 'id'),
      name: Parser.parseString(json['name'], variableName: 'name'),
      location: Parser.parseString(json['location'], variableName: 'location'),
      about: Parser.parseString(json['about'], variableName: 'about'),
      image: Parser.parseString(json['image'], variableName: 'image'),
      isActive: Parser.parseBool(json['is_active'], variableName: 'is_active'),
      createdAt: Parser.parseString(
        json['created_at'],
        variableName: 'created_at',
      ),
      updatedAt: Parser.parseString(
        json['updated_at'],
        variableName: 'updated_at',
      ),
      imageUrl: Parser.parseString(
        json['image_url'],
        variableName: 'image_url',
      ),
    );
  }
}

// << MU-CODE | © 2025-07-24 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
