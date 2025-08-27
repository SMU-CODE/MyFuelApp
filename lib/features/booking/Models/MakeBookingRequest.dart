// Request class: MakeBookingRequest
class MakeBookingRequest {
  final int vehicleId;
  final int stationDailyInfoId;
  final int? fuelTypeId;
  final int periodId;
  final double? fuelAmount;
  final String? type;
  final String? paymentMethod;
  final String? notes;

  const MakeBookingRequest({
    required this.vehicleId,
    required this.stationDailyInfoId,
     this.fuelTypeId,
    required this.periodId,
    this.fuelAmount,
    this.type,
    this.paymentMethod,
    this.notes,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'station_daily_info_id': stationDailyInfoId,
      'fuel_type_id': fuelTypeId,
      'period_id': periodId,
      'fuel_amount': fuelAmount,
      'type': type,
      'payment_method': paymentMethod,
      'notes': notes,
    };
  }
}

// << MU-CODE | © 2025-07-22 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
