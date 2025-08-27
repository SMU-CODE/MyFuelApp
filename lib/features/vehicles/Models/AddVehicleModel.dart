import 'package:my_fuel/shared/helper/Parser.dart';

// Main model class: AddVehicleModel
class AddVehicleModel {
  final int? vehicleId;
  final String? qrCode;
  final int? plateNumber;
  final String? ownerName;
  final int? fuelTypeId;

  const AddVehicleModel({
    this.vehicleId,
    this.qrCode,
    this.plateNumber,
    this.ownerName,
    this.fuelTypeId,
  });

  /// Parses API response data into model
  factory AddVehicleModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for AddVehicleModel');
    }
    return AddVehicleModel(
      vehicleId: Parser.parseInt(json['vehicle_id']),
      qrCode: Parser.parseString(json['qr_code']),
      plateNumber: Parser.parseInt(json['plate_number']),
      ownerName: Parser.parseString(json['owner_name']),
      fuelTypeId: Parser.parseInt(json['fuel_type_id']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'qr_code': qrCode,
      'plate_number': plateNumber,
      'owner_name': ownerName,
      'fuel_type_id': fuelTypeId,
    };
  }

  @override
  String toString() {
    return 'AddVehicleModel(vehicleId: $vehicleId, qrCode: $qrCode, plateNumber: $plateNumber, ownerName: $ownerName, fuelTypeId: $fuelTypeId)';
  }
}

// << MU-CODE | © 2025-06-16 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
