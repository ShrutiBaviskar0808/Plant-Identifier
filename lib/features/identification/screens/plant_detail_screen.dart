import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlantDetailScreen extends StatelessWidget {
  final String plantName;
  final String scientificName;

  const PlantDetailScreen({
    Key? key,
    required this.plantName,
    required this.scientificName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plantName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_florist,
                size: 80,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Plant Names
            Text(
              plantName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 4),
            
            Text(
              scientificName,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Care Information
            _buildSectionCard(
              'Care Information',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCareItem('Water', 'Weekly', Icons.water_drop),
                  _buildCareItem('Light', 'Bright indirect', Icons.wb_sunny),
                  _buildCareItem('Temperature', '18-24°C', Icons.thermostat),
                  _buildCareItem('Humidity', '40-60%', Icons.opacity),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Description
            _buildSectionCard(
              'Description',
              Text(
                'This is a beautiful plant that requires moderate care. It thrives in bright, indirect light and should be watered when the top inch of soil feels dry.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.snackbar(
            'Added to Garden',
            '$plantName has been added to your garden',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        backgroundColor: Colors.green,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add to Garden',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildCareItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}