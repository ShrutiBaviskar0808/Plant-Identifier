import 'plant.dart';

class PlantIdentification {
  final String id;
  final String imagePath;
  final List<IdentificationResult> results;
  final DateTime timestamp;

  PlantIdentification({
    required this.id,
    required this.imagePath,
    required this.results,
    required this.timestamp,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    return PlantIdentification(
      id: json['id'] ?? '',
      imagePath: json['imagePath'] ?? '',
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => IdentificationResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'results': results.map((e) => e.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class IdentificationResult {
  final Plant plant;
  final double confidence;

  IdentificationResult({
    required this.plant,
    required this.confidence,
  });

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    return IdentificationResult(
      plant: Plant.fromJson(json['plant'] ?? {}),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant': plant.toJson(),
      'confidence': confidence,
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
      waterFrequency: json['waterFrequency'] ?? '',
      lightRequirement: json['lightRequirement'] ?? '',
      soilType: json['soilType'] ?? '',
      temperature: json['temperature'] ?? '',
      humidity: json['humidity'] ?? '',
      fertilizer: json['fertilizer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterFrequency': waterFrequency,
      'lightRequirement': lightRequirement,
      'soilType': soilType,
      'temperature': temperature,
      'humidity': humidity,
      'fertilizer': fertilizer,
    };
  }
}