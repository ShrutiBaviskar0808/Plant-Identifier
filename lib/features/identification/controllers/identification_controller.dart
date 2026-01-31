import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../views/plant_result_view.dart';
import '../../../core/data/services/plant_database_service.dart';
import '../../../core/data/services/image_analysis_service.dart';
import '../../../core/data/models/plant.dart';

class IdentificationController extends GetxController {
  CameraController? _cameraController;
  final RxList<CameraDescription> _cameras = <CameraDescription>[].obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isProcessing = false.obs;
  final RxString _flashMode = 'off'.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final PlantDatabaseService _plantService = PlantDatabaseService();
  final ImageAnalysisService _imageAnalysisService = ImageAnalysisService();
  final RxList<Plant> _identificationResults = <Plant>[].obs;

  CameraController? get cameraController => _cameraController;
  List<CameraDescription> get cameras => _cameras;
  bool get isInitialized => _isInitialized.value;
  bool get isProcessing => _isProcessing.value;
  String get flashMode => _flashMode.value;
  List<Plant> get identificationResults => _identificationResults;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    // Don't automatically initialize camera - let it be called manually
  }

  Future<void> _initializeServices() async {
    try {
      await _plantService.initializeSampleData();
    } catch (e) {
      print('Failed to initialize plant service: $e');
    }
  }

  @override
  void onClose() {
    _cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      // Directly request camera permission and setup camera
      await _requestCameraAndTakePhoto();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to initialize camera',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _requestCameraAndTakePhoto() async {
    try {
      // Directly setup camera without showing permission dialog
      await _setupCamera();
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _setupCamera() async {
    try {
      // Request permission first
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        Get.snackbar(
          'Permission Denied',
          'Camera permission is required',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
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
        'Failed to setup camera',
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
      // Validate image file first
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      final fileSize = await imageFile.length();
      if (fileSize == 0) {
        throw Exception('Image file is empty');
      }

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
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Use image analysis service for better identification
      final results = await _imageAnalysisService
          .analyzeImageForPlantIdentification(imageFile.path);
      _identificationResults.value = results;

      // Close loading dialog
      Get.back();

      // Calculate confidence based on results
      double confidence = 0.0;
      if (results.isNotEmpty) {
        confidence = _imageAnalysisService.calculateConfidence(
            results.first, imageFile.path);
      }

      // Navigate to results using Navigator.push
      Navigator.of(Get.context!).push(
        MaterialPageRoute(
          builder: (context) => PlantResultView(
            imagePath: imageFile.path,
            identificationResults: results,
            confidence: confidence,
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error with fallback results
      _showAnalysisError(imageFile.path);
    }
  }

  void _showAnalysisError(String imagePath) {
    // Navigate to results with empty results to show "No Plant Identified"
    Navigator.of(Get.context!).push(
      MaterialPageRoute(
        builder: (context) => PlantResultView(
          imagePath: imagePath,
          identificationResults: [],
          confidence: 0.0,
        ),
      ),
    );
  }

  Future<void> toggleFlash() async {
    if (_cameraController?.value.isInitialized != true) return;

    try {
      switch (_flashMode.value) {
        case 'off':
          await _cameraController!.setFlashMode(FlashMode.auto);
          _flashMode.value = 'auto';
          break;
        case 'auto':
          await _cameraController!.setFlashMode(FlashMode.always);
          _flashMode.value = 'on';
          break;
        case 'on':
          await _cameraController!.setFlashMode(FlashMode.off);
          _flashMode.value = 'off';
          break;
      }
    } catch (e) {
      print('Failed to toggle flash: $e');
    }
  }
}
