import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: VehicleWithInfoModel
class VehicleWithInfoModel {
  final int? id;
  final String? qrCode;
  final String? ownerName;
  final String? type;
  final int? fuelTypeId;
  final String? engineNumber;
  final String? plateNumber;
  final DateTime? lastRefuelDate;
  final bool? isActive;
  final String? ownerPhone;
  final String? modelYear;
  final String? color;
  final VehicleWithInfoModelFuelType? fuelType;

  const VehicleWithInfoModel({this.id, this.qrCode, this.ownerName, this.type, this.fuelTypeId, this.engineNumber, this.plateNumber, this.lastRefuelDate, this.isActive, this.ownerPhone, this.modelYear, this.color, this.fuelType});

  /// Parse JSON to model
  factory VehicleWithInfoModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return VehicleWithInfoModel(
    id: Parser.parseInt(json['id']),
    qrCode: Parser.parseString(json['qr_code']),
    ownerName: Parser.parseString(json['owner_name']),
    type: Parser.parseString(json['type']),
    fuelTypeId: Parser.parseInt(json['fuel_type_id']),
    engineNumber: Parser.parseString(json['engine_number']),
    plateNumber: Parser.parseString(json['plate_number']),
    lastRefuelDate: Parser.parseDateTime(json['last_refuel_date']),
    isActive: Parser.parseBool(json['is_active']),
    ownerPhone: Parser.parseString(json['owner_phone']),
    modelYear: Parser.parseString(json['model_year']),
    color: Parser.parseString(json['color']),
    fuelType: json['fuel_type'] is Map<String, dynamic> ? VehicleWithInfoModelFuelType.fromJson(json['fuel_type']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': qrCode,
      'owner_name': ownerName,
      'type': type,
      'fuel_type_id': fuelTypeId,
      'engine_number': engineNumber,
      'plate_number': plateNumber,
      'last_refuel_date': lastRefuelDate?.toIso8601String(),
      'is_active': isActive,
      'owner_phone': ownerPhone,
      'model_year': modelYear,
      'color': color,
      'fuel_type': fuelType?.toJson(),
    };
  }

  @override
  String toString() => 'VehicleWithInfoModel(id: $id, qrCode: $qrCode, ownerName: $ownerName, type: $type, fuelTypeId: $fuelTypeId, engineNumber: $engineNumber, plateNumber: $plateNumber, lastRefuelDate: $lastRefuelDate, isActive: $isActive, ownerPhone: $ownerPhone, modelYear: $modelYear, color: $color, fuelType: $fuelType)';
}

// Sub model class: VehicleWithInfoModelFuel_type
class VehicleWithInfoModelFuelType {
  final int? id;
  final String? name;
  final String? pricePerLiter;

  const VehicleWithInfoModelFuelType({this.id, this.name, this.pricePerLiter});

  /// Parses API response data into model
  factory VehicleWithInfoModelFuelType.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for VehicleWithInfoModelFuel_type');
    }
    return VehicleWithInfoModelFuelType(
          id: Parser.parseInt(json['id']),
          name: Parser.parseString(json['name']),
          pricePerLiter: Parser.parseString(json['price_per_liter']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price_per_liter': pricePerLiter,
    };
  }

  @override
  String toString() {
    return 'VehicleWithInfoModelFuel_type(id: $id, name: $name, pricePerLiter: $pricePerLiter)';
  }
}

// << MU-CODE | © 2025-07-23 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
