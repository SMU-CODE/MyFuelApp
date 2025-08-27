import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: RegisterModel
class RegisterModel {
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? roleId;
  final String? createdAt;
  final String? userImage;
  final String? verifyCode;

  const RegisterModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.roleId,
    this.createdAt,
    this.userImage,
    this.verifyCode,
  });

  /// Parse JSON to model
  factory RegisterModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return RegisterModel(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
      phoneNumber: Parser.parseString(json['phone_number']),
      email: Parser.parseString(json['email']),
      roleId: Parser.parseString(json['role_id']),
      createdAt: Parser.parseString(json['created_at']),
      userImage: Parser.parseString(json['user_image']),
      verifyCode: Parser.parseString(json['verify_code']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'role_id': roleId,
      'created_at': createdAt,
      'user_image': userImage,
      'verify_code': verifyCode,
    };
  }

  @override
  String toString() =>
      'RegisterModel(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, roleId: $roleId, createdAt: $createdAt, userImage: $userImage)';
}

// << MU-CODE | © 2025-07-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
