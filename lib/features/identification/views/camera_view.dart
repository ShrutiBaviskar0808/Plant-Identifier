import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../controllers/identification_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  IdentificationController? controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller only when this screen is created
    controller = Get.put(IdentificationController());
    // Manually trigger camera initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller?.initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Identify Plant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: Obx(() {
          if (!controller!.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // Camera Preview
              SizedBox.expand(
                child: CameraPreview(controller!.cameraController!),
              ),
              
              // Controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery Button
                      IconButton(
                        onPressed: controller!.pickFromGallery,
                        icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                      ),
                      
                      // Capture Button
                      GestureDetector(
                        onTap: controller!.takePicture,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: controller!.isProcessing
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Icon(Icons.camera, color: Colors.white, size: 32),
                        ),
                      ),
                      
                      // Flash Button
                      Obx(() => IconButton(
                        onPressed: controller!.toggleFlash,
                        icon: Icon(
                          controller!.flashMode == 'off' 
                            ? Icons.flash_off
                            : controller!.flashMode == 'auto'
                              ? Icons.flash_auto
                              : Icons.flash_on,
                          color: Colors.white,
                          size: 32,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
