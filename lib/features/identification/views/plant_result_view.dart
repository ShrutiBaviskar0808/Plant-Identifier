import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/data/models/plant.dart';
import '../../garden/controllers/garden_controller.dart';

class PlantResultView extends StatelessWidget {
  final String imagePath;
  final List<Plant> identificationResults;
  final double confidence;

  const PlantResultView({
    super.key,
    required this.imagePath,
    required this.identificationResults,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Plant Identification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageWidget(),
              ),
              
              SizedBox(height: 20),
              
              // Identification Results
              if (identificationResults.isNotEmpty) ...{
                Text(
                  'Identification Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 16),
                
                // Top match
                _buildPlantCard(identificationResults.first, confidence, true),
                
                // Other matches
                if (identificationResults.length > 1) ...{
                  SizedBox(height: 16),
                  Text(
                    'Other Possible Matches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...identificationResults.skip(1).map((plant) => 
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: _buildPlantCard(plant, confidence - 0.1, false),
                    )
                  ),
                },
              } else ...{
                _buildNoResultsCard(),
              },
              
              SizedBox(height: 30),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Scan Another'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (identificationResults.isNotEmpty) ...{
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showSaveDialog(context, identificationResults.first),
                        icon: Icon(Icons.add),
                        label: Text('Save to Garden'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantCard(Plant plant, double confidence, bool isTopMatch) {
    return Card(
      elevation: isTopMatch ? 4 : 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_florist,
                  color: isTopMatch ? Colors.green : Colors.grey[600],
                  size: isTopMatch ? 24 : 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plant.commonName,
                    style: TextStyle(
                      fontSize: isTopMatch ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: isTopMatch ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTopMatch ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(confidence * 100).toInt()}%',
                    style: TextStyle(
                      color: isTopMatch ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              plant.scientificName,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            // Plant Description
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Text(
                plant.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('Category', plant.category),
            _buildInfoRow('Family', plant.family),
            if (isTopMatch) ...{
              SizedBox(height: 12),
              Text(
                'Care Requirements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              _buildCareInfo(plant.careRequirements),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareInfo(PlantCareRequirements care) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildCareRow(Icons.water_drop, 'Water', '${care.water.frequency} - ${care.water.amount}'),
          _buildCareRow(Icons.wb_sunny, 'Light', '${care.light.level} (${care.light.hoursPerDay}h/day)'),
          _buildCareRow(Icons.thermostat, 'Temperature', '${care.temperature.minTemp}-${care.temperature.maxTemp}°C'),
        ],
      ),
    );
  }

  Widget _buildCareRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green[700]),
          SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      width: double.infinity,
      height: 250,
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey[600],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No Plant Identified',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try taking a clearer photo with better lighting, or focus on leaves/flowers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context, Plant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save to Garden'),
        content: Text('Add "${plant.commonName}" to your garden collection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final gardenController = Get.find<GardenController>();
                await gardenController.addPlantToGarden(
                  plant,
                  imagePath: imagePath, // Pass the scanned image path
                );
                Navigator.pop(context);
                Get.snackbar(
                  'Success',
                  'Plant added to your garden!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to save plant: $e',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}