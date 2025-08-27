// Request class: RefuelingRequest
class RefuelingRequest {
  final String? vehicleQrCode;
  final String? notes;

  const RefuelingRequest({this.vehicleQrCode, this.notes});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicle_qr_code': vehicleQrCode,
      'notes': notes,
    };
  }

}

// << MU-CODE | © 2025-07-23 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
