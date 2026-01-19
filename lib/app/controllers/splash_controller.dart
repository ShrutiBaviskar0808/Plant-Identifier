import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final _isLoading = true.obs;
  final _loadingProgress = 0.0.obs;
  
  bool get isLoading => _isLoading.value;
  double get loadingProgress => _loadingProgress.value;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _updateProgress(0.2, 'Loading AI models...');
      await Future.delayed(const Duration(milliseconds: 800));
      
      await _updateProgress(0.5, 'Setting up database...');
      await Future.delayed(const Duration(milliseconds: 600));
      
      await _updateProgress(0.8, 'Preparing interface...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _updateProgress(1.0, 'Ready!');
      await Future.delayed(const Duration(milliseconds: 300));
      
      _isLoading.value = false;
      
      Get.offAllNamed(AppRoutes.home);
      
    } catch (e) {
      Get.snackbar(
        'Initialization Error',
        'Failed to initialize app: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _updateProgress(double progress, String message) async {
    _loadingProgress.value = progress;
    if (progress == 1.0) {
      HapticFeedback.lightImpact();
    }
  }
}