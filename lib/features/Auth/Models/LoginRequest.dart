// Request class: LoginRequest
class LoginRequest {
  final String? password;
  final String? phoneNumber;
  final String? email;

  const LoginRequest({this.password, this.phoneNumber, this.email});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone_number': phoneNumber,
      'email': email,
    };
  }

}

// << MU-CODE | © 2025-07-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
