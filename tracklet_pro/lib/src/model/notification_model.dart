class NotificationModel {
  final String? id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final String orderId;
  final String driverId;
  final String driverName;
  final String status; // 'unread' or 'read'
  final String
  type; // 'order_placed', 'order_accepted', 'driver_assigned', etc.
  final DateTime date;
  final DateTime? createdAt;

  NotificationModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    this.orderId = '',
    this.driverId = '',
    this.driverName = '',
    this.status = 'unread',
    required this.type,
    DateTime? date,
    this.createdAt,
  }) : date = date ?? DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String?,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      orderId: json['orderId'] as String? ?? '',
      driverId: json['driverId'] as String? ?? '',
      driverName: json['driverName'] as String? ?? '',
      status: json['status'] as String? ?? 'unread',
      type: json['type'] as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'orderId': orderId,
      'driverId': driverId,
      'driverName': driverName,
      'status': status,
      'type': type,
      'date': date.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  bool get isUnread => status == 'unread';

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Notification Types
class NotificationType {
  static const String orderPlaced = 'order_placed';
  static const String orderAccepted = 'order_accepted';
  static const String driverAssigned = 'driver_assigned';
  static const String orderCompleted = 'order_completed';
  static const String orderRejected = 'order_rejected';
  static const String orderCancelled = 'order_cancelled';
  static const String general = 'general';
}
