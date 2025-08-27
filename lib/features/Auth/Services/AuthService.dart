// features/Auth/Services/AuthService.dart

import 'package:my_fuel/features/Auth/Models/LoginModel.dart';
import 'package:my_fuel/features/Auth/Models/LoginRequest.dart';
import 'package:my_fuel/features/Auth/Models/RegisterModel.dart';
import 'package:my_fuel/features/Auth/Models/RegisterRequest.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/EmptyResponseModel.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';

/// AuthService handles all auth-related API requests.
class AuthService {
  /// Login with phone and password
  Future<ApiResponse<LoginModel>> login(LoginRequest request) async {
    final api = await ApiService.getInstance();

    return api.post<LoginModel>(
      ApiConstants.auth.login,
      body: request.toJson(),
      fromJson: LoginModel.fromJson,
    );
  }

  /// OTP And Register a new user
  Future<ApiResponse<RegisterModel>> signUpVerifyOtp(
    RegisterRequest request,
  ) async {
    final api = await ApiService.getInstance();

    return api.post<RegisterModel>(
      ApiConstants.auth.register,
      body: request.toJson(),
      fromJson: RegisterModel.fromJson,
    );
  }

  /// Logout current user
  Future<ApiResponse<EmptyResponseModel>> logout() async {
    final api = await ApiService.getInstance();

    return api.post(
      ApiConstants.auth.logout,
     fromJson:(json) =>  EmptyResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<EmptyResponseModel>> restPassword(
   { String? phoneNumber, 
    String? otpCode,
    String? newPassword,
  }) async {
    final api = await ApiService.getInstance();

    return api.post(
      ApiConstants.auth.passwordReset,
      body: RegisterRequest(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
        password: newPassword,
      ),
      fromJson:(json) =>  EmptyResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<EmptyResponseModel>> changePassword() async {
    final api = await ApiService.getInstance();

    return api.post(
      ApiConstants.auth.passwordChange,
       fromJson:(json) =>  EmptyResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<EmptyResponseModel>> getrestPassword({
    String? phoneNumber,
    String? otpCode,
    String? newPassword,
  }) async {
    final api = await ApiService.getInstance();

    final queryParams = {
      'phone_number': phoneNumber,
      if (otpCode != null && otpCode.isNotEmpty) 'otp_code': otpCode,
      if (newPassword != null && newPassword.isNotEmpty)
        'password': newPassword,
      'type': 'phone',
      'channel': 'sms',
    };

    final response = await api.get(
      ApiConstants.auth.passwordReset,
      query: queryParams,
     fromJson:(json) =>  EmptyResponseModel.fromJson(json),
    );
    return response;
  }
}
