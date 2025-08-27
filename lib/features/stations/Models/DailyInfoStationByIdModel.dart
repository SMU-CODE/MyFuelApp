import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: StationDailyInfoModel
class DailyInfoStationByIdModel {
  final int? id;
  final int? fuelTypeId;
  final int? maxBookings;
  final String? shippedAmount;
  final String? receivedAmount;
  final DateTime? infoDate;
  final int? stationId;
  final String? status;
  final String? updatedAt;
  final String? remainingAmount;
  final String? expectedShipment;
  final String? notes;
  final String? name;
  final String? location;
  final String? about;
  final String? image;
  final bool? isActive;
  final DateTime? createdAt;
  final String? fuelTypeName;
  final bool? isActiveFuel;
  final String? pricePerLiter;
  final String? currency;

  const DailyInfoStationByIdModel({
    this.id,
    this.fuelTypeId,
    this.maxBookings,
    this.shippedAmount,
    this.receivedAmount,
    this.infoDate,
    this.stationId,
    this.status,
    this.updatedAt,
    this.remainingAmount,
    this.expectedShipment,
    this.notes,
    this.name,
    this.location,
    this.about,
    this.image,
    this.isActive,
    this.createdAt,
    this.fuelTypeName,
    this.isActiveFuel,
    this.pricePerLiter,
    this.currency,
  });

  /// Parse JSON to model
  factory DailyInfoStationByIdModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return DailyInfoStationByIdModel(
      id: Parser.parseInt(json['id']),
      fuelTypeId: Parser.parseInt(json['fuel_type_id']),
      maxBookings: Parser.parseInt(json['max_bookings']),
      shippedAmount: Parser.parseString(json['shipped_amount']),
      receivedAmount: Parser.parseString(json['received_amount']),
      infoDate: Parser.parseDateTime(json['info_date']),
      stationId: Parser.parseInt(json['station_id']),
      status: Parser.parseString(json['status']),
      updatedAt: Parser.formatDateTime(json['updated_at'] ?? json['info_date']),
      remainingAmount: Parser.parseString(json['remaining_amount']),
      expectedShipment: Parser.parseString(json['expected_shipment']),
      notes: Parser.parseString(json['notes']),
      name: Parser.parseString(json['name']),
      location: Parser.parseString(json['location']),
      about: Parser.parseString(json['about']),
      image: Parser.parseString(json['image']),
      isActive: Parser.parseBool(json['is_active']),
      createdAt: Parser.parseDateTime(json['created_at']),
      fuelTypeName: Parser.parseString(json['fuel_type_name']),
      isActiveFuel: Parser.parseBool(json['is_active_fuel']),
      pricePerLiter: Parser.parseString(json['price_per_liter']),
      currency: Parser.parseString(json['currency']),
    );
  }

  @override
  String toString() =>
      'StationDailyInfoModel(id: $id, fuelTypeId: $fuelTypeId, maxBookings: $maxBookings, shippedAmount: $shippedAmount, receivedAmount: $receivedAmount, infoDate: $infoDate, stationId: $stationId, status: $status, updatedAt: $updatedAt, remainingAmount: $remainingAmount, expectedShipment: $expectedShipment, notes: $notes, name: $name, location: $location, about: $about, image: $image, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, fuelTypeName: $fuelTypeName, isActiveFuel: $isActiveFuel, pricePerLiter: $pricePerLiter, currency: $currency)';
}

// << MU-CODE | © 2025-07-30 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
