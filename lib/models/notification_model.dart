class NotificationModel {
  final String? id;
  final String message;
  final String? notificationType;
  final bool isRead;
  final String? createdAt;

  NotificationModel({
    this.id,
    required this.message,
    this.notificationType,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      message: json['message'] ?? '',
      notificationType: json['notification_type']?.toString() ?? json['notificationType']?.toString(),
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }
}
