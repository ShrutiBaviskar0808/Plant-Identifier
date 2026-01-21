import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalGardenService {
  static const String _plantsKey = 'saved_plants';

  static Future<void> savePlant({
    required String name,
    required double confidence,
    required String imagePath,
    required String healthStatus,
    String? diseaseInfo,
    required Map<String, dynamic> analysisData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing plants
    List<String> existingPlants = prefs.getStringList(_plantsKey) ?? [];
    
    // Create new plant data
    Map<String, dynamic> plantData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'confidence': confidence,
      'imagePath': imagePath,
      'healthStatus': healthStatus,
      'diseaseInfo': diseaseInfo,
      'dateAdded': DateTime.now().toIso8601String(),
      'analysisData': analysisData,
    };
    
    // Add new plant to list
    existingPlants.add(json.encode(plantData));
    
    // Save back to SharedPreferences
    await prefs.setStringList(_plantsKey, existingPlants);
  }

  static Future<List<Map<String, dynamic>>> getAllPlants() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plantsJson = prefs.getStringList(_plantsKey) ?? [];
    
    return plantsJson.map((plantJson) {
      return Map<String, dynamic>.from(json.decode(plantJson));
    }).toList();
  }

  static Future<void> deletePlant(String plantId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingPlants = prefs.getStringList(_plantsKey) ?? [];
    
    existingPlants.removeWhere((plantJson) {
      Map<String, dynamic> plant = json.decode(plantJson);
      return plant['id'] == plantId;
    });
    
    await prefs.setStringList(_plantsKey, existingPlants);
  }
}