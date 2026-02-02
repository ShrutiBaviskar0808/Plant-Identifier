import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService {
  static final List<PlantNotification> _notifications = [];
  static bool _isInitialized = false;
  
  static Future<void> _initializeIfNeeded() async {
    if (!_isInitialized) {
      await _loadNotifications();
      _isInitialized = true;
    }
  }
  
  static Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      
      _notifications.clear();
      for (String json in notificationsJson) {
        final Map<String, dynamic> data = jsonDecode(json);
        _notifications.add(PlantNotification.fromJson(data));
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }
  
  static Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = _notifications.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }
  
  static Future<List<PlantNotification>> getNotifications() async {
    await _initializeIfNeeded();
    return List.from(_notifications);
  }
  
  static Future<void> addNotification(PlantNotification notification) async {
    await _initializeIfNeeded();
    _notifications.insert(0, notification);
    // Keep only last 50 notifications
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }
    await _saveNotifications();
  }
  
  static Future<void> markAsRead(String id) async {
    await _initializeIfNeeded();
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _saveNotifications();
    }
  }
  
  static Future<void> clearAll() async {
    await _initializeIfNeeded();
    _notifications.clear();
    await _saveNotifications();
  }
  
  static Future<int> getUnreadCount() async {
    await _initializeIfNeeded();
    return _notifications.where((n) => !n.isRead).length;
  }
  
  // Clear all app data (called when app is uninstalled or reset)
  static Future<void> clearAllAppData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notifications');
      _notifications.clear();
      _isInitialized = false;
    } catch (e) {
      print('Error clearing app data: $e');
    }
  }
  
  static Future<void> scheduleReminderNotification(String plantName, String reminderType, DateTime scheduledTime) async {
    final notification = PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$reminderType Reminder',
      message: 'Time to $reminderType your $plantName',
      type: NotificationType.reminder,
      scheduledTime: scheduledTime,
    );
    
    await addNotification(notification);
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
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.index,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'scheduledTime': scheduledTime?.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }
  
  factory PlantNotification.fromJson(Map<String, dynamic> json) {
    return PlantNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values[json['type']],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      scheduledTime: json['scheduledTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['scheduledTime'])
          : null,
      isRead: json['isRead'] ?? false,
    );
  }
}