import 'package:flutter/material.dart';
import '../../../core/data/models/plant.dart';
import 'dart:io';

class GardenPlantDetailView extends StatelessWidget {
  final UserPlant userPlant;

  const GardenPlantDetailView({super.key, required this.userPlant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userPlant.customName ?? userPlant.plant.commonName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: userPlant.imagePath != null
                  ? Image.file(
                      File(userPlant.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
                        );
                      },
                    )
                  : userPlant.plant.imageUrls.isNotEmpty
                      ? Image.asset(
                          userPlant.plant.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
                        ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userPlant.customName ?? userPlant.plant.commonName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userPlant.plant.scientificName,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Added: ${userPlant.dateAdded.day}/${userPlant.dateAdded.month}/${userPlant.dateAdded.year}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userPlant.plant.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  _buildCareInfo(),
                  if (userPlant.notes != null && userPlant.notes!.isNotEmpty) ...[
                    SizedBox(height: 20),
                    _buildNotesSection(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Care Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildInfoRow(Icons.water_drop, 'Watering', userPlant.plant.description),
        _buildInfoRow(Icons.wb_sunny, 'Light', 'Bright, indirect light'),
        _buildInfoRow(Icons.thermostat, 'Temperature', '65-75°F'),
        _buildInfoRow(Icons.grass, 'Soil', 'Well-draining potting mix'),
        _buildInfoRow(Icons.warning, 'Toxicity', 'Check plant details'),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Notes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            userPlant.notes!,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}