// Request class: RegisterRequest
class RegisterRequest {
  final String? name;
  final String? phoneNumber;
  final String? password;
  final String? passwordConfirmation;
  final String? otpCode;
  final String? channel;
  final String? type;
  final String? email;

  const RegisterRequest({
    this.name,
    this.phoneNumber,
    this.password,
    this.passwordConfirmation,
    this.otpCode,
    this.email,
    // Add default values for type and channel directly in the constructor
    // If not provided, 'type' defaults to 'phone' and 'channel' to 'sms'
    this.type = 'phone', // Default type is 'phone'
    this.channel = 'sms', // Default channel is 'sms'
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'otp_code': otpCode,
      'channel': channel,
      'type': type,
      'email': email,
    };
  }
}

// << MU-CODE | © 2025-07-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
