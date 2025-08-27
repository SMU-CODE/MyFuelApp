enum NotificationType { message, alert, event, system }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;
  bool read;
  final bool hasAction;
  final String? code;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.read = false,
    this.hasAction = false,
    this.code,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.message,
      ),
      read: json['read'] as bool? ?? false,
      hasAction: json['hasAction'] as bool? ?? false,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'read': read,
      'hasAction': hasAction,
      'code': code,
    };
  }

  @override
  String toString() => 
      'NotificationModel(id: $id, title: $title, message: $message, '
      'date: $date, type: $type, read: $read, hasAction: $hasAction, '
      'code: $code)';

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    NotificationType? type,
    bool? read,
    bool? hasAction,
    String? code,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      type: type ?? this.type,
      read: read ?? this.read,
      hasAction: hasAction ?? this.hasAction,
      code: code ?? this.code,
    );
  }
}
