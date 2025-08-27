// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fuel/features/booking/Models/BookingHistoryModel.dart';
import 'package:my_fuel/features/booking/Services/BookingHistoryService.dart';
import 'package:my_fuel/features/booking/Services/CancelBookingService.dart';
import 'package:my_fuel/shared/helper/MuAlerts.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

class BookingHistoryController extends GetxController {
  final RxList<BookingHistoryModel> _bookings = <BookingHistoryModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = "".obs;
  BookingStatus _currentStatusFilter = BookingStatus.all;

  List<BookingHistoryModel> get bookings => _bookings.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError =>
      _errorMessage.isNotEmpty; // Derive hasError from errorMessage
  BookingStatus get currentStatusFilter => _currentStatusFilter;

  Map<String, int> get bookingStats {
    int total = _bookings.length;
    int pending = _bookings.where((b) => b.status == 'Pending').length;
    int confirmed = _bookings.where((b) => b.status == 'Confirmed').length;
    int completed = _bookings.where((b) => b.status == 'Completed').length;
    int cancelled = _bookings.where((b) => b.status == 'Cancelled').length;

    return {
      'total': total,
      'pending': pending,
      'confirmed': confirmed,
      'completed': completed,
      'cancelled': cancelled,
    };
  }

  List<BookingHistoryModel> get filteredBookings {
    if (_currentStatusFilter == BookingStatus.all) return _bookings.value;
    return _bookings.value.where((booking) {
      final status = booking.status.toLowerCase();
      return status == _currentStatusFilter.name;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  void updateFilter(BookingStatus newStatus) {
    _currentStatusFilter = newStatus;
    update();
  }

  @override
  Future<void> refresh() => fetchBookingHistory();

  Future<void> fetchBookingHistory() async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      final response = await BookingHistoryService.fetchBookingHistory();

      if (response.success && response.data != null) {
        _bookings.assignAll(response.data as Iterable<BookingHistoryModel>);
      } else {
        _errorMessage.value = response.message;
        MuAlerts.showError(response.message);
      }
    } catch (e, st) {
      MuLogger.exception(e, st, "Failed to fetch booking history");
      _errorMessage.value =
          'حدث خطأ في جلب سجل الحجوزات. الرجاء المحاولة لاحقاً.';
      MuAlerts.showError(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> showCancelConfirmation(
    BuildContext context,
    int bookingId,
  ) async {
    final TextEditingController reasonController = TextEditingController();

    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('تأكيد الإلغاء'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟'),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'سبب الإلغاء (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(ctx).pop({
                      'confirmed': 'true',
                      'reason':
                          reasonController.text.trim().isNotEmpty
                              ? reasonController.text.trim()
                              : null,
                    }),
                child: const Text('تأكيد الإلغاء'),
              ),
            ],
          ),
    );

    if (result != null && result['confirmed'] == 'true') {
      _isLoading.value = true;
      _errorMessage.value = '';
      final String? cancellationReason = result['reason'];

      try {
        final serviceResult = await CancelBookingService.cancelBooking(
          bookingId,
          cancellationReason ?? "",
        );

        if (serviceResult.success) {
          MuAlerts.showSuccess(serviceResult.message);
          await fetchBookingHistory();
        } else {
          _errorMessage.value = serviceResult.message;
          MuAlerts.showError(serviceResult.message);
        }
      } catch (e, st) {
        MuLogger.exception(e, st, "Failed to cancel booking $bookingId");
        _errorMessage.value = 'فشل في إلغاء الحجز. الرجاء المحاولة لاحقاً.';
        MuAlerts.showError(_errorMessage.value);
      } finally {
        _isLoading.value = false;
        reasonController.dispose();
      }
    } else {
      reasonController.dispose();
    }
  }
}

enum BookingStatus { all, pending, confirmed, completed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return "قيد الانتظار";
      case BookingStatus.confirmed:
        return "مؤكدة";
      case BookingStatus.completed:
        return "مكتملة";
      case BookingStatus.cancelled:
        return "ملغاة";
      default:
        return "الكل";
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.hourglass_empty;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.list;
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static BookingStatus fromString(String? statusString) {
    switch (statusString?.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.all;
    }
  }
}
