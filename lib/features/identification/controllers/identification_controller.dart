import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../app/routes/app_routes.dart';
import '../../../core/data/services/plant_database_service.dart';
import '../../../core/data/models/plant.dart';

class IdentificationController extends GetxController {
  CameraController? _cameraController;
  final RxList<CameraDescription> _cameras = <CameraDescription>[].obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isProcessing = false.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final PlantDatabaseService _plantService = PlantDatabaseService();
  final RxList<Plant> _identificationResults = <Plant>[].obs;

  CameraController? get cameraController => _cameraController;
  List<CameraDescription> get cameras => _cameras;
  bool get isInitialized => _isInitialized.value;
  bool get isProcessing => _isProcessing.value;
  List<Plant> get identificationResults => _identificationResults;

  @override
  void onInit() {
    super.onInit();
    _plantService.initializeSampleData();
    initializeCamera();
  }

  @override
  void onClose() {
    _cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameras.assignAll(cameras);
      
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        _isInitialized.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> takePicture() async {
    if (_cameraController?.value.isInitialized != true) return;

    _isProcessing.value = true;
    try {
      final XFile picture = await _cameraController!.takePicture();
      await _analyzeImage(File(picture.path));
    } catch (e) {
      Get.snackbar('Error', 'Failed to take picture');
    } finally {
      _isProcessing.value = false;
    }
  }

  Future<void> pickFromGallery() async {
    _isProcessing.value = true;
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        await _analyzeImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    } finally {
      _isProcessing.value = false;
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    try {
      // Show loading dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 16),
              Text(
                'AI is analyzing your plant...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
      
      // Identify plant using database service
      final results = await _plantService.identifyPlantFromImage(imageFile.path);
      _identificationResults.value = results;
      
      // Close loading dialog
      Get.back();
      
      // Navigate to results with confidence scores
      Get.toNamed(AppRoutes.plantResult, arguments: {
        'imagePath': imageFile.path,
        'identificationResults': results,
        'confidence': results.isNotEmpty ? 0.95 : 0.0,
      });
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) Get.back();
      
      Get.snackbar(
        'Analysis Failed',
        'Failed to analyze image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}