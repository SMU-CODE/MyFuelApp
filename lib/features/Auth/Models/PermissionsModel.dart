import 'package:my_fuel/shared/helper/Parser.dart';

/// Model class: PermissionsModel
class PermissionsModel {
  final RoleModel? role;
  final List<String>? permissions;

  const PermissionsModel({this.role, this.permissions});

  /// Parse JSON to model
  factory PermissionsModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return PermissionsModel(
      role: json['role'] is Map<String, dynamic>
          ? RoleModel.fromJson(json['role'])
          : null,
      permissions: Parser.parseList<String>(
        json['permissions'],
        (i) => Parser.parseString(i),
      ),
    );
  }

  @override
  String toString() =>
      'PermissionsModel(role: $role, permissions: $permissions)';
}

/// Model class: RoleModel
class RoleModel {
  final int? id;
  final String? name;
  final String? key;

  const RoleModel({this.id, this.name, this.key});

  /// Parse JSON to model
  factory RoleModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return RoleModel(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
      key: Parser.parseString(json['key']),
    );
  }

  @override
  String toString() => 'RoleModel(id: $id, name: $name, key: $key)';
}

// << MU-CODE | © 2025-07-29 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
