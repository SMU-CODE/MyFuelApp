import 'package:get/get.dart';
import 'package:my_fuel/features/Auth/Models/PermissionsModel.dart';
import 'package:my_fuel/features/Auth/Services/PermissionsServices.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';

class PermissionsController extends GetxController {
  final RxBool _isLoading = false.obs;

  final Rx<PermissionsModel?> _permissions = Rx<PermissionsModel?>(null);
  final RxString _roleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('>> PermissionsController initialized');
    fetchPermissions(); // استدعاء عند التهيئة
  }

  Future<void> fetchPermissions() async {
    _setLoading(true);
    print('>> fetchPermissions started');

    try {
      final result = await PermissionsServices.getRolePermissionsByRoleId();

      if (result.success) {
        _permissions.value = result.data;
        _roleId.value = result.data?.role?.id?.toString() ?? '';

        print('>> Permissions fetched. Role ID: ${_roleId.value}');

        if (_roleId.value.isEmpty) {
          MuAlerts.showError('لم يتم تحديد الدور الخاص بالمستخدم.');
        }
      } else {
        MuAlerts.showError(result.message);
      }
    } catch (e, stack) {
      print('>> Error fetching permissions: $e\n$stack');
      MuAlerts.showError('حدث خطأ أثناء محاولة جلب الصلاحيات.');
    } finally {
      _setLoading(false);
    }
  }

  PermissionsModel? get permissions => _permissions.value;
  bool get isLoading => _isLoading.value;

  bool hasRole(String id) => _roleId.value == id;

  void _setLoading(bool val) {
    if (_isLoading.value != val) {
      _isLoading.value = val;
    }
  }
}
