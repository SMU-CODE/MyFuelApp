import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/booking/Controllers/BookingHistoryController.dart';
import 'package:my_fuel/features/booking/Views/BookingHistoryWidgets.dart';
import 'package:my_fuel/shared/helper/Parser.dart'; // Make sure this import is correct

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قم بتهيئة الـ Controller الخاص بسجل الحجوزات
    final BookingHistoryController controller = Get.put(
      BookingHistoryController(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("سجل الحجوزات"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchBookingHistory();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // قسم الفلترة والإحصائيات
              // Assuming FilterWithStats widget exists and uses the controller correctly
              FilterWithStats(controller: controller),
              const SizedBox(height: 16),

              // عرض قائمة الحجوزات أو حالات التحميل/الخطأ/الفارغة
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "خطأ: ${controller.errorMessage}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchBookingHistory(),
                            icon: const Icon(Icons.refresh),
                            label: const Text("إعادة المحاولة"),
                          ),
                        ],
                      ),
                    );
                  } else if (controller.filteredBookings.isEmpty) {
                    return const BookingEmptyState(); // Assuming this widget provides an empty state UI
                  } else {
                    return ListView.builder(
                      itemCount: controller.filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = controller.filteredBookings[index];

                        // Use Parser.formatDateTime for nullable DateTime and provide a fallback
                        final formattedDate = Parser.formatDateTime(
                          booking.bookedAt,
                          format: 'yyyy-MM-dd HH:mm', // Specify desired format
                        );

                        // Ensure booking.status is not null before passing to fromString
                        final status = BookingStatusExtension.fromString(
                          booking.status,
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder:
                                    (ctx) => BookingDetailsBottomSheet(
                                      booking: booking,
                                    ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "رقم الحجز: ${booking.id}", // ID is non-nullable
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // عرض حالة الحجز
                                      _buildStatusChip(status),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        // Use direct access to nullable stationLocation
                                        // and provide a fallback string if null
                                        child: Text(
                                          booking
                                              .stationName, // Use stationName as it's non-nullable
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.water_drop,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        // fuelAmount is non-nullable, but added .toString() for clarity in string interpolation
                                        "${booking.fuelTypeName} - ${booking.fuelAmount.toString()} لتر",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء شريحة الحالة (Chip)
  Widget _buildStatusChip(BookingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1), // Use withOpacity for alpha
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
        ), // Use withOpacity
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          color: status.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
