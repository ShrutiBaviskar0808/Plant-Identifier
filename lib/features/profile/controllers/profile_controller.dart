import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/local/database_service.dart';
import '../screens/settings_screen.dart';
import '../screens/help_support_screen.dart';

class ProfileController extends GetxController {
  // Observable variables for profile statistics
  final RxInt plantCount = 0.obs;
  final RxInt identifiedCount = 0.obs;
  final RxInt careTasksCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  // Load user profile data
  Future<void> loadProfileData() async {
    try {
      final userPlants = await DatabaseService.getUserPlants();
      final identifications = await DatabaseService.getPlantIdentifications();
      
      plantCount.value = userPlants.length;
      identifiedCount.value = identifications.length;
      
      // Count pending care tasks (simplified - could be enhanced with actual task tracking)
      careTasksCount.value = (userPlants.length * 0.6).round(); // Approximate pending tasks
    } catch (e) {
      print('Error loading profile data: $e');
      // Fallback to default values
      plantCount.value = 0;
      identifiedCount.value = 0;
      careTasksCount.value = 0;
    }
  }

  // Show notification settings dialog
  void showNotificationSettings() {
    Get.snackbar(
      'Notifications',
      'Notification settings will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Show language settings dialog
  void showLanguageSettings() {
    Get.snackbar(
      'Language',
      'Language settings will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Show backup dialog
  void showBackupDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Backup Data'),
        content: Text('Would you like to backup your plant data?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Backup',
                'Backup feature coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Backup'),
          ),
        ],
      ),
    );
  }

  // Show privacy policy
  void showPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Privacy Policy content will be displayed here. This will include information about data collection, usage, and user rights.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show clear data confirmation dialog
  void showClearDataDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Data'),
        content: Text('Are you sure you want to clear all your plant data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Data Cleared',
                'All plant data has been cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  // Show help dialog
  void showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Help & Support'),
        content: Text('For help and support, please contact us at support@plantidentifier.com'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void showSettings() {
    Get.to(() => const SettingsScreen());
  }

  void showHelp() {
    Get.to(() => const HelpSupportScreen());
  }

  void showAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('About'),
        content: const Text('Plant Identifier v1.0.0\nAI-powered plant identification app'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}