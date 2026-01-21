import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../app/routes/app_routes.dart';

class IdentificationController extends GetxController {
  CameraController? _cameraController;
  final RxList<CameraDescription> _cameras = <CameraDescription>[].obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isProcessing = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  CameraController? get cameraController => _cameraController;
  List<CameraDescription> get cameras => _cameras;
  bool get isInitialized => _isInitialized.value;
  bool get isProcessing => _isProcessing.value;

  @override
  void onInit() {
    super.onInit();
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
      _processImage(File(picture.path));
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
        _processImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    } finally {
      _isProcessing.value = false;
    }
  }

  void _processImage(File imageFile) {
    Get.toNamed(AppRoutes.plantResult, arguments: imageFile.path);
  }
}