import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/notification_model.dart';
import 'package:tracklet_pro/src/service/notification_service.dart';

/// Shared Notification Provider
/// Can be used by both Gas Plant and Distributor
class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => n.isUnread).toList();
  int get unreadCount => unreadNotifications.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch notifications from backend
  Future<void> fetchNotifications(String userId) async {
    debugPrint('NotificationProvider: Fetching notifications for $userId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotifications(userId);
      debugPrint(
        'NotificationProvider: Fetched ${_notifications.length} notifications',
      );
      _errorMessage = null;
    } catch (e) {
      debugPrint('NotificationProvider: Error fetching notifications: $e');
      _errorMessage = 'Failed to fetch notifications';
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send notification
  Future<bool> sendNotification({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
    required String type,
    String orderId = '',
    String driverId = '',
    String driverName = '',
  }) async {
    debugPrint('NotificationProvider: Sending notification');

    try {
      final notification = await _notificationService.sendNotification(
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        message: message,
        type: type,
        orderId: orderId,
        driverId: driverId,
        driverName: driverName,
      );

      if (notification != null) {
        debugPrint('NotificationProvider: Notification sent successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('NotificationProvider: Error sending notification: $e');
      return false;
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final success = await _notificationService.markAsRead(notificationId);

      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            senderId: _notifications[index].senderId,
            senderName: _notifications[index].senderName,
            receiverId: _notifications[index].receiverId,
            message: _notifications[index].message,
            orderId: _notifications[index].orderId,
            driverId: _notifications[index].driverId,
            driverName: _notifications[index].driverName,
            status: 'read',
            type: _notifications[index].type,
            date: _notifications[index].date,
            createdAt: _notifications[index].createdAt,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('NotificationProvider: Error marking as read: $e');
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final success = await _notificationService.deleteNotification(
        notificationId,
      );

      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('NotificationProvider: Error deleting notification: $e');
      return false;
    }
  }

  // Add notification locally (for real-time updates)
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Refresh notifications
  Future<void> refresh(String userId) async {
    await fetchNotifications(userId);
  }
}
