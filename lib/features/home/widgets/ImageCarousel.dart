import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/slides fuels/1.jpg',
      'assets/slides fuels/2.jpg',
      'assets/slides fuels/3.jpg',
      'assets/slides fuels/4.jpg',
      'assets/slides fuels/5.jpg',
      'assets/slides fuels/6.jpg',
      'assets/slides fuels/7.jpg',
      'assets/slides fuels/8.jpg',
      'assets/slides fuels/9.jpg',
      'assets/slides fuels/10.jpg',
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imagePath in imagePaths) {
        precacheImage(AssetImage(imagePath), context);
      }
    });

    return SizedBox(
      height: AppSize.screenHeight / 2.6,
      width: double.infinity,
      child: AnotherCarousel(
        images: imagePaths.map((path) => AssetImage(path)).toList(),
        autoplay: true,
        autoplayDuration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 800),
        animationCurve: Curves.easeInOut,
        dotSize: 5.0,
        dotSpacing: 25.0,
        dotColor: AppColors.background,
        dotIncreasedColor: AppColors.primary,
        dotBgColor: AppColors.surface.withAlpha(6),
        boxFit: BoxFit.cover,
        showIndicator: true,
        moveIndicatorFromBottom: 10.0,
        borderRadius: false,
        noRadiusForIndicator: true,
      ),
    );
  }
}
