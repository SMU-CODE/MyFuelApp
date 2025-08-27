import 'package:my_fuel/shared/helper/Parser.dart';

// Main model class: VehicleInfoModel
class VehicleInfoModel {
  final int? vehicleId;
  final String? qrCode;
  final String? ownerName;
  final String? vehicleType;
  final int? plateNumber;
  final String? engineNumber;
  final int? fuelTypeId;
  final String? fuelTypeName;
  final DateTime? lastRefuelDate;
  final bool? vehicleActive;
  final bool? isLinkedToUser;
  final String? linkStatus;

  const VehicleInfoModel({
    this.vehicleId,
    this.qrCode,
    this.ownerName,
    this.vehicleType,
    this.plateNumber,
    this.engineNumber,
    this.fuelTypeId,
    this.fuelTypeName,
    this.lastRefuelDate,
    this.vehicleActive,
    this.isLinkedToUser,
    this.linkStatus,
  });

  /// Parses API response data into model
  factory VehicleInfoModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for VehicleInfoModel');
    }
    return VehicleInfoModel(
      vehicleId: Parser.parseInt(json['vehicle_id']),
      qrCode: Parser.parseString(json['qr_code']),
      ownerName: Parser.parseString(json['owner_name']),
      vehicleType: Parser.parseString(json['vehicle_type']),
      plateNumber: Parser.parseInt(json['plate_number']),
      engineNumber: Parser.parseString(json['engine_number']),
      fuelTypeId: Parser.parseInt(json['fuel_type_id']),
      fuelTypeName: Parser.parseString(json['fuel_type_name']),
      lastRefuelDate: Parser.parseDateTime(json['last_refuel_date']),
      vehicleActive: Parser.parseBool(json['vehicle_active']),
      isLinkedToUser: Parser.parseBool(json['is_linked_to_user']),
      linkStatus: Parser.parseString(json['link_status']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'qr_code': qrCode,
      'owner_name': ownerName,
      'vehicle_type': vehicleType,
      'plate_number': plateNumber,
      'engine_number': engineNumber,
      'fuel_type_id': fuelTypeId,
      'fuel_type_name': fuelTypeName,
      'last_refuel_date': lastRefuelDate?.toIso8601String(),
      'vehicle_active': vehicleActive,
      'is_linked_to_user': isLinkedToUser,
      'link_status': linkStatus,
    };
  }

  @override
  String toString() {
    return 'VehicleInfoModel(vehicleId: $vehicleId, qrCode: $qrCode, ownerName: $ownerName, vehicleType: $vehicleType, plateNumber: $plateNumber, engineNumber: $engineNumber, fuelTypeId: $fuelTypeId, fuelTypeName: $fuelTypeName, lastRefuelDate: $lastRefuelDate, vehicleActive: $vehicleActive, isLinkedToUser: $isLinkedToUser, linkStatus: $linkStatus)';
  }
}

// << MU-CODE | © 2025-06-30 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
