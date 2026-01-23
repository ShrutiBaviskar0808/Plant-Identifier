import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../controllers/identification_controller.dart';

class CameraView extends GetView<IdentificationController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identify Plant', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (!controller.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera Preview
            SizedBox.expand(
              child: CameraPreview(controller.cameraController!),
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
                      onPressed: controller.pickFromGallery,
                      icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                    ),
                    
                    // Capture Button
                    GestureDetector(
                      onTap: controller.takePicture,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: controller.isProcessing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Icon(Icons.camera, color: Colors.white, size: 32),
                      ),
                    ),
                    
                    // Flash Button
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flash_off, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
