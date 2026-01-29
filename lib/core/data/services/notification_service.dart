import 'package:flutter/material.dart';

class NotificationService {
  static final List<PlantNotification> _notifications = [];
  
  static List<PlantNotification> getNotifications() => List.from(_notifications);
  
  static void addNotification(PlantNotification notification) {
    _notifications.insert(0, notification);
    // Keep only last 50 notifications
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }
  }
  
  static void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
  
  static void clearAll() {
    _notifications.clear();
  }
  
  static int getUnreadCount() {
    return _notifications.where((n) => !n.isRead).length;
  }
  
  // Clear all app data (called when app is uninstalled or reset)
  static void clearAllAppData() {
    _notifications.clear();
  }
  
  static void scheduleReminderNotification(String plantName, String reminderType, DateTime scheduledTime) {
    final notification = PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$reminderType Reminder',
      message: 'Time to $reminderType your $plantName',
      type: NotificationType.reminder,
      scheduledTime: scheduledTime,
    );
    
    addNotification(notification);
  }
  
  static void sendWeatherAlert(String title, String message) {
    final notification = PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: NotificationType.weather,
    );
    
    addNotification(notification);
  }
  
  static void sendHealthAlert(String plantName, int healthScore) {
    if (healthScore < 40) {
      final notification = PlantNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Plant Health Alert',
        message: '$plantName needs attention! Health score: $healthScore/100',
        type: NotificationType.health,
      );
      
      addNotification(notification);
    }
  }
}

enum NotificationType {
  reminder,
  weather,
  health,
  general;
  
  IconData get icon {
    switch (this) {
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.weather:
        return Icons.cloud;
      case NotificationType.health:
        return Icons.health_and_safety;
      case NotificationType.general:
        return Icons.info;
    }
  }
  
  Color get color {
    switch (this) {
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.weather:
        return Colors.orange;
      case NotificationType.health:
        return Colors.red;
      case NotificationType.general:
        return Colors.grey;
    }
  }
}

class PlantNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final DateTime? scheduledTime;
  final bool isRead;

  PlantNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    DateTime? timestamp,
    this.scheduledTime,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();

  PlantNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    DateTime? scheduledTime,
    bool? isRead,
  }) {
    return PlantNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isRead: isRead ?? this.isRead,
    );
  }
}