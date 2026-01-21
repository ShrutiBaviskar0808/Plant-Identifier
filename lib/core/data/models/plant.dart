class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String category; // tree/flower/shrub/succulent
  final String family;
  final String description;
  final PlantCareRequirements careRequirements;
  final List<String> imageUrls;
  final List<String> tags;
  final DateTime createdAt;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.category,
    required this.family,
    required this.description,
    required this.careRequirements,
    this.imageUrls = const [],
    this.tags = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      commonName: json['commonName'] ?? '',
      scientificName: json['scientificName'] ?? '',
      category: json['category'] ?? '',
      family: json['family'] ?? '',
      description: json['description'] ?? '',
      careRequirements: PlantCareRequirements.fromJson(json['careRequirements'] ?? {}),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'category': category,
      'family': family,
      'description': description,
      'careRequirements': careRequirements.toJson(),
      'imageUrls': imageUrls,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PlantCareRequirements {
  final WaterRequirement water;
  final LightRequirement light;
  final String soilType;
  final String growthSeason;
  final TemperatureRange temperature;
  final String fertilizer;
  final String pruning;

  PlantCareRequirements({
    required this.water,
    required this.light,
    required this.soilType,
    required this.growthSeason,
    required this.temperature,
    this.fertilizer = '',
    this.pruning = '',
  });

  factory PlantCareRequirements.fromJson(Map<String, dynamic> json) {
    return PlantCareRequirements(
      water: WaterRequirement.fromJson(json['water'] ?? {}),
      light: LightRequirement.fromJson(json['light'] ?? {}),
      soilType: json['soilType'] ?? '',
      growthSeason: json['growthSeason'] ?? '',
      temperature: TemperatureRange.fromJson(json['temperature'] ?? {}),
      fertilizer: json['fertilizer'] ?? '',
      pruning: json['pruning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water': water.toJson(),
      'light': light.toJson(),
      'soilType': soilType,
      'growthSeason': growthSeason,
      'temperature': temperature.toJson(),
      'fertilizer': fertilizer,
      'pruning': pruning,
    };
  }
}

class WaterRequirement {
  final String frequency; // daily, weekly, bi-weekly, monthly
  final String amount; // low, medium, high
  final String notes;

  WaterRequirement({
    required this.frequency,
    required this.amount,
    this.notes = '',
  });

  factory WaterRequirement.fromJson(Map<String, dynamic> json) {
    return WaterRequirement(
      frequency: json['frequency'] ?? 'weekly',
      amount: json['amount'] ?? 'medium',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'amount': amount,
      'notes': notes,
    };
  }
}

class LightRequirement {
  final String level; // low, medium, high, full-sun, partial-shade
  final int hoursPerDay;
  final String placement; // indoor, outdoor, both

  LightRequirement({
    required this.level,
    required this.hoursPerDay,
    required this.placement,
  });

  factory LightRequirement.fromJson(Map<String, dynamic> json) {
    return LightRequirement(
      level: json['level'] ?? 'medium',
      hoursPerDay: json['hoursPerDay'] ?? 6,
      placement: json['placement'] ?? 'both',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'hoursPerDay': hoursPerDay,
      'placement': placement,
    };
  }
}

class TemperatureRange {
  final int minTemp;
  final int maxTemp;
  final String unit; // celsius, fahrenheit

  TemperatureRange({
    required this.minTemp,
    required this.maxTemp,
    this.unit = 'celsius',
  });

  factory TemperatureRange.fromJson(Map<String, dynamic> json) {
    return TemperatureRange(
      minTemp: json['minTemp'] ?? 15,
      maxTemp: json['maxTemp'] ?? 25,
      unit: json['unit'] ?? 'celsius',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'unit': unit,
    };
  }
}

// User's saved plant with custom data
class UserPlant {
  final String id;
  final Plant plant;
  final String? customName;
  final String? notes;
  final String? group; // indoor, outdoor, edible
  final DateTime dateAdded;
  final String? imagePath; // user's photo

  UserPlant({
    required this.id,
    required this.plant,
    this.customName,
    this.notes,
    this.group,
    DateTime? dateAdded,
    this.imagePath,
  }) : dateAdded = dateAdded ?? DateTime.now();

  factory UserPlant.fromJson(Map<String, dynamic> json) {
    return UserPlant(
      id: json['id'] ?? '',
      plant: Plant.fromJson(json['plant'] ?? {}),
      customName: json['customName'],
      notes: json['notes'],
      group: json['group'],
      dateAdded: DateTime.tryParse(json['dateAdded'] ?? '') ?? DateTime.now(),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant': plant.toJson(),
      'customName': customName,
      'notes': notes,
      'group': group,
      'dateAdded': dateAdded.toIso8601String(),
      'imagePath': imagePath,
    };
  }
}