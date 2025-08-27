import 'package:my_fuel/shared/helper/Parser.dart';

// Model class: UserStationDailyInfoModel
class DailyInfoManegerModel {
  final int stationId;
  final String stationName;
  final String stationLocation;
  final String stationImageUrl;
  final bool stationIsActive;
  final int dailyInfoId;
  final String dailyInfoFuelTypeName;
  final int dailyInfoTotalBookingsFromDb;
  final double dailyInfoShippedAmount;
  final double dailyInfoReceivedAmount;
  final double dailyInfoRemainingAmount;
  final int dailyInfoExpectedShipment;
  final String dailyInfoStatus;
  final String dailyInfoNotes;
  final DateTime dailyInfoDate;
  final DateTime dailyInfoUpdatedAt;
  final int totalBookingsCount;
  final int allBookingsCount;
  final int pendingBookingsCount;
  final int confirmedBookingsCount;
  final int completedBookingsCount;
  final int cancelledBookingsCount;

  const DailyInfoManegerModel({
    required this.stationId,
    required this.stationName,
    required this.stationLocation,
    required this.stationImageUrl,
    required this.stationIsActive,
    required this.dailyInfoId,
    required this.dailyInfoFuelTypeName,
    required this.dailyInfoTotalBookingsFromDb,
    required this.dailyInfoShippedAmount,
    required this.dailyInfoReceivedAmount,
    required this.dailyInfoRemainingAmount,
    required this.dailyInfoExpectedShipment,
    required this.dailyInfoStatus,
    required this.dailyInfoNotes,
    required this.dailyInfoDate,
    required this.dailyInfoUpdatedAt,
    required this.totalBookingsCount,
    required this.allBookingsCount,
    required this.pendingBookingsCount,
    required this.confirmedBookingsCount,
    required this.completedBookingsCount,
    required this.cancelledBookingsCount,
  });

  /// Parse JSON to model
  factory DailyInfoManegerModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON');
    }
    return DailyInfoManegerModel(
      stationId: Parser.parseInt(json['station_id']),
      stationName: Parser.parseString(json['station_name']),
      stationLocation: Parser.parseString(json['station_location']),
      stationImageUrl: Parser.parseString(json['station_image_url']),
      stationIsActive: Parser.parseBool(json['station_is_active']),
      dailyInfoId: Parser.parseInt(json['daily_info_id']),
      dailyInfoFuelTypeName: Parser.parseString(
        json['daily_info_fuel_type_name'],
      ),
      dailyInfoTotalBookingsFromDb: Parser.parseInt(
        json['daily_info_total_bookings_from_db'],
      ),
      dailyInfoShippedAmount: Parser.parseDouble(
        json['daily_info_shipped_amount'],
      ),
      dailyInfoReceivedAmount: Parser.parseDouble(
        json['daily_info_received_amount'],
      ),
      dailyInfoRemainingAmount: Parser.parseDouble(
        json['daily_info_remaining_amount'],
      ),
      dailyInfoExpectedShipment: Parser.parseInt(
        json['daily_info_expected_shipment'],
      ),
      dailyInfoStatus: Parser.parseString(json['daily_info_status']),
      dailyInfoNotes: Parser.parseString(json['daily_info_notes']),
      dailyInfoDate: Parser.parseDateTime(json['daily_info_date']),
      dailyInfoUpdatedAt: Parser.parseDateTime(json['daily_info_updated_at']),
      totalBookingsCount: Parser.parseInt(json['total_bookings_count']),
      allBookingsCount: Parser.parseInt(json['all_bookings_count']),
      pendingBookingsCount: Parser.parseInt(json['pending_bookings_count']),
      confirmedBookingsCount: Parser.parseInt(json['confirmed_bookings_count']),
      completedBookingsCount: Parser.parseInt(json['completed_bookings_count']),
      cancelledBookingsCount: Parser.parseInt(json['cancelled_bookings_count']),
    );
  }

  @override
  String toString() =>
      'UserStationDailyInfoModel(stationId: $stationId, stationName: $stationName, stationLocation: $stationLocation, stationImageUrl: $stationImageUrl, stationIsActive: $stationIsActive, dailyInfoId: $dailyInfoId, dailyInfoFuelTypeName: $dailyInfoFuelTypeName, dailyInfoTotalBookingsFromDb: $dailyInfoTotalBookingsFromDb, dailyInfoShippedAmount: $dailyInfoShippedAmount, dailyInfoReceivedAmount: $dailyInfoReceivedAmount, dailyInfoRemainingAmount: $dailyInfoRemainingAmount, dailyInfoExpectedShipment: $dailyInfoExpectedShipment, dailyInfoStatus: $dailyInfoStatus, dailyInfoNotes: $dailyInfoNotes, dailyInfoDate: $dailyInfoDate, dailyInfoupdated_at: $dailyInfoUpdatedAt, totalBookingsCount: $totalBookingsCount, allBookingsCount: $allBookingsCount, pendingBookingsCount: $pendingBookingsCount, confirmedBookingsCount: $confirmedBookingsCount, completedBookingsCount: $completedBookingsCount, cancelledBookingsCount: $cancelledBookingsCount)';
}

// << MU-CODE | © 2025-07-30 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
