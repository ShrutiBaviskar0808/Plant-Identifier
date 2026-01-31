import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/data/services/notification_service.dart';
import '../../identification/views/camera_view.dart';
import '../../identification/views/plant_search_view.dart';
import '../../identification/controllers/identification_controller.dart';
import '../../garden/views/garden_view.dart';
import '../../garden/controllers/garden_controller.dart';

class HomeController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final RxList<CareReminder> _careReminders = <CareReminder>[].obs;
  final RxList<String> _plantTips = <String>[].obs;
  final RxBool _isLoading = false.obs;
  final RxList<PlantAnalytics> _plantAnalytics = <PlantAnalytics>[].obs;
  final RxList<CommunityPost> _communityPosts = <CommunityPost>[].obs;
  final RxInt _notificationCount = 0.obs;

  int get currentIndex => _currentIndex.value;
  List<CareReminder> get careReminders => _careReminders;
  List<String> get plantTips => _plantTips;
  bool get isLoading => _isLoading.value;
  List<PlantAnalytics> get plantAnalytics => _plantAnalytics;
  List<CommunityPost> get communityPosts => _communityPosts;
  int get notificationCount => _notificationCount.value;

  int getUnreadNotificationCount() {
    _notificationCount.value = NotificationService.getUnreadCount();
    return _notificationCount.value;
  }

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
    // Initialize notification count to 0 (no default notifications)
    _notificationCount.value = 0;
  }



  String getIndianTimeGreeting() {
    final now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
    final hour = now.hour;
    
    if (hour >= 4 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 21) return 'Evening';
    return 'Night';
  }

  void changeTabIndex(int index) {
    if (index == 1) {
      // Show camera options dialog when scan tab is tapped
      _showCameraOptionsDialog();
    } else {
      _currentIndex.value = index;
    }
  }

  void _showCameraOptionsDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.green[700]),
            SizedBox(width: 8),
            Expanded(
              child: Text('Choose Camera Option'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCameraOption(
              icon: Icons.camera_alt,
              title: 'Take Photo',
              subtitle: 'Capture a new photo',
              onTap: () {
                Get.back();
                navigateToCamera();
              },
            ),
            SizedBox(height: 12),
            _buildCameraOption(
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              subtitle: 'Select existing photo',
              onTap: () {
                Get.back();
                _pickFromGallery();
              },
            ),
            SizedBox(height: 12),
            _buildCameraOption(
              icon: Icons.search,
              title: 'Search Plants',
              subtitle: 'Browse plant database',
              onTap: () {
                Get.back();
                _navigateToPlantSearch();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green[700]),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _pickFromGallery() {
    final identificationController = Get.put(IdentificationController());
    identificationController.pickFromGallery();
  }

  void _navigateToPlantSearch() {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(builder: (context) => PlantSearchView()),
    );
  }

  void navigateToCamera() {
    try {
      Get.put(IdentificationController());
      Navigator.of(Get.context!).push(
        MaterialPageRoute(builder: (context) => const CameraView()),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToGarden() {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(builder: (context) {
        Get.put(GardenController());
        return const GardenView();
      }),
    );
  }

  Future<void> _loadHomeData() async {
    _isLoading.value = true;
    
    try {
      await Future.wait([
        _loadCareReminders(),
        _loadPlantTips(),
        _loadPlantAnalytics(),
        _loadCommunityPosts(),
      ]);
    } catch (e) {
      print('Error loading home data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadCareReminders() async {
    // Start with empty reminders - only add when user creates them
    _careReminders.clear();
  }

  Future<void> _loadPlantTips() async {
    _plantTips.value = [
      'Water plants early morning for best absorption',
      'Rotate plants weekly for even growth',
      'Check soil moisture before watering',
      'Clean leaves regularly for better photosynthesis',
      'Group plants with similar care needs together',
    ];
  }

  Future<void> _loadPlantAnalytics() async {
    _plantAnalytics.value = [
      PlantAnalytics(
        plantName: 'Monstera Deliciosa',
        growthRate: 85,
        healthScore: 92,
        daysOwned: 45,
        wateringFrequency: 7,
      ),
      PlantAnalytics(
        plantName: 'Snake Plant',
        growthRate: 65,
        healthScore: 88,
        daysOwned: 120,
        wateringFrequency: 14,
      ),
    ];
  }

  Future<void> _loadCommunityPosts() async {
    _communityPosts.value = [
      CommunityPost(
        id: '1',
        username: 'PlantLover123',
        content: 'My Monstera just grew a new leaf! 🌱',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
        likes: 24,
        comments: 5,
        timeAgo: '2h ago',
      ),
      CommunityPost(
        id: '2',
        username: 'GreenThumb',
        content: 'Tips for caring for succulents in winter?',
        imageUrl: null,
        likes: 12,
        comments: 8,
        timeAgo: '4h ago',
      ),
    ];
  }

  Future<void> completeCareTask(String taskId) async {
    try {
      final removedReminder = _careReminders.firstWhere((reminder) => reminder.id == taskId);
      _careReminders.removeWhere((reminder) => reminder.id == taskId);
      
      // Add completion notification
      NotificationService.addNotification(PlantNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Task Completed! 🎉',
        message: '${removedReminder.plantName} ${removedReminder.careType} completed successfully',
        type: NotificationType.general,
      ));
      
      Get.snackbar(
        'Task Completed',
        'Care task marked as complete',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> snoozeCareTask(String taskId) async {
    try {
      // Find and update the task
      final index = _careReminders.indexWhere((reminder) => reminder.id == taskId);
      if (index != -1) {
        final reminder = _careReminders[index];
        _careReminders[index] = CareReminder(
          id: reminder.id,
          plantName: reminder.plantName,
          careType: reminder.careType,
          description: reminder.description,
          dueDate: reminder.dueDate.add(Duration(hours: 1)),
        );
      }
      
      Get.snackbar(
        'Task Snoozed',
        'Reminder postponed by 1 hour',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to snooze task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshHomeData() async {
    await _loadHomeData();
  }

  void navigateToAnalytics() {
    NotificationService.addNotification(PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Analytics Viewed',
      message: 'Check your plant growth progress and health metrics',
      type: NotificationType.general,
    ));
    
    Get.snackbar(
      'Plant Analytics',
      'Track your plant growth and health metrics',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToCommunity() {
    NotificationService.addNotification(PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Community Accessed',
      message: 'Connect with fellow plant enthusiasts and share tips',
      type: NotificationType.general,
    ));
    
    Get.snackbar(
      'Community',
      'Connect with fellow plant enthusiasts',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addReminder(String plantName, String careType, DateTime dueDate) {
    final reminder = CareReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantName: plantName,
      careType: careType,
      description: 'Time to $careType your $plantName',
      dueDate: dueDate,
    );
    _careReminders.add(reminder);
    
    // Add notification for the reminder
    NotificationService.scheduleReminderNotification(plantName, careType, dueDate);
    
    // Add immediate notification
    NotificationService.addNotification(PlantNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Reminder Created',
      message: 'New $careType reminder set for $plantName',
      type: NotificationType.general,
    ));
    
    // Update notification count
    _notificationCount.value = NotificationService.getUnreadCount();
    
    update();
    
    Get.snackbar(
      'Reminder Added',
      'Reminder set for $plantName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Clear all app data (for app reset/uninstall)
  void clearAllData() {
    _careReminders.clear();
    _plantTips.clear();
    _plantAnalytics.clear();
    _communityPosts.clear();
    _notificationCount.value = 0;
    NotificationService.clearAllAppData();
    update();
  }
}

class CareReminder {
  final String id;
  final String plantName;
  final String careType;
  final String description;
  final DateTime dueDate;

  CareReminder({
    required this.id,
    required this.plantName,
    required this.careType,
    required this.description,
    required this.dueDate,
  });
}

class PlantAnalytics {
  final String plantName;
  final int growthRate;
  final int healthScore;
  final int daysOwned;
  final int wateringFrequency;

  PlantAnalytics({
    required this.plantName,
    required this.growthRate,
    required this.healthScore,
    required this.daysOwned,
    required this.wateringFrequency,
  });
}

class CommunityPost {
  final String id;
  final String username;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;

  CommunityPost({
    required this.id,
    required this.username,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}