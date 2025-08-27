import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_fuel/shared/constant/app_fonts.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared/widgets/app_text_styles.dart.dart';
import 'package:my_fuel/shared/theme/app_size.dart';
import 'package:my_fuel/shared/theme/app_colors.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeDisplayScreen extends StatefulWidget {
  final String qrCodeData;

  const QRCodeDisplayScreen({super.key, required this.qrCodeData});

  @override
  State<QRCodeDisplayScreen> createState() => _QRCodeDisplayScreenState();
}

class _QRCodeDisplayScreenState extends State<QRCodeDisplayScreen> {
  bool _isSaving = false;
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: _buildBody(context, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'رمز الاستجابة السريعة',
        style: AppTextStyles.appBarTitle.copyWith(color: AppColors.onPrimary),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: AppSize.elevationNone,
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundInverse.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: AppSize.pagePadding,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppSize.spacingLarge),
                      _buildQRCodeCard(theme),
                      SizedBox(height: AppSize.spacingExtraLarge),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeCard(ThemeData theme) {
    return Card(
      elevation: AppSize.elevationMedium,
      shape: RoundedRectangleBorder(borderRadius: AppSize.borderRadiusLarge),
      color: AppColors.surface,
      child: Padding(
        padding: AppSize.paddingAll,
        child: Column(
          children: [
            SizedBox(height: AppSize.spacingMedium),
            _buildQRImage(),
            SizedBox(height: AppSize.spacingMedium),
            _buildQRDataText(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildQRImage() {
    return RepaintBoundary(
      key: _qrKey,
      child: Container(
        padding: EdgeInsets.all(AppSize.spacingMedium),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: AppSize.borderRadiusMedium,
          color: AppColors.onPrimary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: PrettyQrView.data(
          data: widget.qrCodeData,
          errorCorrectLevel: QrErrorCorrectLevel.H,
          decoration: const PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(),
            quietZone: PrettyQrQuietZone.modules(2),
          ),
        ),
      ),
    );
  }

  Widget _buildQRDataText(ThemeData theme) {
    return SelectableText(
      widget.qrCodeData,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurface.withValues(alpha: 0.8),
      ),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon:
                _isSaving
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                    : Icon(
                      Icons.save_alt_rounded,
                      size: AppSize.iconMedium,
                      color: AppColors.onPrimary,
                    ),
            label: Text(
              _isSaving ? 'جاري الحفظ...' : 'حفظ الرمز في المعرض',
              style: AppTextStyles.button.copyWith(color: AppColors.onPrimary),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: EdgeInsets.symmetric(vertical: AppSize.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: AppSize.borderRadiusLarge,
              ),
              elevation: AppSize.elevationMedium,
            ),
            onPressed: _isSaving ? null : () => _saveQRCodeToGallery(context),
          ),
        ),
        SizedBox(height: AppSize.spacingSmall),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'العودة',
            style: AppTextStyles.button.copyWith(
              color: AppColors.primary,
              fontWeight: AppFont.wmedium,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveQRCodeToGallery(BuildContext context) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      setState(() => _isSaving = true);
      try {
        MuAlerts.showLoading();
        final imageBytes = await _generateQRImageBytes();
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: 'QR_Code',
        );

        if (result['isSuccess'] == true) {
          MuAlerts.hideLoading();
          MuAlerts.showSuccess('تم حفظ الرمز بنجاح');
        } else {
          throw Exception(result['errorMessage']?.toString() ?? 'فشل الحفظ');
        }
      } on PlatformException catch (e, stack) {
        MuAlerts.hideLoading();
        MuLogger.exception(e, stack, 'Permission error saving QR code');
        MuAlerts.showError('يجب منح إذن الوصول إلى المعرض أولاً');
      } catch (e, stack) {
        MuAlerts.hideLoading();
        MuLogger.exception(e, stack, 'Error saving QR code');
        MuAlerts.showError('حدث خطأ أثناء حفظ الرمز: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    } else {
      MuAlerts.showError('يجب منح إذن الوصول إلى المعرض أولاً');
    }
  }

  Future<Uint8List> _generateQRImageBytes() async {
    try {
      final RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      const margin = 40.0;
      final newWidth = image.width + margin.toInt() * 2;
      final newHeight = image.height + margin.toInt() * 2;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      canvas.drawRect(
        Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        Paint()..color = Colors.white,
      );

      canvas.drawImage(image, Offset(margin, margin), Paint());

      final newPicture = recorder.endRecording();
      final newImage = await newPicture.toImage(newWidth, newHeight);

      /*   final textPainter = TextPainter(
        text: TextSpan(
          text: widget.qrCodeData,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ); */

      //   textPainter.layout(maxWidth: newWidth.toDouble() - margin);

      final textImageRecorder = ui.PictureRecorder();
      final textCanvas = Canvas(textImageRecorder);
      textCanvas.drawImage(newImage, Offset.zero, Paint());
      /*  textPainter.paint(
        textCanvas,
        Offset(margin, newHeight.toDouble() - textPainter.height - margin / 2),
      ); */

      final finalPicture = textImageRecorder.endRecording();
      final finalImage = await finalPicture.toImage(
        newWidth,
        (newHeight + margin / 2).toInt(),
      );

      final byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) throw Exception('Failed to convert image to bytes');

      image.dispose();
      newPicture.dispose();
      newImage.dispose();
      finalPicture.dispose();
      finalImage.dispose();

      return byteData.buffer.asUint8List();
    } catch (e, stack) {
      MuLogger.exception(e, stack, 'Failed to generate QR image');
      throw Exception('Failed to generate QR image: $e');
    }
  }
}
