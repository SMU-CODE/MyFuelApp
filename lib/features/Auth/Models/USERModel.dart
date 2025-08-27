// Model class: USERModel
class USERModel {
  final int? id;
  final dynamic image;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final dynamic nationalId;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  const USERModel({this.id, this.image, this.name, this.phoneNumber, this.email, this.nationalId, this.isActive, this.createdAt, this.updatedAt, this.lastLogin});

  /// Parse JSON to model
  factory USERModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return USERModel(
    id: json['id'],
    image: json['image'],
    name: json['name'],
    phoneNumber: json['phone_number'],
    email: json['email'],
    nationalId: json['national_id'],
    isActive: json['is_active'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    lastLogin: json['last_login'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'national_id': nationalId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  @override
  String toString() => 'USERModel(id: $id, image: $image, name: $name, phoneNumber: $phoneNumber, email: $email, nationalId: $nationalId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, lastLogin: $lastLogin)';
}

// << MU-CODE | © 2025-07-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
