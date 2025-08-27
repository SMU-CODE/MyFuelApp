import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Controllers/PermissionsController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionsController());
  }
}
