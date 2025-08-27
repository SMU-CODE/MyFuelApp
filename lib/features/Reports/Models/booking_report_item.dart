// my_fuel/features/Reports/Models/booking_report_item.dart
class BookingReportItem {
  final String? groupName;
  final int maxBookings;
  final double totalFuelAmount;
  final double totalRevenue;

  BookingReportItem({
    this.groupName,
    required this.maxBookings,
    required this.totalFuelAmount,
    required this.totalRevenue,
  });

  factory BookingReportItem.fromJson(Map<String, dynamic> json) {
    final dynamic rawFuelAmount = json['total_fuel_amount'];
    final dynamic rawRevenue = json['total_revenue'];

    double parsedFuelAmount;
    if (rawFuelAmount is String) {
      parsedFuelAmount = double.tryParse(rawFuelAmount) ?? 0.0;
    } else if (rawFuelAmount is num) {
      parsedFuelAmount = rawFuelAmount.toDouble();
    } else {
      parsedFuelAmount = 0.0;
    }

    double parsedRevenue;
    if (rawRevenue is String) {
      parsedRevenue = double.tryParse(rawRevenue) ?? 0.0;
    } else if (rawRevenue is num) {
      parsedRevenue = rawRevenue.toDouble();
    } else {
      parsedRevenue = 0.0;
    }

    return BookingReportItem(
      groupName: json['group_name'] as String?,
      maxBookings: json['max_bookings'] as int,
      totalFuelAmount: parsedFuelAmount,
      totalRevenue: parsedRevenue,
    );
  }
}
