class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final String category;
  final String description;
  final String imageUrl;
  final CareRequirements care;
  final List<String> tags;

  const Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.care,
    required this.tags,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      commonName: json['common_name'] as String,
      scientificName: json['scientific_name'] as String,
      family: json['family'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      care: CareRequirements.fromJson(json['care'] as Map<String, dynamic>),
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'family': family,
      'category': category,
      'description': description,
      'image_url': imageUrl,
      'care': care.toJson(),
      'tags': tags,
    };
  }
}

class CareRequirements {
  final String waterFrequency;
  final String lightRequirement;
  final String soilType;
  final String temperature;
  final String humidity;
  final String fertilizer;

  const CareRequirements({
    required this.waterFrequency,
    required this.lightRequirement,
    required this.soilType,
    required this.temperature,
    required this.humidity,
    required this.fertilizer,
  });

  factory CareRequirements.fromJson(Map<String, dynamic> json) {
    return CareRequirements(
      waterFrequency: json['water_frequency'] as String,
      lightRequirement: json['light_requirement'] as String,
      soilType: json['soil_type'] as String,
      temperature: json['temperature'] as String,
      humidity: json['humidity'] as String,
      fertilizer: json['fertilizer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water_frequency': waterFrequency,
      'light_requirement': lightRequirement,
      'soil_type': soilType,
      'temperature': temperature,
      'humidity': humidity,
      'fertilizer': fertilizer,
    };
  }
}