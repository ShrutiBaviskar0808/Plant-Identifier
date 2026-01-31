import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/data/models/plant.dart';
import '../../../core/data/services/user_plant_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Identification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
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
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      child: FutureBuilder<bool>(
        future: _checkImageExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }
          
          if (snapshot.hasData && snapshot.data == true) {
            return Image.file(
              File(imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImageErrorWidget();
              },
            );
          }
          
          return _buildImageErrorWidget();
        },
      ),
    );
  }

  Future<bool> _checkImageExists() async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Widget _buildImageErrorWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 48, color: Colors.grey[600]),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No Plant Identified',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try taking a clearer photo with better lighting, or focus on leaves/flowers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context, Plant plant) {
    final nameController = TextEditingController(text: plant.commonName);
    final notesController = TextEditingController();
    String selectedGroup = 'decorative';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save to My Garden'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedGroup,
                decoration: InputDecoration(
                  labelText: 'Group',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ['indoor', 'outdoor', 'edible', 'decorative']
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group.capitalize!),
                        ))
                    .toList(),
                onChanged: (value) => selectedGroup = value!,
              ),
              SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _savePlant(
              context,
              plant,
              nameController.text,
              notesController.text,
              selectedGroup,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePlant(BuildContext context, Plant plant, String customName, String notes, String group) async {
    try {
      final userPlantService = UserPlantService();
      await userPlantService.addPlant(
        plant,
        customName: customName.isNotEmpty ? customName : null,
        notes: notes.isNotEmpty ? notes : null,
        group: group,
        imagePath: imagePath,
      );

      // Refresh garden data
      final gardenController = Get.find<GardenController>();
      await gardenController.loadUserPlants();

      Navigator.of(context).pop(); // Close dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plant saved to your garden successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save plant: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}