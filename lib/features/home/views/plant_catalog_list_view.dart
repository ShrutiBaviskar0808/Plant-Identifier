import 'package:flutter/material.dart';
import '../../../core/data/models/plant_catalog.dart';
import 'plant_detail_view.dart';

class PlantCatalogListView extends StatelessWidget {
  const PlantCatalogListView({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = PlantCatalogData.getAllPlants();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Catalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50).withValues(alpha: 0.1),
              Color(0xFF8BC34A).withValues(alpha: 0.05),
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: plants.length,
          cacheExtent: 500,
          itemBuilder: (context, index) {
            final plant = plants[index];
            return _buildPlantListItem(plant, context);
          },
        ),
      ),
    );
  }

  Widget _buildPlantListItem(PlantCatalogItem plant, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            plant.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            cacheWidth: 120,
            cacheHeight: 120,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: Icon(
                  Icons.local_florist,
                  size: 30,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),
        title: Text(
          plant.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant.scientificName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.water_drop, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  plant.waterRequirement.frequency,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(plant.difficulty),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    plant.difficulty,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailView(plant: plant),
            ),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'very easy':
        return Colors.green;
      case 'easy':
        return Colors.lightGreen;
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}