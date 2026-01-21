import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantAPIService {
  static const String _baseUrl = 'https://pp-as-ds.onrender.com';
  
  // Plant identification API
  static Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/plant'),
      );
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to identify plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Plant identification error: $e');
    }
  }
  
  // Disease detection API
  static Future<Map<String, dynamic>> detectDiseases(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/diseases'),
      );
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to detect diseases: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Disease detection error: $e');
    }
  }
  
  // Combined analysis
  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      final results = await Future.wait([
        identifyPlant(imageFile),
        detectDiseases(imageFile),
      ]);
      
      return {
        'plant_identification': results[0],
        'disease_detection': results[1],
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Image analysis error: $e');
    }
  }
}