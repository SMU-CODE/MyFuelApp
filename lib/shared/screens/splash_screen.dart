import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:my_fuel/AppRoutes.dart';
import 'package:my_fuel/features/Auth/Controllers/AuthController.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedLogo(),
                SizedBox(height: AppSize.spacingLarge),
                _buildAppTitle(),
                SizedBox(height: AppSize.spacingMedium),
                _buildAppSubtitle(),
                SizedBox(height: AppSize.spacingLarge * 2),
                _buildProgressIndicator(),
              ],
            ),
          ),
          _buildDecorativeElements(),
        ],
      ),
    );
  }

  void _initializeAndNavigate() async {
    try {
      // انتظار بسيط لعرض الأنيميشن بسلاسة
      await Future.delayed(const Duration(milliseconds: 700));

      // تهيئة اللغة العربية للتواريخ
     
      // مصادقة المستخدم
      final authController = Get.find<AuthController>();
      final isLoggedIn = authController.isAuthenticated; // تحقق من تسجيل الدخول

      // التوجيه حسب الحالة
      if (isLoggedIn) {
        AppRoutes.clearStackAndGoTo(AppRoutes.home);
      } else {
        AppRoutes.clearStackAndGoTo(AppRoutes.auth);
      }
    } catch (e, st) {
      MuLogger.exception("فشل في تهيئة خدمات التطبيق أو الانتقال", st);
      Get.offAllNamed(AppRoutes.error, arguments: {'error': e.toString()});
    }
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
      ),
      child: CustomPaint(painter: _SplashScreenPainter()),
    );
  }

  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      onEnd: _initializeAndNavigate,
      child: SvgPicture.asset(
        'assets/images/fuel_icon.svg',
        width: AppSize.scaleWidth(150),
        height: AppSize.scaleHeight(150),
      ),
    );
  }

  Widget _buildAppTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInCubic,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Text(
        'تطبيق وقودي',
        style: AppTextStyles.heading1.copyWith(
          color: Colors.white,
          fontSize: AppSize.scaleFont(32),
        ),
      ),
    );
  }

  Widget _buildAppSubtitle() {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastOutSlowIn,
      builder: (context, value, child) {
        return Transform.translate(offset: value, child: child);
      },
      child: Text(
        'أفضل حل لإدارة استهلاك الوقود',
        style: AppTextStyles.bodyLarge.copyWith(
          color: Colors.white.withAlpha(220),
          fontFamily: AppFont.amiriFont,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      width: AppSize.scaleWidth(50),
      height: AppSize.scaleHeight(50),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(200)),
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned(
      bottom: AppSize.screenHeight * 0.1,
      right: AppSize.screenWidth * 0.1,
      child: Opacity(
        opacity: 0.1,
        child: SvgPicture.asset(
          'assets/images/fuel_icon.svg',
          width: AppSize.scaleWidth(200),
          height: AppSize.scaleHeight(200),
        ),
      ),
    );
  }
}

class _SplashScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withAlpha(12)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.1),
      size.width * 0.15,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      size.width * 0.1,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.8),
      size.width * 0.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
