import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantCatalogListView extends StatefulWidget {
  const PlantCatalogListView({super.key});

  @override
  State<PlantCatalogListView> createState() => _PlantCatalogListViewState();
}

class _PlantCatalogListViewState extends State<PlantCatalogListView> {
  List<Map<String, dynamic>> plants = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    print('Starting to load plants...');
    
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('Making HTTP request...');
      final response = await http.get(
        Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        print('JSON data type: ${jsonData.runtimeType}');
        
        if (jsonData is Map<String, dynamic>) {
          final List<Map<String, dynamic>> plantList = [];
          
          jsonData.forEach((key, value) {
            if (value is List<dynamic>) {
              print('Processing letter $key with ${value.length} plants');
              for (var plant in value) {
                if (plant is Map<String, dynamic>) {
                  plantList.add({
                    'id': plant['id']?.toString() ?? plantList.length.toString(),
                    'name': plant['name'] ?? 'Unknown Plant',
                    'scientific_name': plant['scientific_name'] ?? '',
                    'description': plant['description'] ?? 'No description available',
                    'image_url': plant['image_url'] ?? '',
                    'water_requirement': plant['water_requirement'] ?? 'Weekly',
                    'light_requirement': plant['light_requirement'] ?? 'Bright light',
                    'difficulty': plant['difficulty'] ?? 'Easy',
                  });
                }
              }
            }
          });

          print('Parsed ${plantList.length} plants');
          
          setState(() {
            plants = plantList;
            isLoading = false;
          });
        } else {
          throw Exception('API returned unexpected data format');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading plants: $e');
      setState(() {
        errorMessage = 'Failed to load plants: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Loading plants...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Failed to load plants',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                _loadPlants();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return _buildPlantCard(plant);
      },
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant) {
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
          child: plant['image_url'] != null && plant['image_url'].isNotEmpty
              ? Image.network(
                  plant['image_url'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.local_florist, color: Colors.grey),
                    );
                  },
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Icon(Icons.local_florist, color: Colors.grey),
                ),
        ),
        title: Text(
          plant['name'] ?? 'Unknown Plant',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plant['scientific_name'] != null && plant['scientific_name'].isNotEmpty)
              Text(
                plant['scientific_name'],
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
                Expanded(
                  child: Text(
                    plant['water_requirement'] ?? 'Weekly',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(plant['difficulty'] ?? 'Easy'),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    plant['difficulty'] ?? 'Easy',
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
          _showPlantDetails(plant);
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'very easy':
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
      case 'difficult':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPlantDetails(Map<String, dynamic> plant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant['image_url'] != null && plant['image_url'].isNotEmpty)
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            plant['image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.local_florist, size: 60, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    Text(
                      plant['name'] ?? 'Unknown Plant',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    if (plant['scientific_name'] != null && plant['scientific_name'].isNotEmpty)
                      Text(
                        plant['scientific_name'],
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                      ),
                    SizedBox(height: 16),
                    if (plant['description'] != null && plant['description'].isNotEmpty)
                      Text(
                        plant['description'],
                        style: TextStyle(fontSize: 16),
                      ),
                    SizedBox(height: 20),
                    Text(
                      'Care Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(Icons.water_drop, 'Watering', plant['water_requirement'] ?? 'Weekly'),
                    _buildInfoRow(Icons.wb_sunny, 'Light', plant['light_requirement'] ?? 'Bright light'),
                    _buildInfoRow(Icons.star, 'Difficulty', plant['difficulty'] ?? 'Easy'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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