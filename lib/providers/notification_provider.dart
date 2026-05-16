import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';

/// Provider for managing notifications
class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;
  List<NotificationData> _notifications = [];
  int _unreadCount = 0;

  NotificationProvider()
    : _notificationService = NotificationServiceFactory.create() {
    _init();
  }

  List<NotificationData> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _unreadCount;

  Future<void> _init() async {
    await _notificationService.initialize();

    // Listen to notification updates
    _notificationService.notifications.listen((notifications) {
      _notifications = notifications;
      _unreadCount = _notificationService.unreadCount;
      notifyListeners();
    });

    // Get device token
    final token = await _notificationService.getDeviceToken();
    debugPrint('Device notification token: $token');

    // Subscribe to general notifications
    await _notificationService.subscribeToTopic('all_users');
    await _notificationService.subscribeToTopic('order_updates');
    await _notificationService.subscribeToTopic('promotions');
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      _notifications[index] = NotificationData(
        id: _notifications[index].id,
        title: _notifications[index].title,
        body: _notifications[index].body,
        imageUrl: _notifications[index].imageUrl,
        data: _notifications[index].data,
        timestamp: _notifications[index].timestamp,
        isRead: true,
      );
      _unreadCount = _notificationService.unreadCount;
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    await _notificationService.markAllAsRead();
    _notifications = _notifications
        .map(
          (n) => NotificationData(
            id: n.id,
            title: n.title,
            body: n.body,
            imageUrl: n.imageUrl,
            data: n.data,
            timestamp: n.timestamp,
            isRead: true,
          ),
        )
        .toList();
    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> sendTestNotification() async {
    // For demo purposes only
    final now = DateTime.now();
    _notifications.insert(
      0,
      NotificationData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Order Update',
        body:
            'Your order #ORD-${now.millisecondsSinceEpoch % 100000} has been shipped!',
        timestamp: now,
      ),
    );
    _unreadCount++;
    notifyListeners();
  }
}
