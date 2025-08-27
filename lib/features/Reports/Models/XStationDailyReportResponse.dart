import 'package:my_fuel/shared/helper/Parser.dart';

class XStationDailyInfo {
  final int id;
  final int fuelTypeId;
  final int maxBookings;
  final double shippedAmount;
  final double receivedAmount;
  final DateTime infoDate;
  final int stationId;
  final String status;
  final DateTime updatedAt;
  final double remainingAmount;
  final double expectedShipment;
  final String? notes;
  final Station station;
  final FuelType fuelType;
  final List<Booking> bookings;

  XStationDailyInfo({
    required this.id,
    required this.fuelTypeId,
    required this.maxBookings,
    required this.shippedAmount,
    required this.receivedAmount,
    required this.infoDate,
    required this.stationId,
    required this.status,
    required this.updatedAt,
    required this.remainingAmount,
    required this.expectedShipment,
    this.notes,
    required this.station,
    required this.fuelType,
    required this.bookings,
  });

  factory XStationDailyInfo.fromJson(Map<String, dynamic> json) {
    return XStationDailyInfo(
      id: Parser.parseInt(json['id']),
      fuelTypeId: Parser.parseInt(json['fuel_type_id']),
      maxBookings: Parser.parseInt(json['max_bookings']),
      shippedAmount: Parser.parseDouble(json['shipped_amount']),
      receivedAmount: Parser.parseDouble(json['received_amount']),
      infoDate: Parser.parseDateTime(json['info_date']),
      stationId: Parser.parseInt(json['station_id']),
      status: Parser.parseString(json['status']),
      updatedAt: Parser.parseDateTime(json['updated_at']),
      remainingAmount: Parser.parseDouble(json['remaining_amount']),
      expectedShipment: Parser.parseDouble(json['expected_shipment']),
      notes: Parser.parseString(json['notes']),
      station: Station.fromJson(json['station'] ?? {}),
      fuelType: FuelType.fromJson(json['fuel_type'] ?? {}),
      bookings: Parser.parseList(
        json['bookings'],
        (item) => Booking.fromJson(item),
      ),
    );
  }
}

class Station {
  final int id;
  final String name;
  final String location;
  final String? image;
  final bool isActive;
  final String? imageUrl;

  Station({
    required this.id,
    required this.name,
    required this.location,
    this.image,
    required this.isActive,
    this.imageUrl,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
      location: Parser.parseString(json['location']),
      image: Parser.parseString(json['image']),
      isActive: Parser.parseBool(json['is_active']),
      imageUrl: Parser.parseString(json['image_url']),
    );
  }
}

class FuelType {
  final int id;
  final String name;

  FuelType({required this.id, required this.name});

  factory FuelType.fromJson(Map<String, dynamic> json) {
    return FuelType(
      id: Parser.parseInt(json['id']),
      name: Parser.parseString(json['name']),
    );
  }
}

class Booking {
  final int id;
  final int stationDailyInfoId;
  final String type;
  final String status;
  final String paymentMethod;
  final double fuelAmount;
  final double totalPrice;
  final DateTime bookedAt;
  final DateTime? cancellationDate;
  final DateTime? completionDate;

  Booking({
    required this.id,
    required this.stationDailyInfoId,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.fuelAmount,
    required this.totalPrice,
    required this.bookedAt,
    this.cancellationDate,
    this.completionDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: Parser.parseInt(json['id']),
      stationDailyInfoId: Parser.parseInt(json['station_daily_info_id']),
      type: Parser.parseString(json['type']),
      status: Parser.parseString(json['status']),
      paymentMethod: Parser.parseString(json['payment_method']),
      fuelAmount: Parser.parseDouble(json['fuel_amount']),
      totalPrice: Parser.parseDouble(json['total_price']),
      bookedAt: Parser.parseDateTime(json['booked_at']),
      cancellationDate:
          json['cancellation_date'] != null
              ? Parser.parseDateTime(json['cancellation_date'])
              : null,
      completionDate:
          json['completion_date'] != null
              ? Parser.parseDateTime(json['completion_date'])
              : null,
    );
  }
}

/* 
class Meta {
  final Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  factory Meta.empty() {
    return Meta(
      pagination: Pagination.empty(),
    );
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final String path;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.path,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: Parser.parseInt(json['current_page']),
      perPage: Parser.parseInt(json['per_page']),
      total: Parser.parseInt(json['total']),
      lastPage: Parser.parseInt(json['last_page']),
      path: Parser.parseString(json['path']),
      nextPageUrl: Parser.parseString(json['next_page_url']),
      prevPageUrl: Parser.parseString(json['prev_page_url']),
    );
  }

  factory Pagination.empty() {
    return Pagination(
      currentPage: 1,
      perPage: 15,
      total: 0,
      lastPage: 1,
      path: '',
    );
  }
}

class DebugInfo {
  final DateTime timestamp;
  final bool debugMode;

  DebugInfo({
    required this.timestamp,
    required this.debugMode,
  });

  factory DebugInfo.fromJson(Map<String, dynamic> json) {
    return DebugInfo(
      timestamp: Parser.parseDateTime(json['timestamp']),
      debugMode: Parser.parseBool(json['debug_mode']),
    );
  }

  factory DebugInfo.empty() {
    return DebugInfo(
      timestamp: DateTime.now(),
      debugMode: false,
    );
  }
}
 */
