import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: StationsDailyInfoForUserModel
class DailyInfoStationsForUserModel {
  final StationsDailyInfoForUserModelStation? station;
  final StationsDailyInfoForUserModelDailyInfo? dailyInfo;
  final StationsDailyInfoForUserModelBookings? bookings;

  const DailyInfoStationsForUserModel({
    required this.station,
    required this.dailyInfo,
    required this.bookings,
  });

  /// Parse JSON to model
  factory DailyInfoStationsForUserModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return DailyInfoStationsForUserModel(
      station:
          json['station'] is Map<String, dynamic>
              ? StationsDailyInfoForUserModelStation.fromJson(json['station'])
              : null,
      dailyInfo:
          json['daily_info'] is Map<String, dynamic>
              ? StationsDailyInfoForUserModelDailyInfo.fromJson(
                json['daily_info'],
              )
              : null,
      bookings:
          json['bookings'] is Map<String, dynamic>
              ? StationsDailyInfoForUserModelBookings.fromJson(json['bookings'])
              : null,
    );
  }

  @override
  String toString() =>
      'StationsDailyInfoForUserModel(station: $station, dailyInfo: $dailyInfo, bookings: $bookings)';
}

// Sub model class: StationsDailyInfoForUserModelStation
class StationsDailyInfoForUserModelStation {
  final int id;
  final String name;
  final String location;
  final dynamic imageUrl;
  final bool isActive;

  const StationsDailyInfoForUserModelStation({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.isActive,
  });

  /// Parses API response data into model
  factory StationsDailyInfoForUserModelStation.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for StationsDailyInfoForUserModelStation',
      );
    }
    return StationsDailyInfoForUserModelStation(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
      location: Parser.parseString(json['location']),
      imageUrl: json['image_url'],
      isActive: Parser.parseBool(json['is_active']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }

  @override
  String toString() =>
      'StationsDailyInfoForUserModelStation(id: $id, name: $name, location: $location, imageUrl: $imageUrl, isActive: $isActive)';
}

// Sub model class: StationsDailyInfoForUserModelDailyInfo
class StationsDailyInfoForUserModelDailyInfo {
  final int id;
  final String fuelType;
  final int shippedAmount;
  final int receivedAmount;
  final int remainingAmount;
  final int expectedShipment;
  final String status;
  final dynamic notes;
  final DateTime date;
  final DateTime updatedAt;
  final int maxBookings;

  const StationsDailyInfoForUserModelDailyInfo({
    required this.id,
    required this.fuelType,
    required this.shippedAmount,
    required this.receivedAmount,
    required this.remainingAmount,
    required this.expectedShipment,
    required this.status,
    required this.notes,
    required this.date,
    required this.updatedAt,
    required this.maxBookings,
  });

  /// Parses API response data into model
  factory StationsDailyInfoForUserModelDailyInfo.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for StationsDailyInfoForUserModelDailyInfo',
      );
    }
    return StationsDailyInfoForUserModelDailyInfo(
      id: Parser.parseInt(json['id']),
      fuelType: Parser.parseString(json['fuel_type']),
      shippedAmount: Parser.parseInt(json['shipped_amount']),
      receivedAmount: Parser.parseInt(json['received_amount']),
      remainingAmount: Parser.parseInt(json['remaining_amount']),
      expectedShipment: Parser.parseInt(json['expected_shipment']),
      status: Parser.parseString(json['status']),
      notes: json['notes'],
      date: Parser.parseDateTime(json['date']),
      updatedAt: Parser.parseDateTime(json['updated_at']),
      maxBookings: Parser.parseInt(json['max_bookings']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fuel_type': fuelType,
      'shipped_amount': shippedAmount,
      'received_amount': receivedAmount,
      'remaining_amount': remainingAmount,
      'expected_shipment': expectedShipment,
      'status': status,
      'notes': notes,
      'date': date.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'max_bookings': maxBookings,
    };
  }

  @override
  String toString() =>
      'StationsDailyInfoForUserModelDailyInfo(id: $id, fuelType: $fuelType, shippedAmount: $shippedAmount, receivedAmount: $receivedAmount, remainingAmount: $remainingAmount, expectedShipment: $expectedShipment, status: $status, notes: $notes, date: $date, updatedAt: $updatedAt, maxBookings: $maxBookings)';
}

// Sub model class: StationsDailyInfoForUserModelStatusounts
class StationsDailyInfoForUserModelStatusounts {
  final int pending;
  final int confirmed;
  final int completed;
  final int cancelled;

  const StationsDailyInfoForUserModelStatusounts({
    required this.pending,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
  });

  /// Parses API response data into model
  factory StationsDailyInfoForUserModelStatusounts.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for StationsDailyInfoForUserModelStatusounts',
      );
    }
    return StationsDailyInfoForUserModelStatusounts(
      pending: Parser.parseInt(json['pending']),
      confirmed: Parser.parseInt(json['confirmed']),
      completed: Parser.parseInt(json['completed']),
      cancelled: Parser.parseInt(json['cancelled']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'confirmed': confirmed,
      'completed': completed,
      'cancelled': cancelled,
    };
  }

  @override
  String toString() =>
      'StationsDailyInfoForUserModelStatusounts(pending: $pending, confirmed: $confirmed, completed: $completed, cancelled: $cancelled)';
}

// Sub model class: StationsDailyInfoForUserModelBookings
class StationsDailyInfoForUserModelBookings {
  final int total;
  final int count;
  final StationsDailyInfoForUserModelStatusounts? statusCounts;

  const StationsDailyInfoForUserModelBookings({
    required this.total,
    required this.count,
    required this.statusCounts,
  });

  /// Parses API response data into model
  factory StationsDailyInfoForUserModelBookings.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for StationsDailyInfoForUserModelBookings',
      );
    }
    return StationsDailyInfoForUserModelBookings(
      total: Parser.parseInt(json['total']),
      count: Parser.parseInt(json['count']),
      statusCounts:
          json['status_counts'] is Map<String, dynamic>
              ? StationsDailyInfoForUserModelStatusounts.fromJson(
                json['status_counts'],
              )
              : null,
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'count': count,
      'status_counts': statusCounts?.toJson(),
    };
  }

  @override
  String toString() =>
      'StationsDailyInfoForUserModelBookings(total: $total, count: $count, statusCounts: $statusCounts)';
}

// << MU-CODE | © 2025-08-02 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
