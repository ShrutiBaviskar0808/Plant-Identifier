import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/identification_controller.dart';

class PlantResultView extends GetView<IdentificationController> {
  const PlantResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final String imagePath = Get.arguments as String? ?? '';
    
    if (imagePath.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Plant Results')),
        body: const Center(
          child: Text('No image provided'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Results
            Text(
              'Identification Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mock results for now
            _buildResultCard(
              context,
              'Rose',
              'Rosa rubiginosa',
              0.95,
              'A beautiful flowering plant known for its fragrance.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String commonName, String scientificName, double confidence, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commonName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        scientificName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(confidence * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addToGarden(),
              child: const Text('Add to My Garden'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareResults() {
    Get.snackbar('Share', 'Sharing functionality coming soon!');
  }

  void _addToGarden() {
    Get.snackbar('Success', 'Plant added to your garden!');
  }
}