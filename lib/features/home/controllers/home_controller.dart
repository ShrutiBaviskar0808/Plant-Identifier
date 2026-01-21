import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final RxList<CareReminder> _careReminders = <CareReminder>[].obs;
  final RxList<String> _plantTips = <String>[].obs;
  final RxBool _isLoading = false.obs;

  int get currentIndex => _currentIndex.value;
  List<CareReminder> get careReminders => _careReminders;
  List<String> get plantTips => _plantTips;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  void changeTabIndex(int index) {
    _currentIndex.value = index;
  }

  void navigateToCamera() {
    Get.toNamed('/camera');
  }

  void navigateToGarden() {
    Get.toNamed('/garden');
  }

  Future<void> _loadHomeData() async {
    _isLoading.value = true;
    
    try {
      // Load care reminders
      await _loadCareReminders();
      
      // Load plant tips
      await _loadPlantTips();
    } catch (e) {
      print('Error loading home data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadCareReminders() async {
    // Mock data - replace with actual service calls
    _careReminders.value = [
      CareReminder(
        id: '1',
        plantName: 'Monstera Deliciosa',
        careType: 'Watering',
        description: 'Time to water your plant',
        dueDate: DateTime.now().add(Duration(hours: 2)),
      ),
      CareReminder(
        id: '2',
        plantName: 'Snake Plant',
        careType: 'Fertilizing',
        description: 'Monthly fertilizer application',
        dueDate: DateTime.now().add(Duration(days: 1)),
      ),
    ];
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

  Future<void> completeCareTask(String taskId) async {
    try {
      // Remove the completed task
      _careReminders.removeWhere((reminder) => reminder.id == taskId);
      
      // Show success message
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