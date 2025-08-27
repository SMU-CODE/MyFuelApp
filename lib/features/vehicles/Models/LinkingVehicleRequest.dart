// Request class: LinkingVehicleRequest
class LinkingVehicleRequest {
  final String? vehicleQrCode;
  final String? ownerPhone;
  final String? otpCode;
  final String? channel;
  final String? type;

  const LinkingVehicleRequest({
    this.vehicleQrCode,
    this.ownerPhone,
    this.otpCode,
    // Add default values for type and channel directly in the constructor
    // Based on VehicleLinkController, type defaults to 'phone' and channel to 'sms'
    this.type = 'phone', // Default type is 'phone'
    this.channel = 'sms', // Default channel is 'sms'
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "vehicle_qr_code": vehicleQrCode,
      "owner_phone": ownerPhone,
      "otp_code": otpCode,
      "channel": channel,
      "type": type,
    };
  }
} //LinkingVehicleRequest

// << MU-CODE | © 2025-07-18 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
