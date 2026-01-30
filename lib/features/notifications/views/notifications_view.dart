import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/services/notification_service.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<PlantNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      notifications = NotificationService.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.green[800]),
            SizedBox(width: 8),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
        actions: [
          if (notifications.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                _showClearDialog();
              },
              icon: Icon(Icons.clear_all, size: 18),
              label: Text('Clear All'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildNotificationStats(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(notifications[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none, size: 64, color: Colors.green),
          ),
          SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Plant care reminders and updates will appear here',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              NotificationService.addNotification(PlantNotification(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: 'Test Notification',
                message: 'This is a sample notification to get you started!',
                type: NotificationType.general,
              ));
              _loadNotifications();
            },
            icon: Icon(Icons.add),
            label: Text('Add Sample Notification'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStats() {
    final unreadCount = notifications.where((n) => !n.isRead).length;
    final todayCount = notifications.where((n) => 
      n.timestamp.day == DateTime.now().day &&
      n.timestamp.month == DateTime.now().month &&
      n.timestamp.year == DateTime.now().year
    ).length;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', '${notifications.length}', Icons.notifications, Colors.blue),
          _buildStatItem('Unread', '$unreadCount', Icons.mark_email_unread, Colors.orange),
          _buildStatItem('Today', '$todayCount', Icons.today, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(PlantNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? Colors.grey.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notification.type.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification.type.icon,
            color: notification.type.color,
            size: 24,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                SizedBox(width: 4),
                Text(
                  _formatTime(notification.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Spacer(),
                if (!notification.isRead)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            NotificationService.markAsRead(notification.id);
            _loadNotifications();
          }
        },
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'mark_read',
              child: Row(
                children: [
                  Icon(notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread, size: 18),
                  SizedBox(width: 8),
                  Text(notification.isRead ? 'Mark as Unread' : 'Mark as Read'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'mark_read') {
              NotificationService.markAsRead(notification.id);
              _loadNotifications();
            }
          },
        ),
      ),
    );
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationService.clearAll();
              _loadNotifications();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All notifications have been cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}