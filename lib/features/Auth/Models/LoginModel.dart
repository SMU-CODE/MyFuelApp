// Model class: LoginModel
class LoginModel {
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? token;
  final String? email;

  const LoginModel({this.id, this.name, this.phoneNumber, this.token, this.email});

  /// Parse JSON to model
  factory LoginModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return LoginModel(
    id: json['id'],
    name: json['name'],
    phoneNumber: json['phone_number'],
    token: json['token'],
    email: json['email'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'token': token,
      'email': email,
    };
  }

  @override
  String toString() => 'LoginModel(id: $id, name: $name, phoneNumber: $phoneNumber, token: $token, email: $email)';
}

// << MU-CODE | © 2025-07-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
