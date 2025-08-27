import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );
  bool isTorchOn = false;
  bool isCodeValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ماسح رمز QR للمركبة',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: AppFont.wbold,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? scannedCode = barcodes.first.rawValue;
                if (scannedCode != null && scannedCode.startsWith("QR")) {
                  setState(() => isCodeValid = true);
                  Get.back(result: scannedCode);
                } else {
                  setState(() => isCodeValid = false);
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() => isCodeValid = true);
                    }
                  });
                }
              }
            },
          ),
          Center(child: _buildScannerFrame(context)),
          Positioned(
            bottom: AppSize.spacingExtraLarge,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (!isCodeValid)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSize.spacingMedium),
                    child: Text(
                      'رمز QR غير صالح. يرجى مسح رمز QR خاص بالمركبة.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: AppFont.wbold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _buildTorchButton(),
              ],
            ),
          ),
          Positioned(
            top: AppSize.spacingExtraLarge,
            left: 0,
            right: 0,
            child: Text(
              'امسح رمز QR الخاص بالمركبة',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: AppFont.wbold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        border: Border.all(
          color: isCodeValid ? AppColors.primary : Colors.redAccent,
          width: 5,
        ),
        borderRadius: AppSize.borderRadiusLarge,
      ),
      child: ClipRRect(
        borderRadius: AppSize.borderRadiusLarge,
        child: Image.asset(
          'assets/images/qr_frame_overlay.png',
          fit: BoxFit.cover,
          color: isCodeValid ? null : Colors.red.withValues(alpha: 0.3),
          colorBlendMode: BlendMode.srcOver,
          errorBuilder: (context, error, stackTrace) => Container(),
        ),
      ),
    );
  }

  Widget _buildTorchButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() => isTorchOn = !isTorchOn);
        _controller.toggleTorch();
      },
      backgroundColor: AppColors.primary,
      child: Icon(
        isTorchOn ? Icons.flash_off_rounded : Icons.flash_on_rounded,
        color: AppColors.onPrimary,
        size: AppSize.iconMedium,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
