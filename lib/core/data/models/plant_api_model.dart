class PlantApiModel {
  final int id;
  final String name;
  final String scientificName;
  final String description;
  final String imageUrl;
  final String waterRequirement;
  final String lightRequirement;
  final String soilType;
  final String temperature;
  final String humidity;
  final String fertilizer;
  final String toxicity;
  final String difficulty;
  final String matureSize;
  final String growingSeason;
  final List<String> benefits;

  PlantApiModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.waterRequirement,
    required this.lightRequirement,
    required this.soilType,
    required this.temperature,
    required this.humidity,
    required this.fertilizer,
    required this.toxicity,
    required this.difficulty,
    required this.matureSize,
    required this.growingSeason,
    required this.benefits,
  });

  factory PlantApiModel.fromJson(Map<String, dynamic> json) {
    return PlantApiModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      name: json['name'] ?? json['common_name'] ?? json['plant_name'] ?? 'Unknown Plant',
      scientificName: json['scientific_name'] ?? json['scientificName'] ?? json['latin_name'] ?? '',
      description: json['description'] ?? json['desc'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['image'] ?? '',
      waterRequirement: json['water_requirement'] ?? json['watering'] ?? json['water'] ?? 'Weekly',
      lightRequirement: json['light_requirement'] ?? json['light'] ?? json['lighting'] ?? 'Bright indirect light',
      soilType: json['soil_type'] ?? json['soil'] ?? 'Well-draining potting mix',
      temperature: json['temperature'] ?? json['temp'] ?? '65-75°F (18-24°C)',
      humidity: json['humidity'] ?? '40-60%',
      fertilizer: json['fertilizer'] ?? json['feeding'] ?? 'Monthly during growing season',
      toxicity: json['toxicity'] ?? json['toxic'] ?? 'Unknown',
      difficulty: json['difficulty'] ?? json['care_level'] ?? 'Easy',
      matureSize: json['mature_size'] ?? json['size'] ?? '1-3 feet',
      growingSeason: json['growing_season'] ?? json['season'] ?? 'Spring to Fall',
      benefits: _parseStringList(json['benefits'] ?? json['tags'] ?? []),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    } else if (value is String) {
      return value.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'image_url': imageUrl,
      'water_requirement': waterRequirement,
      'light_requirement': lightRequirement,
      'soil_type': soilType,
      'temperature': temperature,
      'humidity': humidity,
      'fertilizer': fertilizer,
      'toxicity': toxicity,
      'difficulty': difficulty,
      'mature_size': matureSize,
      'growing_season': growingSeason,
      'benefits': benefits,
    };
  }
}