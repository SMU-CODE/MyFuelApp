// Main model class: EmptyModel
class EmptyModel {
  const EmptyModel();

  /// Parses API response data into model
  factory EmptyModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for EmptyModel');
    }
    return EmptyModel();
  }

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return 'EmptyModel()';
  }
}

// << MU-CODE | © 2025-06-10 | All Rights Reserved >> - MU.CODE@GMAIL.COM >> //
