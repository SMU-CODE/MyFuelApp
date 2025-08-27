// my_fuel/features/Reports/Models/BookingReportRequest.dart
class BookingReportRequest {
  final String? startDate;
  final String? endDate;
  final List<int>? stationIds;
  final List<int>? fuelTypeIds;
  final List<String>? status;
  final int? userId;
  final String? groupBy;
  final String? format; // هذا الحقل ضروري

  BookingReportRequest({
    this.startDate,
    this.endDate,
    this.stationIds,
    this.fuelTypeIds,
    this.status,
    this.userId,
    this.groupBy,
    this.format, // تأكد من وجوده في الـ constructor
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (startDate != null) {
      data['start_date'] = startDate;
    }
    if (endDate != null) {
      data['end_date'] = endDate;
    }
    if (stationIds != null && stationIds!.isNotEmpty) {
      data['station_ids'] = stationIds;
    }
    if (fuelTypeIds != null && fuelTypeIds!.isNotEmpty) {
      data['fuel_type_ids'] = fuelTypeIds;
    }
    if (status != null && status!.isNotEmpty) {
      data['status'] = status;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (groupBy != null) {
      data['group_by'] = groupBy;
    }
    if (format != null) { // تأكد من تضمين format في الـ JSON
      data['format'] = format;
    }
    return data;
  }
}
