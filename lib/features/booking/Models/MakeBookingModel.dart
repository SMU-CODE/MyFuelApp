// Main model class : MakeBookingModel

class MakeBookingModel {
  int? bookingId;
  DateTime? bookingDate;
  String? status;
  String? stationName;
  int? fuelAmount;
  dynamic periodName;
  int? remainingBookings;

  // Constructor for MakeBookingModelData  with named parameters
  MakeBookingModel({
    this.bookingId,
    this.bookingDate,
    this.status,
    this.stationName,
    this.fuelAmount,
    this.periodName,
    this.remainingBookings,
  });

  // Create an instance from a JSON map
  MakeBookingModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingDate = json['booking_date'];
    status = json['status'];
    stationName = json['station_name'];
    fuelAmount = json['fuel_amount'];
    periodName = json['period_name'];
    remainingBookings = json['remaining_bookings'];
  }

  // Convert instance to JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['booking_date'] = bookingDate;
    data['status'] = status;
    data['station_name'] = stationName;
    data['fuel_amount'] = fuelAmount;
    data['period_name'] = periodName;
    data['remaining_bookings'] = remainingBookings;
    return data;
  }
}

// << MU-CODE | © 2025-04-22 | All Rights Reserved >> - mu.code@gmail.com >> //
