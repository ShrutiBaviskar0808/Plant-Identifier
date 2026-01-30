import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

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
        Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json'),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> plantList = [];
        
        if (jsonData is Map<String, dynamic>) {
          jsonData.forEach((key, value) {
            if (value is List<dynamic>) {
              for (var plant in value) {
                if (plant is Map<String, dynamic>) {
                  final imageUrl = plant['image_url']?.toString() ?? '';
                  print('Plant: ${plant['name']}, Image URL: $imageUrl');
                  plantList.add({
                    'name': plant['name'] ?? 'Unknown Plant',
                    'scientific_name': plant['scientific_name'] ?? '',
                    'image_url': imageUrl,
                    'water_requirement': plant['water_requirement'] ?? 'Weekly',
                    'difficulty': plant['difficulty'] ?? 'Easy',
                  });
                }
              }
            }
          });
        }

        print('Total plants loaded: ${plantList.length}');
        setState(() {
          plants = plantList;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading plants: $e');
      setState(() {
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
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.green))
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return _buildPlantCard(plant, context);
                },
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
          child: Container(
            width: 60,
            height: 60,
            child: Image.network(
              plant['image_url']?.toString() ?? 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=200&h=200&fit=crop',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
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
            Row(
              children: [
                Icon(Icons.water_drop, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  plant['water_requirement'] ?? 'Weekly',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: Text('Add to Garden', style: TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}