import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_api_model.dart';

class PlantApiService {
  static const String _baseUrl = 'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json';

  static Future<List<PlantApiModel>> fetchPlants() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        
        // The API returns an object with plant IDs as keys
        if (jsonData is Map<String, dynamic>) {
          final List<PlantApiModel> plants = [];
          
          jsonData.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              // Add the ID from the key if not present in the data
              if (!value.containsKey('id')) {
                value['id'] = int.tryParse(key) ?? plants.length + 1;
              }
              plants.add(PlantApiModel.fromJson(value));
            }
          });
          
          return plants;
        } else if (jsonData is List<dynamic>) {
          return jsonData.map((json) => PlantApiModel.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected API response format: ${jsonData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error fetching plants: $e');
    }
  }

  // Alias method for backward compatibility
  static Future<List<PlantApiModel>> fetchPlantsFromApi() async {
    return await fetchPlants();
  }

  // Search plants by name
  static Future<List<PlantApiModel>> searchPlants(String query) async {
    final plants = await fetchPlants();
    return plants.where((plant) => 
      plant.name.toLowerCase().contains(query.toLowerCase()) ||
      plant.scientificName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get plant by ID
  static Future<PlantApiModel?> getPlantById(int id) async {
    final plants = await fetchPlants();
    try {
      return plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  // Mock plant identification from image (placeholder)
  static Future<PlantApiModel?> identifyPlantFromImage(String imagePath) async {
    // This is a mock implementation - in a real app, you'd send the image to an AI service
    final plants = await fetchPlants();
    if (plants.isNotEmpty) {
      // Return a random plant for demo purposes
      return plants[DateTime.now().millisecond % plants.length];
    }
    return null;
  }
}