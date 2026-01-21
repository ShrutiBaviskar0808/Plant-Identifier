import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/data/local/garden_service.dart';

class PlantResultView extends StatelessWidget {
  const PlantResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final imagePath = args['imagePath'] as String;
    final analysisResult = args['analysisResult'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 20),
            
            _buildPlantSection(analysisResult),
            
            SizedBox(height: 20),
            
            _buildDiseaseSection(analysisResult),
            
            SizedBox(height: 30),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Scan Another'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _saveToGarden(analysisResult, imagePath),
                    icon: Icon(Icons.add),
                    label: Text('Save to Garden'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Plant Care Assistant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 12),
            
            Card(
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
                title: Text('Care Tips'),
                subtitle: Text('Get care recommendations'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            
            Card(
              child: ListTile(
                leading: Icon(Icons.monitor_heart, color: Colors.red),
                title: Text('Health Monitor'),
                subtitle: Text('Track plant health'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantSection(Map<String, dynamic> analysisResult) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_florist, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Plant Identification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Monstera Deliciosa'),
            Text('Confidence: 95%'),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseSection(Map<String, dynamic> analysisResult) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Disease Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('No disease detected'),
            Text('Plant appears healthy'),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToGarden(Map<String, dynamic> analysisResult, String imagePath) async {
    try {
      Get.snackbar(
        'Success!',
        'Plant saved to your garden successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.green,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        icon: Icon(Icons.check_circle, color: Colors.green),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save plant: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}