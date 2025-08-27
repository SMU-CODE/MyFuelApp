// camera_controller.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraAccessController extends GetxController {
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  Rx<XFile?> capturedImage = Rx<XFile?>(null);
  Rx<FlashMode> currentFlashMode = FlashMode.off.obs;
  RxBool isCameraInitialized = false.obs;
  RxInt imageCounter = 1.obs;
  RxInt startingNumber = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _askForStartingNumber();
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }

  Future<void> _askForStartingNumber() async {
    String? input = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Set Starting Number'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter starting number for images',
            hintText: 'e.g., 1, 2, 3...',
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed:
                () => Get.back(result: Get.find<TextEditingController>().text),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (input != null && input.isNotEmpty) {
      startingNumber.value = int.tryParse(input) ?? 1;
    } else {
      startingNumber.value = 1;
    }
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photosStatus.isGranted) {
      _showPermissionDeniedMessage();
      return;
    }

    try {
      cameras.value = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController.value = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        cameraController.value!.addListener(() {
          if (cameraController.value!.value.hasError) {
            _showMessage(
              'Camera error: ${cameraController.value!.value.errorDescription}',
            );
          }
        });

        await cameraController.value!.initialize();
        isCameraInitialized.value = true;
      } else {
        _showMessage('No cameras available.');
      }
    } on CameraException catch (e) {
      _showMessage('Camera initialization error: $e');
    } catch (e) {
      _showMessage('An unexpected error occurred: $e');
    }
  }

  void _showPermissionDeniedMessage() {
    Get.snackbar(
      'Permission Denied',
      'Camera and photo permissions are required to use this feature.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          openAppSettings();
          Get.back();
        },
        child: const Text('Open Settings'),
      ),
    );
  }

  void _showMessage(String message) {
    Get.snackbar('Camera', message, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> toggleCamera() async {
    if (cameras.length < 2) {
      _showMessage('No other cameras available to switch to.');
      return;
    }

    final newCamera =
        cameraController.value!.description == cameras[0]
            ? cameras[1]
            : cameras[0];

    await cameraController.value?.dispose();

    cameraController.value = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    cameraController.value!.addListener(() {
      if (cameraController.value!.value.hasError) {
        _showMessage(
          'Camera error: ${cameraController.value!.value.errorDescription}',
        );
      }
    });

    try {
      await cameraController.value!.initialize();
    } on CameraException catch (e) {
      _showMessage('Camera initialization error: $e');
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController.value == null ||
        !cameraController.value!.value.isInitialized) {
      return;
    }
    try {
      switch (currentFlashMode.value) {
        case FlashMode.off:
          await cameraController.value!.setFlashMode(FlashMode.auto);
          currentFlashMode.value = FlashMode.auto;
          _showMessage('Flash: Auto');
          break;
        case FlashMode.auto:
          await cameraController.value!.setFlashMode(FlashMode.always);
          currentFlashMode.value = FlashMode.always;
          _showMessage('Flash: On');
          break;
        case FlashMode.always:
          await cameraController.value!.setFlashMode(FlashMode.off);
          currentFlashMode.value = FlashMode.off;
          _showMessage('Flash: Off');
          break;
        case FlashMode.torch:
          await cameraController.value!.setFlashMode(FlashMode.off);
          currentFlashMode.value = FlashMode.off;
          _showMessage('Flash: Off');
          break;
      }
    } on CameraException catch (e) {
      _showMessage('Failed to change flash mode: $e');
    }
  }

  Future<void> takePicture() async {
    if (cameraController.value == null ||
        !cameraController.value!.value.isInitialized) {
      _showMessage('Camera not ready.');
      return;
    }

    try {
      final image = await cameraController.value!.takePicture();
      capturedImage.value = image;
      await _saveImageAutomatically(image);
    } on CameraException catch (e) {
      _showMessage('Failed to capture image: $e');
    }
  }

  Future<void> _saveImageAutomatically(XFile imageFile) async {
    String fileName =
        'image_${startingNumber.value + imageCounter.value - 1}.png';

    try {
      final result = await ImageGallerySaverPlus.saveFile(
        imageFile.path,
        name: fileName,
        isReturnPathOfIOS: true,
      );

      if (result['isSuccess'] == true) {
        _showMessage('Image saved as: $fileName');
        imageCounter.value++;
      } else {
        _showMessage('Failed to save image.');
      }
    } catch (e) {
      _showMessage('Error while saving image: $e');
    } finally {
      capturedImage.value = null;
    }
  }

  Future<void> saveImageManually(XFile imageFile) async {
    String suggestedName =
        'image_${startingNumber.value + imageCounter.value - 1}.png';
    TextEditingController nameController = TextEditingController(
      text: suggestedName,
    );

    await Get.dialog(
      AlertDialog(
        title: const Text('Save Image'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'File name'),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            child: const Text('حفظ'),
            onPressed: () async {
              String fileName = nameController.text.trim();
              if (fileName.isEmpty) {
                fileName = suggestedName;
              }

              try {
                final result = await ImageGallerySaverPlus.saveFile(
                  imageFile.path,
                  name: fileName,
                  isReturnPathOfIOS: true,
                );
                if (result['isSuccess'] == true) {
                  _showMessage('Image saved as: $fileName');
                  imageCounter.value++;
                } else {
                  _showMessage('Failed to save image.');
                }
              } catch (e) {
                _showMessage('Error while saving image: $e');
              }
              Get.back();
              capturedImage.value = null;
            },
          ),
        ],
      ),
    );
  }

  IconData getFlashIcon() {
    switch (currentFlashMode.value) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraAccessController controller = Get.put(CameraAccessController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Image'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(controller.getFlashIcon()),
              onPressed: controller.toggleFlash,
            ),
          ),
          Obx(
            () =>
                controller.cameras.length > 1
                    ? IconButton(
                      icon: const Icon(Icons.cameraswitch),
                      onPressed: controller.toggleCamera,
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.capturedImage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.file(File(controller.capturedImage.value!.path)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Image'),
                      onPressed:
                          () => controller.saveImageManually(
                            controller.capturedImage.value!,
                          ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      onPressed: () {
                        controller.capturedImage.value = null;
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (controller.cameraController.value != null &&
            controller.isCameraInitialized.value &&
            controller.cameraController.value!.value.isInitialized) {
          return Center(
            child: CameraPreview(controller.cameraController.value!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
      floatingActionButton: Obx(
        () =>
            controller.capturedImage.value == null
                ? FloatingActionButton(
                  onPressed: controller.takePicture,
                  child: const Icon(Icons.camera_alt),
                )
                : const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
