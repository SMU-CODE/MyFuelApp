import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: BookingHistoryModel
class BookingHistoryModel {
  final int id;
  final DateTime bookedAt;
  final String type;
  final String status;
  final double fuelAmount;
  final int totalPrice;
  final String paymentMethod;
  final String notes;
  final String vehicleQrCode;
  final dynamic cancellationDate;
  final dynamic completionDate;
  final String stationName;
  final dynamic stationLocation;
  final String vehicleOwnerName;
  final String vehicleType;
  final dynamic vehiclePlateNumber;
  final String fuelTypeName;
  final int fuelPricePerLiter;
  final dynamic fuelCurrency;
  final String periodName;

  const BookingHistoryModel({
    required this.id,
    required this.bookedAt,
    required this.type,
    required this.status,
    required this.fuelAmount,
    required this.totalPrice,
    required this.paymentMethod,
    required this.notes,
    required this.vehicleQrCode,
    required this.cancellationDate,
    required this.completionDate,
    required this.stationName,
    required this.stationLocation,
    required this.vehicleOwnerName,
    required this.vehicleType,
    required this.vehiclePlateNumber,
    required this.fuelTypeName,
    required this.fuelPricePerLiter,
    required this.fuelCurrency,
    required this.periodName,
  });

  /// Parse JSON to model
  factory BookingHistoryModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return BookingHistoryModel(
      id: Parser.parseInt(json['id']),
      bookedAt: Parser.parseDateTime(json['booked_at']),
      type: Parser.parseString(json['type']),
      status: Parser.parseString(json['status']),
      fuelAmount: Parser.parseDouble(json['fuel_amount']),
      totalPrice: Parser.parseInt(json['total_price']),
      paymentMethod: Parser.parseString(json['payment_method']),
      notes: Parser.parseString(json['notes']),
      vehicleQrCode: Parser.parseString(json['vehicle_qr_code']),
      cancellationDate: json['cancellation_date'],
      completionDate: json['completion_date'],
      stationName: Parser.parseString(json['station_name']),
      stationLocation: json['station_location'],
      vehicleOwnerName: Parser.parseString(json['vehicle_owner_name']),
      vehicleType: Parser.parseString(json['vehicle_type']),
      vehiclePlateNumber: json['vehicle_plate_number'],
      fuelTypeName: Parser.parseString(json['fuel_type_name']),
      fuelPricePerLiter: Parser.parseInt(json['fuel_price_per_liter']),
      fuelCurrency: json['fuel_currency'],
      periodName: Parser.parseString(json['period_name']),
    );
  }

  @override
  String toString() =>
      'BookingHistoryModel(id: $id, bookedAt: $bookedAt, type: $type, status: $status, fuelAmount: $fuelAmount, totalPrice: $totalPrice, paymentMethod: $paymentMethod, notes: $notes, vehicleQrCode: $vehicleQrCode, cancellationDate: $cancellationDate, completionDate: $completionDate, stationName: $stationName, stationLocation: $stationLocation, vehicleOwnerName: $vehicleOwnerName, vehicleType: $vehicleType, vehiclePlateNumber: $vehiclePlateNumber, fuelTypeName: $fuelTypeName, fuelPricePerLiter: $fuelPricePerLiter, fuelCurrency: $fuelCurrency, periodName: $periodName)';
}

// << MU-CODE | © 2025-07-31 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
