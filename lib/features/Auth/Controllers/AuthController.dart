import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/features/Auth/Models/LoginModel.dart';
import 'package:my_fuel/features/Auth/Models/LoginRequest.dart';
import 'package:my_fuel/features/Auth/Models/RegisterRequest.dart';
import 'package:my_fuel/features/Auth/Models/RegisterModel.dart';
import 'package:my_fuel/features/Auth/Services/AuthService.dart';
import 'package:my_fuel/features/Auth/widgets/AuthForms.dart';
import 'package:my_fuel/shared/constant/AppKeys.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/Parser.dart';
import 'package:my_fuel/shared/notifications/NotificationService.dart';
import 'package:my_fuel/shared/services/StorageService.dart';
import 'package:my_fuel/shared/helper/InputValidator.dart';

enum AuthMode { signUp, login, logout, changePassword, restPassword, otp }

class AuthController extends GetxController {
  final RxBool _isLoading = false.obs;
  final Rx<AuthMode> _currentAuthMode = Rx<AuthMode>(AuthMode.login);
  set currentAuthMode(AuthMode mode) {
    if (!_isLoading.value) {
      _currentAuthMode.value = mode;
    }
  }

  AuthMode get currentAuthMode => _currentAuthMode.value;

  final RxBool _isAuthenticated = false.obs;
  final RxBool _isrest = false.obs;
  RxBool get isrest => _isrest;

  final Rxn<LoginModel> _loginModel = Rxn<LoginModel>();
  final Rxn<RegisterModel> _registerModel = Rxn<RegisterModel>();

  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordConfirmCtrl = TextEditingController();
  final TextEditingController _currPasswordConfirmCtrl =
      TextEditingController();

  final TextEditingController _currPasswordCtrl = TextEditingController();
  TextEditingController get currPasswordCtrl => _currPasswordCtrl;

  TextEditingController get currPasswordConfirmCtrl => _currPasswordConfirmCtrl;

  TextEditingController get newPasswordConfirmCtrl => _newPasswordConfirmCtrl;

  final TextEditingController _otpCtrl = TextEditingController();

  final AuthService _authService = AuthService();

  String errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';

  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _isAuthenticated.value;
  final RxInt otpTimer = 60.obs;

  TextEditingController get phoneController => _phoneCtrl;
  TextEditingController get otpController => _otpCtrl;
  TextEditingController get passwordController => _passwordCtrl;
  TextEditingController get usernameController => _usernameCtrl;
  TextEditingController get confirmPasswordController => _passwordConfirmCtrl;
  TextEditingController get newPasswordController => _newPasswordCtrl;

  final NotificationService _notificationService =
      Get.find<NotificationService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    _isAuthenticated.value = StorageService.checkLoginStatus();

    if (kDebugMode) {
      _phoneCtrl.text = "711711711";
      _passwordCtrl.text = "mu77";
      _passwordConfirmCtrl.text = _passwordCtrl.text;
      _usernameCtrl.text = "user1";
    }
  }

  @override
  void onClose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    _otpCtrl.dispose();
    super.onClose();
  }

  void toggleAuthMode({AuthMode? newMode}) {
    if (_isLoading.value) return;

    if (newMode != null) {
      _currentAuthMode.value = newMode;
      return;
    }

    _currentAuthMode.value = switch (_currentAuthMode.value) {
      AuthMode.login => AuthMode.signUp,
      AuthMode.signUp => AuthMode.login,
      AuthMode.changePassword => AuthMode.login,
      AuthMode.restPassword => AuthMode.login,
      AuthMode.logout => AuthMode.login,
      AuthMode.otp => AuthMode.login,
    };
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> login() async {
    final loginRequest = LoginRequest(
      phoneNumber: _phoneCtrl.text,
      password: _passwordCtrl.text,
    );

    _setLoading(true);
    try {
      final response = await _authService.login(loginRequest);
      errorMessage = response.message;
      if (response.success) {
        _loginModel.value = response.data;
        if (_loginModel.value?.token != null) {
          await loginSuccess();
        }
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginSuccess() async {
    await StorageService.write(AppKeys.authToken, _loginModel.value!.token!);
    await _storeUserData(_loginModel.value!);
    _isAuthenticated.value = true;
    AppRoutes.clearStackAndGoTo(AppRoutes.home);
    MuAlerts.showSuccess('تم تسجيل الدخول بنجاح');
  }

  Future<void> signUp() async {
    final signUpRequest = RegisterRequest(
      passwordConfirmation: _passwordConfirmCtrl.text,
      phoneNumber: _phoneCtrl.text,
      password: _passwordCtrl.text,
      name: _usernameCtrl.text,
    );

    _setLoading(true);
    try {
      final response = await _authService.signUpVerifyOtp(signUpRequest);
      errorMessage = response.message;
      if (response.statusCode == 200 || response.statusCode == 202) {
        _registerModel.value = response.data;
        final String myVerifyOtp = Parser.parseString(
          response.data!.verifyCode,
        );
        _isrest.value = false;
        _notificationService.showSimpleNotification(
          title: "وقودي",
          body: "كود التحقق هو:$myVerifyOtp",
        );
        startOtpTimer();

        _otpCtrl.text = myVerifyOtp;
        toggleAuthMode(newMode: AuthMode.otp);

        _currentAuthMode.value = AuthMode.otp;
        //  AppRoutes.goTo(AppRoutes.authVerifyOtp);
        MuAlerts.showSuccess(errorMessage);
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restPassword() async {
    _setLoading(true);
    try {
      final response = await _authService.getrestPassword(
        phoneNumber: phoneController.text,
        newPassword: newPasswordConfirmCtrl.text,
      );
      errorMessage = response.message;
      if (response.statusCode == 200 || response.statusCode == 202) {
        final String myVerifyOtp = Parser.parseString(
          response.data!.verifyCode,
        );
        _notificationService.showSimpleNotification(
          title: "وقودي",
          body: "كود تحقق تعين كلمة المرور  هو:$myVerifyOtp",
        );
        _isrest.value = true;
        startOtpTimer();

        _otpCtrl.text = myVerifyOtp;

        toggleAuthMode(newMode: AuthMode.otp);
        _currentAuthMode.value = AuthMode.otp;
        MuAlerts.showSuccess(errorMessage);
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerVerifyOtp() async {
    _setLoading(true);
    try {
      final otpRequest = RegisterRequest(
        passwordConfirmation: _passwordConfirmCtrl.text,
        phoneNumber: _phoneCtrl.text,
        password: _passwordCtrl.text,
        name: _usernameCtrl.text,
        otpCode: _otpCtrl.text,
      );

      final response = await _authService.signUpVerifyOtp(otpRequest);
      errorMessage = response.message;
      if (response.success) {
        MuAlerts.showSuccess(errorMessage);
        _currentAuthMode.value = AuthMode.login;
        AppRoutes.clearStackAndGoTo(AppRoutes.auth);
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      _otpCtrl.text = '';
      _setLoading(false);
    }
  }

  Future<void> restVerifyOtp() async {
    _setLoading(true);
    try {
      /*       final otpRequest =  RegisterRequest(
      passwordConfirmation: _newPasswordConfirmCtrl.text,
      phoneNumber: _phoneCtrl.text,
      password: _newPasswordCtrl.text,
      name: _usernameCtrl.text,
      otpCode: _otpCtrl.text
    ); */

      final response = await _authService.getrestPassword(
        phoneNumber: phoneController.text,
        newPassword: newPasswordConfirmCtrl.text,
        otpCode: _otpCtrl.text,
      );
      errorMessage = response.message;

      if (response.success) {
        MuAlerts.showSuccess(errorMessage);
        // toggleAuthMode(newMode: AuthMode.otp);

        _currentAuthMode.value = AuthMode.login;
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      MuAlerts.showError(errorMessage);
    } finally {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      _otpCtrl.text = '';
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    MuAlerts.showLoading(message: "جاري تسجيل الخروج");
    try {
      final response = await _authService.logout();
      errorMessage = response.message;
      if (response.success) {
        MuAlerts.showError(errorMessage);
      } else {
        MuAlerts.showError(errorMessage);
      }
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      await _clearState();
      _isAuthenticated.value = false;
      MuAlerts.hideLoading();
      MuAlerts.showSuccess('تم تسجيل الخروج بنجاح');
      AppRoutes.clearStackAndGoTo(AppRoutes.auth);

      _setLoading(false);
    }
  }

  void registerOrLoginTest() async {
    try {
      _isLoading.value = true;
      errorMessage = '';

      // التحقق من الصحة حسب نوع النموذج
      switch (_currentAuthMode.value) {
        case AuthMode.login:
          _validateLoginForm();
          await login();
          break;
        case AuthMode.signUp:
          _validateRegisterForm();
          await signUp();
          break;
        case AuthMode.changePassword:
          _validateChangePasswordForm();
          //  await changePassword();
          break;
        case AuthMode.restPassword:
          _validateResetPasswordForm();

          await restPassword();
          break;
        case AuthMode.otp:
          _validateOtpForm();
          _isrest.value ? await restVerifyOtp() : await registerVerifyOtp();

          break;
        case AuthMode.logout:
          await logout();
          break;
      }
    } catch (e) {
      errorMessage = 'حدث خطأ: ${e.toString()}';
      MuAlerts.showError(errorMessage);
    } finally {
      _isLoading.value = false;
    }
  }

  // دوال التحقق من الصحة لكل نموذج
  void _validateLoginForm() {
    final phoneError = InputValidator.validate(
      value: _phoneCtrl.text,
      types: [InputType.phone],
      fieldName: 'رقم الهاتف',
      minLength: 9,
    );

    final passwordError = InputValidator.validate(
      value: _passwordCtrl.text,
      types: [InputType.password],
      fieldName: 'كلمة المرور',
    );

    if (phoneError != null) throw phoneError;
    if (passwordError != null) throw passwordError;
  }

  void _validateRegisterForm() {
    final usernameError = InputValidator.validate(
      value: _usernameCtrl.text,
      types: [InputType.name],
      fieldName: 'اسم المستخدم',
    );

    final phoneError = InputValidator.validate(
      value: _phoneCtrl.text,
      types: [InputType.phone],
      fieldName: 'رقم الهاتف',
      minLength: 9,
    );

    final passwordError = InputValidator.validate(
      value: _passwordCtrl.text,
      types: [InputType.password],
      fieldName: 'كلمة المرور',
    );

    final confirmError = InputValidator.validate(
      value: _passwordConfirmCtrl.text,
      types: [InputType.confirmPassword],
      passwordToMatch: _passwordCtrl.text,
      fieldName: 'تأكيد كلمة المرور',
    );

    if (usernameError != null) throw usernameError;
    if (phoneError != null) throw phoneError;
    if (passwordError != null) throw passwordError;
    if (confirmError != null) throw confirmError;
  }

  void _validateChangePasswordForm() {
    final currentPasswordError = InputValidator.validate(
      value: _currPasswordCtrl.text,
      types: [InputType.password],
      fieldName: 'كلمة المرور الحالية',
    );

    final newPasswordError = InputValidator.validate(
      value: _newPasswordCtrl.text,
      types: [InputType.password],
      fieldName: 'كلمة المرور الجديدة',
    );

    final confirmError = InputValidator.validate(
      value: _passwordConfirmCtrl.text,
      types: [InputType.confirmPassword],
      passwordToMatch: _newPasswordCtrl.text,
      fieldName: 'تأكيد كلمة المرور',
    );

    if (currentPasswordError != null) throw currentPasswordError;
    if (newPasswordError != null) throw newPasswordError;
    if (confirmError != null) throw confirmError;
  }

  void _validateResetPasswordForm() {
    final phoneError = InputValidator.validate(
      value: _phoneCtrl.text,
      types: [InputType.phone],
      fieldName: 'رقم الهاتف',
      minLength: 9,
    );

    final newPasswordError = InputValidator.validate(
      value: _newPasswordCtrl.text,
      types: [InputType.password],
      fieldName: 'كلمة المرور الجديدة',
    );

    final confirmError = InputValidator.validate(
      value: newPasswordConfirmCtrl.text,
      types: [InputType.confirmPassword],
      passwordToMatch: _newPasswordCtrl.text,
      fieldName: 'تأكيد كلمة المرور',
    );

    if (phoneError != null) throw phoneError;
    if (newPasswordError != null) throw newPasswordError;
    if (confirmError != null) throw confirmError;
  }

  void _validateOtpForm() {
    final otpError = InputValidator.validate(
      value: _otpCtrl.text,
      types: [InputType.otp],
      fieldName: 'كود التحقق',
    );

    if (otpError != null) throw otpError;
  }

  // دالة بدء مؤقت OTP
  void startOtpTimer() {
    otpTimer.value = 60;

    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (otpTimer.value == 0) {
        timer.cancel();
      } else {
        otpTimer.value--;
        print(otpTimer.value);
      }
    });
  }

  Future<void> _storeUserData(LoginModel userModel) async {
    await StorageService.write(AppKeys.userId, userModel.id);
    await StorageService.write(AppKeys.userName, userModel.name);
    await StorageService.write(AppKeys.phoneNumber, userModel.phoneNumber);
    await StorageService.write(AppKeys.authToken, userModel.token);
  }

  Future<void> _clearState() async {
    try {
      _setLoading(true);
      await StorageService.clearAll();
      _loginModel.value = null;
      _registerModel.value = null;
      _isAuthenticated.value = false;
      _resetFields();
    } catch (e) {
      errorMessage = 'حدث خطأ، الرجاء المحاولة لاحقاً';
      MuAlerts.showError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  void _resetFields() {
    _phoneCtrl.clear();
    _passwordCtrl.clear();
    _usernameCtrl.clear();
    _passwordConfirmCtrl.clear();
    _newPasswordCtrl.clear();
    _otpCtrl.clear();
  }

  void disposeTemporaryResources() {
    if (Get.isDialogOpen == true) Get.back();
    if (Get.isSnackbarOpen == true) Get.closeAllSnackbars();
    _isLoading.value = false;
  }

  String get toggleButtonText {
    switch (currentAuthMode) {
      case AuthMode.login:
        return "ليس لديك حساب؟ سجل الآن";
      case AuthMode.otp:
        return "ليس لديك حساب؟ سجل الآن";
      case AuthMode.signUp:
        return "لديك حساب بالفعل؟ سجل دخول";
      case AuthMode.changePassword:
      case AuthMode.restPassword:
        return "العودة لتسجيل الدخول";
      case AuthMode.logout:
        return "تسجيل الدخول مرة أخرى";
    }
  }

  Widget get authForm {
    switch (currentAuthMode) {
      case AuthMode.login:
        return loginForm(this);
      case AuthMode.signUp:
        return registerForm(this);
      case AuthMode.changePassword:
        return changePasswordForm(this);
      case AuthMode.restPassword:
        return restPasswordForm(this);
      case AuthMode.logout:
        return logoutConfirmation(this);
      case AuthMode.otp:
        return otpForm(this);
    }
  }

  IconData get authModeIcon {
    switch (currentAuthMode) {
      case AuthMode.login:
        return Icons.person;
      case AuthMode.signUp:
        return Icons.person_add;
      case AuthMode.changePassword:
        return Icons.lock_reset;
      case AuthMode.restPassword:
        return Icons.password;
      case AuthMode.logout:
        return Icons.logout;
      case AuthMode.otp:
        return Icons.verified_user;
    }
  }

  String get authModeText {
    switch (currentAuthMode) {
      case AuthMode.login:
        return "تسجيل الدخول";
      case AuthMode.signUp:
        return "إنشاء حساب";
      case AuthMode.changePassword:
        return "تغيير كلمة المرور";
      case AuthMode.restPassword:
        return "إعادة تعيين كلمة المرور";
      case AuthMode.logout:
        return "تسجيل الخروج";
      case AuthMode.otp:
        return "التحقق من الرمز";
    }
  }

  List<Color> get authModeColors {
    switch (currentAuthMode) {
      case AuthMode.login:
        return [const Color(0xFF114B5F), const Color(0xFF456990)];
      case AuthMode.signUp:
        return [const Color(0xFF1A936F), const Color(0xFF88D498)];
      case AuthMode.changePassword:
        return [const Color(0xFF6A4C93), const Color(0xFF8A5A44)];
      case AuthMode.restPassword:
        return [const Color(0xFF4A6FA5), const Color(0xFF166088)];
      case AuthMode.logout:
        return [const Color(0xFFD64045), const Color(0xFFE9FFF9)];
      case AuthMode.otp:
        return [const Color(0xFF5E35B1), const Color(0xFF3949AB)];
    }
  }

  Color get authPrimaryColor {
    switch (currentAuthMode) {
      case AuthMode.login:
        return const Color(0xFF1A936F);
      case AuthMode.signUp:
        return const Color(0xFF114B5F);
      case AuthMode.changePassword:
        return const Color(0xFF6A4C93);
      case AuthMode.restPassword:
        return const Color(0xFF4A6FA5);
      case AuthMode.logout:
        return const Color(0xFFD64045);
      case AuthMode.otp:
        return const Color(0xFF5E35B1);
    }
  }

  ValueKey get formKey {
    switch (currentAuthMode) {
      case AuthMode.login:
        return const ValueKey('login_form_key');
      case AuthMode.signUp:
        return const ValueKey('register_form_key');
      case AuthMode.changePassword:
        return const ValueKey('change_password_key');
      case AuthMode.restPassword:
        return const ValueKey('rest_password_container');
      case AuthMode.logout:
        return const ValueKey('logout_key');
      case AuthMode.otp:
        return const ValueKey('otp_form_key');
    }
  }
}
