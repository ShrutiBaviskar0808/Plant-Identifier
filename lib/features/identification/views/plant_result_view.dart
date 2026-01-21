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
            
            _buildPlantSection(analysisResult['plant_identification']),
            
            SizedBox(height: 20),
            
            _buildDiseaseSection(analysisResult['disease_detection']),
            
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
          ],
        ),
      ),
    );
  }

  Widget _buildPlantSection(Map<String, dynamic>? plantData) {
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
            
            if (plantData != null) ...[
              _buildPlantInfo(plantData),
            ] else ...[
              Text(
                'No plant data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfo(Map<String, dynamic> plantData) {
    String plantName = 'Unknown Plant';
    double confidence = 0.0;
    
    if (plantData['any_plants'] != null && plantData['any_plants'].isNotEmpty) {
      final plant = plantData['any_plants'][0];
      plantName = plant['name'] ?? plant['en_name'] ?? 'Unknown Plant';
      
      if (plant['images'] != null && plant['images'].isNotEmpty) {
        confidence = (plant['images'][0]['score'] ?? 0.0).toDouble();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Plant Name', plantName),
        _buildInfoRow('Confidence', '${(confidence * 100).toStringAsFixed(1)}%'),
        _buildInfoRow('Plant Detected', plantData['plant_detected']?.toString() ?? 'Unknown'),
      ],
    );
  }

  Widget _buildDiseaseSection(Map<String, dynamic>? diseaseData) {
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
            
            if (diseaseData != null) ...[
              _buildDiseaseInfo(diseaseData),
            ] else ...[
              Text(
                'No disease data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(Map<String, dynamic> diseaseData) {
    double confidence = (diseaseData['confidence'] ?? 0.0).toDouble();
    bool isHealthy = diseaseData['is_healthy'] == true;
    String diseaseType = 'Healthy - No disease detected';
    String treatment = '';
    
    // Check if disease is actually detected
    if (!isHealthy && confidence > 0.3) {
      if (diseaseData['disease_info'] != null) {
        final diseaseInfo = diseaseData['disease_info'];
        if (diseaseInfo['sections'] != null && diseaseInfo['sections'].isNotEmpty) {
          final section = diseaseInfo['sections'][0];
          diseaseType = section['theader'] ?? 'Disease Detected';
          String rawText = section['text'] ?? '';
          treatment = _extractTreatment(rawText);
        }
      } else {
        diseaseType = 'Disease Detected';
        treatment = 'Consult a plant specialist for proper diagnosis and treatment.';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Disease Type', diseaseType),
        _buildInfoRow('Confidence', '${(confidence * 100).toStringAsFixed(1)}%'),
        _buildInfoRow('Health Status', isHealthy ? 'Healthy' : 'Disease Detected'),
        
        if (!isHealthy && treatment.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            'Treatment Advice:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              treatment,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
    );
  }

  String _extractTreatment(String rawText) {
    if (rawText.isEmpty) return 'Consult a plant specialist for treatment';
    
    List<String> sentences = rawText.split('.');
    List<String> treatmentSentences = [];
    
    for (String sentence in sentences) {
      sentence = sentence.trim();
      if (sentence.isNotEmpty && 
          !sentence.contains('http') && 
          !sentence.contains('image_') &&
          !sentence.contains('probability') &&
          sentence.length > 20) {
        treatmentSentences.add(sentence);
        if (treatmentSentences.length >= 2) break;
      }
    }
    
    return treatmentSentences.isEmpty 
        ? 'Consult a plant specialist for treatment'
        : treatmentSentences.join('. ') + '.';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToGarden(Map<String, dynamic> analysisResult, String imagePath) async {
    try {
      String plantName = 'Unknown Plant';
      double confidence = 0.0;
      String healthStatus = 'Unknown';
      String diseaseInfo = '';
      
      // Extract plant info
      if (analysisResult['plant_identification'] != null) {
        final plantData = analysisResult['plant_identification'];
        if (plantData['any_plants'] != null && plantData['any_plants'].isNotEmpty) {
          final plant = plantData['any_plants'][0];
          plantName = plant['name'] ?? plant['en_name'] ?? 'Unknown Plant';
          if (plant['images'] != null && plant['images'].isNotEmpty) {
            confidence = (plant['images'][0]['score'] ?? 0.0).toDouble();
          }
        }
      }
      
      // Extract disease info
      if (analysisResult['disease_detection'] != null) {
        final diseaseData = analysisResult['disease_detection'];
        bool isHealthy = diseaseData['is_healthy'] == true;
        healthStatus = isHealthy ? 'Healthy' : 'Disease Detected';
        
        if (!isHealthy && diseaseData['disease_info'] != null) {
          final diseaseInfoData = diseaseData['disease_info'];
          if (diseaseInfoData['sections'] != null && diseaseInfoData['sections'].isNotEmpty) {
            diseaseInfo = diseaseInfoData['sections'][0]['theader'] ?? 'Disease Detected';
          }
        }
      }
      
      await GardenService.savePlant(
        name: plantName,
        confidence: confidence,
        imagePath: imagePath,
        diseaseInfo: diseaseInfo.isNotEmpty ? diseaseInfo : null,
        healthStatus: healthStatus,
        analysisData: analysisResult,
      );
      
      Get.snackbar(
        'Success!',
        'Plant saved to your garden successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save plant: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
      );
    }
  }
}