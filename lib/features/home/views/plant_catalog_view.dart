import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import '../../garden/controllers/garden_controller.dart';
import '../../../core/data/models/plant.dart';

class PlantCatalogView extends StatefulWidget {
  const PlantCatalogView({super.key});

  @override
  State<PlantCatalogView> createState() => _PlantCatalogViewState();
}

class _PlantCatalogViewState extends State<PlantCatalogView> {
  List<Map<String, dynamic>> plants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json',
        ),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> plantList = [];

        if (jsonData is Map<String, dynamic>) {
          jsonData.forEach((key, value) {
            if (value is List) {
              for (var plant in value) {
                if (plant is Map<String, dynamic>) {
                  // ✅ CORRECT IMAGE EXTRACTION
                  String imageUrl = '';
                  if (plant['images'] is List && plant['images'].isNotEmpty) {
                    imageUrl = plant['images'][0].toString();
                  }

                  plantList.add({
                    'name': plant['name'] ?? 'Unknown Plant',
                    'scientific_name': plant['scientific_name'] ?? '',
                    'image_url': imageUrl,
                    'water_requirement': plant['water_requirement'] ?? 'Weekly',
                    'difficulty': plant['difficulty'] ?? 'Easy',
                    'description': plant['description'] ?? '',
                    'habitat': plant['habitat'] ?? '',
                    'plantInfo': plant['plantInfo'] ?? {},
                  });
                }
              }
            }
          });
        }

        setState(() {
          plants = plantList;
          isLoading = false;
        });
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(plants[index], context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant, BuildContext context) {
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
          child: SizedBox(
            width: 60,
            height: 60,
            child: _buildPlantImage(plant),
          ),
        ),
        title: Text(
          plant['name'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.water_drop, size: 14, color: Colors.blue),
            SizedBox(width: 4),
            Text(
              plant['water_requirement'],
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _addToGarden(plant),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: Text('Add to Garden', style: TextStyle(fontSize: 10)),
        ),
        onTap: () => _showPlantDetails(plant),
      ),
    );
  }

  Widget _buildPlantImage(Map<String, dynamic> plant) {
    final imageUrl = plant['image_url'] ?? '';

    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.green[300],
        child: Icon(Icons.local_florist, color: Colors.white),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: Colors.green[300],
          child: Icon(Icons.local_florist, color: Colors.white),
        );
      },
    );
  }

  void _addToGarden(Map<String, dynamic> plant) {
    final controller = Get.find<GardenController>();

    controller.addPlantToGarden(
      Plant(
        id: plant['name'].toString().replaceAll(' ', '_').toLowerCase(),
        commonName: plant['name'],
        scientificName: plant['scientific_name'],
        category: 'houseplant',
        family: 'Unknown',
        description: plant['description'] ?? 'Added from catalog',
        imageUrls: plant['image_url'].isNotEmpty ? [plant['image_url']] : [],
        tags: [plant['difficulty']],
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: plant['water_requirement'],
            amount: 'medium',
            notes: '',
          ),
          light: LightRequirement(
            level: 'medium',
            hoursPerDay: 6,
            placement: 'indoor',
          ),
          soilType: 'Well-draining',
          growthSeason: 'Spring',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 25),
          fertilizer: 'Monthly',
          pruning: 'As needed',
        ),
      ),
    );
  }

  void _showPlantDetails(Map<String, dynamic> plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PlantDetailScreen(plant: plant),
      ),
    );
  }
}

class _PlantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> plant;

  const _PlantDetailScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    final List<String> images = _getPlantImages();
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            plant['name'],
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
              // Image Slider
              Container(
                height: 250,
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          images[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green[300],
                              child: Icon(Icons.local_florist, size: 60, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1) ..[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[300],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16),
              Text(
                plant['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                plant['scientific_name'],
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              if (plant['description'] != null && plant['description'].isNotEmpty) ...[
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SafeArea(
                  child: Text(
                    plant['description'],
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
                SizedBox(height: 16),
              ],
              if (plant['habitat'] != null && plant['habitat'].isNotEmpty) ...[
                Text(
                  'Habitat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  plant['habitat'],
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 16),
              ],
              Row(
                children: [
                  Icon(Icons.water_drop, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Water: ${plant['water_requirement']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Difficulty: ${plant['difficulty']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add to garden logic here if needed
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add to My Garden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getPlantImages() {
    List<String> images = [];
    
    // Add main image
    if (plant['image_url'] != null && plant['image_url'].isNotEmpty) {
      images.add(plant['image_url']);
    }
    
    // Add additional images from API if available
    if (plant['images'] is List && plant['images'].isNotEmpty) {
      for (var img in plant['images']) {
        if (img != null && img.toString().isNotEmpty) {
          images.add(img.toString());
        }
      }
    }
    
    // Remove duplicates
    images = images.toSet().toList();
    
    // If no images, add placeholder
    if (images.isEmpty) {
      images.add(''); // This will trigger error builder
    }
    
    return images;
  }
}