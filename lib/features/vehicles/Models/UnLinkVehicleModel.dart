import 'package:my_fuel/shared/helper/Parser.dart';

// Main model class: UnLinkVehicleModel
class UnLinkVehicleModel {
  final int? userId;
  final String? vehicleQrCode;
  final DateTime? timestamp;

  const UnLinkVehicleModel({this.userId, this.vehicleQrCode, this.timestamp});

  /// Parses API response data into model
  factory UnLinkVehicleModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for UnLinkVehicleModel');
    }
    return UnLinkVehicleModel(
      userId: Parser.parseInt(json['user_id']),
      vehicleQrCode: Parser.parseString(json['vehicle_qr_code']),
      timestamp: Parser.parseDateTime(json['timestamp']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'vehicle_qr_code': vehicleQrCode,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UnLinkVehicleModel(userId: $userId, vehicleQrCode: $vehicleQrCode, timestamp: $timestamp)';
  }
}

// << MU-CODE | © 2025-06-09 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //

// Main model class: UnLinkVehicleRequestModel
class UnLinkVehicleRequestModel {
  final int? userId;
  final String? vehicleQrCode;
  final String? ownerPhone;

  const UnLinkVehicleRequestModel({
    this.userId,
    this.vehicleQrCode,
    this.ownerPhone,
  });

  /// Parses API response data into model
  factory UnLinkVehicleRequestModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format for UnLinkVehicleRequestModel',
      );
    }
    return UnLinkVehicleRequestModel(
      userId: Parser.parseInt(json['user_id']),
      vehicleQrCode: Parser.parseString(json['vehicle_qr_code']),
      ownerPhone: Parser.parseString(json['owner_phone']),
    );
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'vehicle_qr_code': vehicleQrCode,
      'owner_phone': ownerPhone,
    };
  }

  @override
  String toString() {
    return 'UnLinkVehicleRequestModel(userId: $userId, vehicleQrCode: $vehicleQrCode, ownerPhone: $ownerPhone)';
  }
}

// << MU-CODE | © 2025-06-09 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
