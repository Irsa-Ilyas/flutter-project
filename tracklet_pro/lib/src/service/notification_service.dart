import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/notification_model.dart';

class NotificationService extends BaseService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Send notification
  Future<NotificationModel?> sendNotification({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
    required String type,
    String orderId = '',
    String driverId = '',
    String driverName = '',
  }) async {
    try {
      print('NotificationService: Sending notification to $receiverId');

      final notificationData = {
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'message': message,
        'type': type,
        'orderId': orderId,
        'driverId': driverId,
        'driverName': driverName,
      };

      final response = await dio.post(
        '/api/notifications/send',
        data: notificationData,
      );
      print('NotificationService: Notification sent successfully');

      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('NotificationService: Error sending notification: $e');
      return null;
    }
  }

  // Get user notifications
  Future<List<NotificationModel>> getNotifications(String receiverId) async {
    try {
      print('NotificationService: Fetching notifications for $receiverId');
      final response = await dio.get('/api/notifications/$receiverId');

      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        print(
          'NotificationService: Found ${notificationsData.length} notifications',
        );

        return notificationsData
            .map((data) => NotificationModel.fromJson(data))
            .toList();
      }

      return [];
    } catch (e) {
      print('NotificationService: Error fetching notifications: $e');
      return [];
    }
  }

  // Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      print(
        'NotificationService: Marking notification as read: $notificationId',
      );
      final response = await dio.patch(
        '/api/notifications/$notificationId/read',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('NotificationService: Error marking as read: $e');
      return false;
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String receiverId) async {
    try {
      final response = await dio.get(
        '/api/notifications/$receiverId/unread-count',
      );

      if (response.statusCode == 200) {
        return response.data['count'] as int? ?? 0;
      }

      return 0;
    } catch (e) {
      print('NotificationService: Error getting unread count: $e');
      return 0;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      print('NotificationService: Deleting notification: $notificationId');
      final response = await dio.delete('/api/notifications/$notificationId');

      return response.statusCode == 200;
    } catch (e) {
      print('NotificationService: Error deleting notification: $e');
      return false;
    }
  }
}
