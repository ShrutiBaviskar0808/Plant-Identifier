import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comprehensive_plant.dart';

class PlantEncyclopediaService {
  static const String _baseUrl = 'https://api.plantencyclopedia.com/v1';
  static const String _apiKey = 'YOUR_API_KEY';
  
  // Search plants with advanced filters
  Future<PlantSearchResult> searchPlants({
    required String query,
    PlantSearchFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
        if (filters != null) ...filters.toQueryParams(),
      };
      
      final uri = Uri.parse('$_baseUrl/plants/search').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlantSearchResult.fromJson(data);
      } else {
        throw Exception('Failed to search plants: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Search failed: $e');
    }
  }

  // Get detailed plant information
  Future<ComprehensivePlant> getPlantDetails(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/$plantId'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ComprehensivePlant.fromJson(data);
      } else {
        throw Exception('Failed to get plant details: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get plant details: $e');
    }
  }

  // Get plant care guide
  Future<PlantCareGuide> getPlantCareGuide(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/$plantId/care-guide'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlantCareGuide.fromJson(data);
      } else {
        throw Exception('Failed to get care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get care guide: $e');
    }
  }

  // Get plant diseases and treatments
  Future<List<PlantDisease>> getPlantDiseases(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/$plantId/diseases'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['diseases'] as List)
            .map((disease) => PlantDisease.fromJson(disease))
            .toList();
      } else {
        throw Exception('Failed to get diseases: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get diseases: $e');
    }
  }

  // Get seasonal care calendar
  Future<SeasonalCareCalendar> getSeasonalCareCalendar(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/$plantId/seasonal-care'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SeasonalCareCalendar.fromJson(data);
      } else {
        throw Exception('Failed to get seasonal care: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get seasonal care: $e');
    }
  }

  // Get plant compatibility for companion planting
  Future<List<PlantCompatibility>> getPlantCompatibility(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/$plantId/compatibility'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['compatibility'] as List)
            .map((comp) => PlantCompatibility.fromJson(comp))
            .toList();
      } else {
        throw Exception('Failed to get compatibility: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get compatibility: $e');
    }
  }

  // Get trending plants
  Future<List<TrendingPlant>> getTrendingPlants({
    String region = 'global',
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants/trending?region=$region&limit=$limit'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['trending'] as List)
            .map((plant) => TrendingPlant.fromJson(plant))
            .toList();
      } else {
        throw Exception('Failed to get trending plants: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get trending plants: $e');
    }
  }

  // Get plant categories
  Future<List<PlantCategory>> getPlantCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/categories'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['categories'] as List)
            .map((category) => PlantCategory.fromJson(category))
            .toList();
      } else {
        throw Exception('Failed to get categories: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get categories: $e');
    }
  }

  // Get plants by location/climate
  Future<List<ComprehensivePlant>> getPlantsByLocation({
    required double latitude,
    required double longitude,
    String? climateZone,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'limit': limit.toString(),
        if (climateZone != null) 'zone': climateZone,
      };
      
      final uri = Uri.parse('$_baseUrl/plants/by-location').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['plants'] as List)
            .map((plant) => ComprehensivePlant.fromJson(plant))
            .toList();
      } else {
        throw Exception('Failed to get plants by location: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get plants by location: $e');
    }
  }

  // Get plant care tips
  Future<List<CareTip>> getCareTips({
    String? plantId,
    CareType? careType,
    String? season,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        if (plantId != null) 'plant_id': plantId,
        if (careType != null) 'care_type': careType.name,
        if (season != null) 'season': season,
      };
      
      final uri = Uri.parse('$_baseUrl/care-tips').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['tips'] as List)
            .map((tip) => CareTip.fromJson(tip))
            .toList();
      } else {
        throw Exception('Failed to get care tips: ${response.statusCode}');
      }
    } catch (e) {
      throw PlantEncyclopediaException('Failed to get care tips: $e');
    }
  }
}

// Supporting classes
class PlantSearchResult {
  final List<ComprehensivePlant> plants;
  final int totalCount;
  final int page;
  final int totalPages;
  final PlantSearchFilters? appliedFilters;

  PlantSearchResult({
    required this.plants,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    this.appliedFilters,
  });

  factory PlantSearchResult.fromJson(Map<String, dynamic> json) {
    return PlantSearchResult(
      plants: (json['plants'] as List)
          .map((plant) => ComprehensivePlant.fromJson(plant))
          .toList(),
      totalCount: json['total_count'],
      page: json['page'],
      totalPages: json['total_pages'],
      appliedFilters: json['applied_filters'] != null
          ? PlantSearchFilters.fromJson(json['applied_filters'])
          : null,
    );
  }
}

class PlantSearchFilters {
  final List<PlantType>? types;
  final List<String>? families;
  final LightLevel? lightRequirement;
  final WaterFrequency? waterRequirement;
  final bool? petFriendly;
  final bool? airPurifying;
  final DifficultyLevel? careLevel;
  final List<String>? climateZones;
  final bool? indoorSuitable;
  final bool? outdoorSuitable;

  PlantSearchFilters({
    this.types,
    this.families,
    this.lightRequirement,
    this.waterRequirement,
    this.petFriendly,
    this.airPurifying,
    this.careLevel,
    this.climateZones,
    this.indoorSuitable,
    this.outdoorSuitable,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    
    if (types != null) {
      params['types'] = types!.map((t) => t.name).join(',');
    }
    if (families != null) {
      params['families'] = families!.join(',');
    }
    if (lightRequirement != null) {
      params['light'] = lightRequirement!.name;
    }
    if (waterRequirement != null) {
      params['water'] = waterRequirement!.name;
    }
    if (petFriendly != null) {
      params['pet_friendly'] = petFriendly.toString();
    }
    if (airPurifying != null) {
      params['air_purifying'] = airPurifying.toString();
    }
    if (careLevel != null) {
      params['care_level'] = careLevel!.name;
    }
    if (climateZones != null) {
      params['climate_zones'] = climateZones!.join(',');
    }
    if (indoorSuitable != null) {
      params['indoor'] = indoorSuitable.toString();
    }
    if (outdoorSuitable != null) {
      params['outdoor'] = outdoorSuitable.toString();
    }
    
    return params;
  }

  factory PlantSearchFilters.fromJson(Map<String, dynamic> json) {
    return PlantSearchFilters(
      types: json['types'] != null
          ? (json['types'] as List)
              .map((t) => PlantType.values.firstWhere((type) => type.name == t))
              .toList()
          : null,
      families: json['families'] != null
          ? List<String>.from(json['families'])
          : null,
      lightRequirement: json['light'] != null
          ? LightLevel.values.firstWhere((l) => l.name == json['light'])
          : null,
      waterRequirement: json['water'] != null
          ? WaterFrequency.values.firstWhere((w) => w.name == json['water'])
          : null,
      petFriendly: json['pet_friendly'],
      airPurifying: json['air_purifying'],
      careLevel: json['care_level'] != null
          ? DifficultyLevel.values.firstWhere((d) => d.name == json['care_level'])
          : null,
      climateZones: json['climate_zones'] != null
          ? List<String>.from(json['climate_zones'])
          : null,
      indoorSuitable: json['indoor'],
      outdoorSuitable: json['outdoor'],
    );
  }
}

enum DifficultyLevel { beginner, intermediate, advanced, expert }

class PlantCareGuide {
  final String plantId;
  final String title;
  final String overview;
  final List<CareSection> sections;
  final List<String> quickTips;
  final List<String> commonMistakes;
  final DateTime lastUpdated;

  PlantCareGuide({
    required this.plantId,
    required this.title,
    required this.overview,
    required this.sections,
    required this.quickTips,
    required this.commonMistakes,
    required this.lastUpdated,
  });

  factory PlantCareGuide.fromJson(Map<String, dynamic> json) {
    return PlantCareGuide(
      plantId: json['plant_id'],
      title: json['title'],
      overview: json['overview'],
      sections: (json['sections'] as List)
          .map((section) => CareSection.fromJson(section))
          .toList(),
      quickTips: List<String>.from(json['quick_tips'] ?? []),
      commonMistakes: List<String>.from(json['common_mistakes'] ?? []),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}

class CareSection {
  final String title;
  final String content;
  final List<String> steps;
  final List<String> images;
  final CareType type;

  CareSection({
    required this.title,
    required this.content,
    required this.steps,
    required this.images,
    required this.type,
  });

  factory CareSection.fromJson(Map<String, dynamic> json) {
    return CareSection(
      title: json['title'],
      content: json['content'],
      steps: List<String>.from(json['steps'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      type: CareType.values.firstWhere((t) => t.name == json['type']),
    );
  }
}

class PlantDisease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<Treatment> treatments;
  final String prevention;
  final List<String> images;
  final DiseaseSeverity severity;

  PlantDisease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.prevention,
    required this.images,
    required this.severity,
  });

  factory PlantDisease.fromJson(Map<String, dynamic> json) {
    return PlantDisease(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      causes: List<String>.from(json['causes'] ?? []),
      treatments: (json['treatments'] as List)
          .map((treatment) => Treatment.fromJson(treatment))
          .toList(),
      prevention: json['prevention'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      severity: DiseaseSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => DiseaseSeverity.mild,
      ),
    );
  }
}

enum DiseaseSeverity { mild, moderate, severe, critical }

class Treatment {
  final String name;
  final String description;
  final List<String> steps;
  final String type; // organic, chemical, biological
  final String effectiveness;

  Treatment({
    required this.name,
    required this.description,
    required this.steps,
    required this.type,
    required this.effectiveness,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      name: json['name'],
      description: json['description'],
      steps: List<String>.from(json['steps'] ?? []),
      type: json['type'],
      effectiveness: json['effectiveness'],
    );
  }
}

class SeasonalCareCalendar {
  final String plantId;
  final Map<String, SeasonalCare> seasonalCare;

  SeasonalCareCalendar({
    required this.plantId,
    required this.seasonalCare,
  });

  factory SeasonalCareCalendar.fromJson(Map<String, dynamic> json) {
    final seasonalCareMap = <String, SeasonalCare>{};
    
    for (final entry in (json['seasonal_care'] as Map<String, dynamic>).entries) {
      seasonalCareMap[entry.key] = SeasonalCare.fromJson(entry.value);
    }
    
    return SeasonalCareCalendar(
      plantId: json['plant_id'],
      seasonalCare: seasonalCareMap,
    );
  }
}

class SeasonalCare {
  final String season;
  final List<String> tasks;
  final Map<String, String> adjustments;
  final List<String> tips;

  SeasonalCare({
    required this.season,
    required this.tasks,
    required this.adjustments,
    required this.tips,
  });

  factory SeasonalCare.fromJson(Map<String, dynamic> json) {
    return SeasonalCare(
      season: json['season'],
      tasks: List<String>.from(json['tasks'] ?? []),
      adjustments: Map<String, String>.from(json['adjustments'] ?? {}),
      tips: List<String>.from(json['tips'] ?? []),
    );
  }
}

class PlantCompatibility {
  final String companionPlantId;
  final String companionPlantName;
  final CompatibilityType type;
  final String reason;
  final double score;

  PlantCompatibility({
    required this.companionPlantId,
    required this.companionPlantName,
    required this.type,
    required this.reason,
    required this.score,
  });

  factory PlantCompatibility.fromJson(Map<String, dynamic> json) {
    return PlantCompatibility(
      companionPlantId: json['companion_plant_id'],
      companionPlantName: json['companion_plant_name'],
      type: CompatibilityType.values.firstWhere(
        (t) => t.name == json['type'],
      ),
      reason: json['reason'],
      score: json['score']?.toDouble() ?? 0.0,
    );
  }
}

enum CompatibilityType { beneficial, neutral, harmful }

class TrendingPlant {
  final String id;
  final String name;
  final String imageUrl;
  final double trendScore;
  final String trendReason;

  TrendingPlant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.trendScore,
    required this.trendReason,
  });

  factory TrendingPlant.fromJson(Map<String, dynamic> json) {
    return TrendingPlant(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      trendScore: json['trend_score']?.toDouble() ?? 0.0,
      trendReason: json['trend_reason'],
    );
  }
}

class PlantCategory {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int plantCount;

  PlantCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.plantCount,
  });

  factory PlantCategory.fromJson(Map<String, dynamic> json) {
    return PlantCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['icon_url'],
      plantCount: json['plant_count'],
    );
  }
}

class CareTip {
  final String id;
  final String title;
  final String content;
  final CareType type;
  final String? season;
  final DifficultyLevel level;
  final List<String> tags;

  CareTip({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.season,
    required this.level,
    required this.tags,
  });

  factory CareTip.fromJson(Map<String, dynamic> json) {
    return CareTip(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: CareType.values.firstWhere((t) => t.name == json['type']),
      season: json['season'],
      level: DifficultyLevel.values.firstWhere((l) => l.name == json['level']),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

enum CareType {
  watering,
  lighting,
  fertilizing,
  pruning,
  repotting,
  healthCheck,
}

class PlantEncyclopediaException implements Exception {
  final String message;
  PlantEncyclopediaException(this.message);
  
  @override
  String toString() => 'PlantEncyclopediaException: $message';
}