// Request class: CancelBookingRequest
class CancelBookingRequest {
  final int bookingId;
  final String cancellationReason;

  const CancelBookingRequest({required this.bookingId, required this.cancellationReason});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'cancellation_reason': cancellationReason,
    };
  }

}

// << MU-CODE | © 2025-07-23 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
