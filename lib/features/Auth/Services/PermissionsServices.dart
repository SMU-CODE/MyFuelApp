import 'package:my_fuel/features/Auth/Models/PermissionsModel.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';

class PermissionsServices {
  static Future<ApiResponse<PermissionsModel>> getRolePermissionsByRoleId(
 
  ) async {
    final api = await ApiService.getInstance();

    final result = await api.get<PermissionsModel>(
      ApiConstants.userRole.getUserRoleAndPermissions(
        
      ),
      fromJson: PermissionsModel.fromJson,
    );

    return result;
  }
}
