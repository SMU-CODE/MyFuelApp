import 'package:my_fuel/shared/helper/Parser.dart';

class UservehicleswithdetailsModel {
  final int? id;
  final String? qrCode;
  final String? ownerName;
  final String? type;
  final int? fuelTypeId;
  final String? engineNumber;
  final String? plateNumber;
  final String? lastRefuelDate;
  final bool? isActive;  final bool? canBook;
  final String? ownerPhone;
  final String? modelYear;
  final String? color;
  final String? insuranceExpiry;

  const UservehicleswithdetailsModel({
    this.id,
    this.qrCode,
    this.ownerName,
    this.type,
    this.fuelTypeId,
    this.engineNumber,
    this.plateNumber,
    this.lastRefuelDate,
    this.isActive, this.canBook,
    this.ownerPhone,
    this.modelYear,
    this.color,
    this.insuranceExpiry,
  });

  /// Parse JSON to model
  factory UservehicleswithdetailsModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return UservehicleswithdetailsModel(
      id: Parser.parseInt(json['id']),
      qrCode: Parser.parseString(json['qr_code']),
      ownerName: Parser.parseString(json['owner_name']),
      type: Parser.parseString(json['type']),
      fuelTypeId: Parser.parseInt(json['fuel_type_id']),
      engineNumber: Parser.parseString(json['engine_number']),
      plateNumber: Parser.parseString(json['plate_number']),
      lastRefuelDate: Parser.parseString(json['last_refuel_date']),
      isActive: Parser.parseBool(json['is_active']),canBook: Parser.parseBool(json['canBook']),
      ownerPhone: Parser.parseString(json['owner_phone']),
      modelYear: Parser.parseString(json['model_year']),
      color: Parser.parseString(json['color']),
      insuranceExpiry: Parser.parseString(json['insurance_expiry']),
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
      'last_refuel_date': lastRefuelDate,
      'is_active': isActive,'canBook': canBook,
      'owner_phone': ownerPhone,
      'model_year': modelYear,
      'color': color,
      'insurance_expiry': insuranceExpiry,
    };
  }

  @override
  String toString() =>
      'UservehicleswithdetailsModel(id: $id, qrCode: $qrCode, ownerName: $ownerName, type: $type, fuelTypeId: $fuelTypeId, engineNumber: $engineNumber, plateNumber: $plateNumber, lastRefuelDate: $lastRefuelDate, isActive: $isActive, ownerPhone: $ownerPhone, modelYear: $modelYear, color: $color, insuranceExpiry: $insuranceExpiry)';
}

// << MU-CODE | © 2025-07-17 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
