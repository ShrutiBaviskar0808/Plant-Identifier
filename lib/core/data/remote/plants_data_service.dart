import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantsDataService {
  static const String _plantsUrl = 'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json';
  
  static Future<List<Map<String, dynamic>>> fetchPlantsDatabase() async {
    try {
      final response = await http.get(Uri.parse(_plantsUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch plants database: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Plants database error: $e');
    }
  }
  
  static Future<Map<String, dynamic>?> findPlantByName(String plantName) async {
    try {
      final plants = await fetchPlantsDatabase();
      return plants.firstWhere(
        (plant) => plant['name']?.toString().toLowerCase().contains(plantName.toLowerCase()) ?? false,
        orElse: () => {},
      );
    } catch (e) {
      return null;
    }
  }
  
  static Future<List<Map<String, dynamic>>> searchPlants(String query) async {
    try {
      final plants = await fetchPlantsDatabase();
      return plants.where((plant) {
        final name = plant['name']?.toString().toLowerCase() ?? '';
        final scientificName = plant['scientific_name']?.toString().toLowerCase() ?? '';
        final commonName = plant['common_name']?.toString().toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        
        return name.contains(queryLower) || 
               scientificName.contains(queryLower) || 
               commonName.contains(queryLower);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}