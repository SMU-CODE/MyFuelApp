// Request class: AddNewVehicleRequest
class AddNewVehicleRequest {
  final String? ownerName;
  final String? type;
  final int? fuelTypeId;
  final String? engineNumber;
  final String? plateNumber;
  final DateTime? lastRefuelDate;
  final bool? isActive;
  final String? ownerPhone;
  final int? modelYear;
  final String? color;

  const AddNewVehicleRequest({this.ownerName, this.type, this.fuelTypeId, this.engineNumber, this.plateNumber, this.lastRefuelDate, this.isActive, this.ownerPhone, this.modelYear, this.color});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'type': type,
      'fuel_type_id': fuelTypeId,
      'engine_number': engineNumber,
      'plate_number': plateNumber,
      'last_refuel_date': lastRefuelDate?.toIso8601String(),
      'is_active': isActive,
      'owner_phone': ownerPhone,
      'model_year': modelYear,
      'color': color,
    };
  }

}

// << MU-CODE | © 2025-07-23 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
