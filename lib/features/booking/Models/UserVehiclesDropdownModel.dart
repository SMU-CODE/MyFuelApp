import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: UserVehiclesDropdownModel
class UserVehiclesDropdownModel {
  final int? vehicleId;
  final String? qrCode;
  final String? vehicleDetails;

  const UserVehiclesDropdownModel({this.vehicleId, this.qrCode, this.vehicleDetails});

  /// Parse JSON to model
  factory UserVehiclesDropdownModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return UserVehiclesDropdownModel(
    vehicleId: Parser.parseInt(json['vehicle_id']),
    qrCode: Parser.parseString(json['qr_code']),
    vehicleDetails: Parser.parseString(json['vehicle_details']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'qr_code': qrCode,
      'vehicle_details': vehicleDetails,
    };
  }

  @override
  String toString() => 'UserVehiclesDropdownModel(vehicleId: $vehicleId, qrCode: $qrCode, vehicleDetails: $vehicleDetails)';
}

// << MU-CODE | © 2025-07-17 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
