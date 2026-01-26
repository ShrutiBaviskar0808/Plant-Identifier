import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantApiService {
  static const String _baseUrl =
      'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json';

  static final PlantApiService _instance = PlantApiService._internal();
  factory PlantApiService() => _instance;
  PlantApiService._internal();

  List<Plant> _cachedPlants = [];
  bool _isLoaded = false;

  // ✅ UPDATED METHOD (ONLY THIS PART CHANGED)
  Future<List<Plant>> identifyPlantFromImage(String imagePath) async {
    final plants = await fetchPlantsFromApi();
    plants.shuffle();
    return plants.take(3).toList();
  }

  // ---------------- NO CHANGES BELOW ----------------

  Future<List<Plant>> fetchPlantsFromApi() async {
    if (_isLoaded && _cachedPlants.isNotEmpty) {
      return _cachedPlants;
    }

    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _cachedPlants =
            jsonData.map((json) => _mapApiPlantToModel(json)).toList();
        _isLoaded = true;
        return _cachedPlants;
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }

  Plant _mapApiPlantToModel(Map<String, dynamic> json) {
    return Plant(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      commonName: json['name'] ?? json['common_name'] ?? 'Unknown Plant',
      scientificName: json['scientific_name'] ?? json['botanicalName'] ?? '',
      category: _mapCategory(json['category'] ?? json['type'] ?? 'houseplant'),
      family: json['family'] ?? '',
      description: json['description'] ??
          json['care_tips'] ??
          'No description available',
      careRequirements: _mapCareRequirements(json),
      imageUrls: _extractImageUrls(json),
      tags: _extractTags(json),
    );
  }

  String _mapCategory(String apiCategory) {
    final category = apiCategory.toLowerCase();
    if (category.contains('succulent') || category.contains('cactus'))
      return 'succulent';
    if (category.contains('tree') || category.contains('woody')) return 'tree';
    if (category.contains('flower') || category.contains('bloom'))
      return 'flowering';
    if (category.contains('shrub') || category.contains('bush')) return 'shrub';
    return 'houseplant';
  }

  PlantCareRequirements _mapCareRequirements(Map<String, dynamic> json) {
    return PlantCareRequirements(
      water: WaterRequirement(
        frequency:
            _mapWaterFrequency(json['watering'] ?? json['water_frequency']),
        amount: _mapWaterAmount(json['water_amount'] ?? 'medium'),
        notes: json['watering_notes'] ?? json['water_tips'] ?? '',
      ),
      light: LightRequirement(
        level: _mapLightLevel(
            json['light'] ?? json['light_requirement'] ?? 'medium'),
        hoursPerDay:
            _parseLightHours(json['light_hours'] ?? json['daily_light'] ?? 6),
        placement: json['placement'] ?? 'indoor',
      ),
      soilType:
          json['soil'] ?? json['soil_type'] ?? 'Well-draining potting mix',
      growthSeason:
          json['growth_season'] ?? json['growing_season'] ?? 'Spring to Fall',
      temperature: TemperatureRange(
        minTemp: _parseTemp(json['min_temp'] ?? json['temperature_min'] ?? 15),
        maxTemp: _parseTemp(json['max_temp'] ?? json['temperature_max'] ?? 25),
      ),
      fertilizer: json['fertilizer'] ??
          json['feeding'] ??
          'Monthly during growing season',
      pruning: json['pruning'] ??
          json['maintenance'] ??
          'Remove dead leaves as needed',
    );
  }

  String _mapWaterFrequency(dynamic frequency) {
    final freq = frequency.toString().toLowerCase();
    if (freq.contains('daily')) return 'daily';
    if (freq.contains('weekly')) return 'weekly';
    if (freq.contains('bi-weekly')) return 'bi-weekly';
    if (freq.contains('monthly')) return 'monthly';
    return 'weekly';
  }

  String _mapWaterAmount(dynamic amount) {
    final amt = amount.toString().toLowerCase();
    if (amt.contains('low')) return 'low';
    if (amt.contains('high')) return 'high';
    return 'medium';
  }

  String _mapLightLevel(dynamic light) {
    final lightLevel = light.toString().toLowerCase();
    if (lightLevel.contains('low')) return 'low';
    if (lightLevel.contains('high') ||
        lightLevel.contains('bright') ||
        lightLevel.contains('full')) return 'high';
    return 'medium';
  }

  int _parseLightHours(dynamic hours) {
    if (hours is int) return hours;
    if (hours is String) {
      final parsed = int.tryParse(hours);
      if (parsed != null) return parsed;
    }
    return 6;
  }

  int _parseTemp(dynamic temp) {
    if (temp is int) return temp;
    if (temp is String) {
      final parsed = int.tryParse(temp);
      if (parsed != null) return parsed;
    }
    return 20;
  }

  List<String> _extractImageUrls(Map<String, dynamic> json) {
    final images = <String>[];
    if (json['image'] != null) images.add(json['image'].toString());
    if (json['image_url'] != null) images.add(json['image_url'].toString());
    if (json['images'] is List) {
      images.addAll((json['images'] as List).map((e) => e.toString()));
    }
    return images;
  }

  List<String> _extractTags(Map<String, dynamic> json) {
    final tags = <String>[];
    if (json['tags'] is List) {
      tags.addAll((json['tags'] as List).map((e) => e.toString()));
    }
    if (json['characteristics'] is List) {
      tags.addAll((json['characteristics'] as List).map((e) => e.toString()));
    }
    return tags;
  }

  Future<List<Plant>> searchPlants(String query) async {
    final plants = await fetchPlantsFromApi();
    if (query.isEmpty) return plants;

    query = query.toLowerCase();
    return plants.where((plant) {
      return plant.commonName.toLowerCase().contains(query) ||
          plant.scientificName.toLowerCase().contains(query) ||
          plant.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          plant.category.toLowerCase().contains(query);
    }).toList();
  }

  Future<Plant?> getPlantById(String id) async {
    final plants = await fetchPlantsFromApi();
    try {
      return plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }
}
