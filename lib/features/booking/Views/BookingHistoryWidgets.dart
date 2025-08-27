import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/booking/Controllers/BookingHistoryController.dart';
import 'package:my_fuel/features/booking/Models/BookingHistoryModel.dart';
import 'package:my_fuel/shared/helper/Parser.dart';

class BookingDetailsBottomSheet extends StatelessWidget {
  final BookingHistoryModel booking;
  final BookingHistoryController controller =
      Get.find<BookingHistoryController>();

  BookingDetailsBottomSheet({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Correctly get the BookingStatus from the booking.status string
    final status = BookingStatusExtension.fromString(booking.status);

    // Format the bookedAt DateTime using Parser.parseString
    final String formattedDate = Parser.formatDateTime(
      Parser.parseString(booking.bookedAt),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "تفاصيل الحجز",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDetailItem(
                    Icons.location_on,
                    "اسم المحطة",
                    booking.stationName, // Directly use stationName from model
                  ),
                  _buildDetailItem(
                    Icons.confirmation_number,
                    "رقم الحجز",
                    booking.id.toString(), // ID is int, convert to string
                  ),
                  _buildDetailItem(
                    Icons.calendar_today,
                    "تاريخ الحجز",
                    formattedDate,
                  ),
                  _buildDetailItem(
                    Icons.water_drop,
                    "نوع الوقود",
                    booking.fuelTypeName, // Directly use fuelTypeName
                  ),
                  _buildDetailItem(
                    Icons.speed,
                    "الكمية",
                    "${booking.fuelAmount} لتر", // fuelAmount is double
                  ),
                  _buildDetailItem(
                    Icons.attach_money,
                    "السعر الإجمالي",
                    "${booking.totalPrice} ${booking.fuelCurrency ?? 'SAR'}", // totalPrice is int, fuelCurrency is dynamic/nullable
                  ),
                  _buildDetailItem(
                    Icons.payment,
                    "طريقة الدفع",
                    booking.paymentMethod,
                  ),
                  _buildDetailItem(
                    Icons.assignment,
                    "ملاحظات",
                    booking.notes.isNotEmpty
                        ? booking.notes
                        : "لا توجد ملاحظات", // Handle empty notes
                  ),
                  _buildDetailItem(
                    Icons.person,
                    "اسم المالك",
                    booking.vehicleOwnerName, // Directly use vehicleOwnerName
                  ),
                  _buildDetailItem(
                    Icons.directions_car,
                    "نوع المركبة",
                    booking.vehicleType, // Directly use vehicleType
                  ),
                  _buildDetailItem(
                    Icons.credit_card,
                    "رقم اللوحة",
                    booking.vehiclePlateNumber?.toString() ??
                        "غير متوفر", // vehiclePlateNumber is dynamic
                  ),
                  _buildDetailItem(
                    Icons.access_time,
                    "الفترة",
                    booking.periodName, // Directly use periodName
                  ),
                  // Add cancellation date if available
                  if (booking.cancellationDate != null)
                    _buildDetailItem(
                      Icons.cancel,
                      "تاريخ الإلغاء",
                      Parser.parseString(booking.cancellationDate),
                    ),
                  // Add completion date if available
                  if (booking.completionDate != null)
                    _buildDetailItem(
                      Icons.check_circle,
                      "تاريخ الإكمال",
                      Parser.parseString(
                        booking.completionDate,
                      ), // Cast to DateTime for Parser
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (status == BookingStatus.pending ||
                  status == BookingStatus.confirmed)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close the bottom sheet first
                      await controller.showCancelConfirmation(
                        context,
                        booking.id, // booking.id is non-nullable now
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel, size: 20),
                        SizedBox(width: 8),
                        Text("إلغاء الحجز"),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("حسناً"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? "غير متوفر",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 14,
              color: status.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingEmptyState extends StatelessWidget {
  const BookingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "لا توجد حجوزات لعرضها",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FilterWithStats extends StatelessWidget {
  final BookingHistoryController controller;

  const FilterWithStats({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.bookingStats;
      return LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 4.5;

          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: BookingStatus.values.length,
              itemBuilder: (context, index) {
                final status = BookingStatus.values[index];
                final isSelected = controller.currentStatusFilter == status;
                final count = _getStatusCount(status, stats);

                return SizedBox(
                  width: itemWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.updateFilter(status),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? status.color.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? status.color
                                    : Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              status.icon,
                              size: 20,
                              color:
                                  isSelected ? status.color : Colors.grey[600],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              status.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? status.color
                                        : Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? status.color
                                        : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }

  int _getStatusCount(BookingStatus status, Map<String, int> stats) {
    switch (status) {
      case BookingStatus.all:
        return stats['total'] ?? 0;
      case BookingStatus.pending:
        return stats['pending'] ?? 0;
      case BookingStatus.confirmed:
        return stats['confirmed'] ?? 0;
      case BookingStatus.completed:
        return stats['completed'] ?? 0;
      case BookingStatus.cancelled:
        return stats['cancelled'] ?? 0;
    }
  }
}
