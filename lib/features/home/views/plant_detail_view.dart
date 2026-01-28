import 'package:flutter/material.dart';
import '../../../core/data/models/plant_catalog.dart';
import '../../garden/controllers/garden_controller.dart';
import '../../../core/data/models/plant.dart' as PlantModel;
import 'package:get/get.dart';

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
              child: Image.asset(
                plant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
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
                              plant.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              plant.scientificName,
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _saveToGarden(plant),
                        icon: Icon(Icons.add),
                        label: Text('Save to Garden'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
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

  void _saveToGarden(PlantCatalogItem catalogItem) {
    final gardenController = Get.find<GardenController>();
    
    // Convert PlantCatalogItem to Plant
    final newPlant = PlantModel.Plant(
      id: catalogItem.id,
      commonName: catalogItem.name,
      scientificName: catalogItem.scientificName,
      description: catalogItem.description,
      category: 'Houseplant',
      family: 'Unknown',
      careRequirements: PlantModel.PlantCareRequirements(
        water: PlantModel.WaterRequirement(
          frequency: catalogItem.waterRequirement.frequency,
          amount: catalogItem.waterRequirement.amount,
          notes: catalogItem.waterRequirement.description,
        ),
        light: PlantModel.LightRequirement(
          level: 'medium',
          hoursPerDay: 6,
          placement: 'indoor',
        ),
        soilType: catalogItem.soilType,
        growthSeason: catalogItem.growingSeason,
        temperature: PlantModel.TemperatureRange(
          minTemp: 18,
          maxTemp: 24,
          unit: 'celsius',
        ),
        fertilizer: catalogItem.fertilizer,
      ),
      imageUrls: [catalogItem.imageUrl],
    );
    
    gardenController.addPlantToGarden(newPlant);
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