import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/widgets/CustomTextField.dart';
import 'package:my_fuel/shared/widgets/MuTextField.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GetBuilder<AuthController>(
        builder:
            (controller) => Obx(() {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: controller.authModeColors,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildHeader(controller),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 800),
                              switchInCurve: Curves.fastOutSlowIn,
                              switchOutCurve: Curves.fastOutSlowIn.flipped,
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    axis: Axis.vertical,
                                    axisAlignment: -1,
                                    child: child,
                                  ),
                                );
                              },
                              child: controller.authForm,
                            ),
                            Column(
                              children: [
                                _authButton(controller),
                                GetBuilder<AuthController>(
                                  builder:
                                      (controller) => TextButton(
                                        onPressed: controller.toggleAuthMode,
                                        child: Text(
                                          controller.toggleButtonText,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                ),
                                if (controller.currentAuthMode ==
                                    AuthMode.login)
                                  TextButton(
                                    onPressed:
                                        () => {
                                          controller.toggleAuthMode(
                                            newMode: AuthMode.restPassword,
                                          ),
                                        },
                                    child: Text(
                                      "نسيت كلمة السر...؟",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  SizedBox _authButton(AuthController controller) {
    return SizedBox(
      width: Get.width * 0.7,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.authPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          controller.registerOrLoginTest();
        },
        child:
            controller.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  controller.authModeText,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
      ),
    );
  }

  Widget _buildHeader(AuthController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => {}, // controller.toggleAuthMode,
          child: Container(
            width: Get.width * 0.25,
            height: Get.width * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: controller.authPrimaryColor, width: 2),
            ),
            child: IconButton(
              icon: Icon(
                controller.authModeIcon,
                size: Get.width * 0.1,
                color: controller.authPrimaryColor,
              ),
              onPressed: () => showIp(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          controller.authModeText,

          style: TextStyle(fontSize: AppSize.mediumFont, color: Colors.white),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

showIp() {
  final ipFieldCtrl = TextEditingController(text: "10.28.229.212");
  return MuAlerts.showCustomDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: AppSize.verticalSpacing),
        Text(
          "في وضع التطوير فقط غير ال اي بي من هنا",
          style: TextStyle(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSize.verticalSpacing),
        CustomTextField(
          label: 'مثل:10.28.229.212',
          controller: ipFieldCtrl,
          icon: Icons.add_ic_call,
          isLoginMode: false,
          hintText: '',
        ),
        TextButton(
          onPressed: () {
            {
              ApiConstants.setWifIp(ipFieldCtrl.text);

              Get.back();
            }
          },
          child: Text(
            'تغير',
            style: TextStyle(
              color: AppColors.info,
              fontSize: AppSize.titleFont,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
