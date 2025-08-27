class DailyInfoStationFormRequest {
  final int? fuelTypeId;
  final int? maxBookings;
  final double? shippedAmount;
  final double? receivedAmount;
  final String? infoDate; // Keeping as String for direct API compatibility
  final int? stationId;
  final String? status; // "1" or "0"
  final double? remainingAmount;
  final double? expectedShipment;
  final String? notes;

  DailyInfoStationFormRequest({
    this.fuelTypeId,
    this.maxBookings,
    this.shippedAmount,
    this.receivedAmount,
    this.infoDate,
    this.stationId,
    this.status,
    this.remainingAmount,
    this.expectedShipment,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fuelTypeId != null) data['fuel_type_id'] = fuelTypeId;
    if (maxBookings != null) data['max_bookings'] = maxBookings;
    if (shippedAmount != null) data['shipped_amount'] = shippedAmount;
    if (receivedAmount != null) data['received_amount'] = receivedAmount;
    if (infoDate != null) data['info_date'] = infoDate;
    if (stationId != null) data['station_id'] = stationId;
    if (status != null) data['status'] = status;
    if (remainingAmount != null) data['remaining_amount'] = remainingAmount;
    if (expectedShipment != null) data['expected_shipment'] = expectedShipment;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}
