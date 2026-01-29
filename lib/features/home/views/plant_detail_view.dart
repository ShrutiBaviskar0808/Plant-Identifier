import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/data/models/plant_catalog.dart';

class PlantDetailView extends StatelessWidget {
  final PlantCatalogItem plant;

  const PlantDetailView({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
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
              child: _buildPlantImage(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    plant.scientificName,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    plant.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  _buildCareInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    return Builder(
      builder: (context) => FutureBuilder<bool>(
        future: _checkAssetExists(plant.imageUrl, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }
          
          if (snapshot.hasData && snapshot.data == true) {
            return Image.asset(
              plant.imageUrl,
              fit: BoxFit.cover,
              cacheWidth: kIsWeb ? null : 800,
              cacheHeight: kIsWeb ? null : 600,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            );
          }
          
          return _buildErrorWidget();
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text('Image not available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkAssetExists(String assetPath, BuildContext context) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
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
        _buildInfoRow(Icons.water_drop, 'Watering', '${plant.waterRequirement.frequency} - ${plant.waterRequirement.amount}'),
        _buildInfoRow(Icons.wb_sunny, 'Light', plant.lightRequirement),
        _buildInfoRow(Icons.thermostat, 'Temperature', plant.temperature),
        _buildInfoRow(Icons.grass, 'Soil', plant.soilType),
        _buildInfoRow(Icons.science, 'Fertilizer', plant.fertilizer),
        _buildInfoRow(Icons.warning, 'Toxicity', plant.toxicity),
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