import 'plant.dart';

class PlantIdentification {
  final String id;
  final String imagePath;
  final List<IdentificationResult> results;
  final DateTime timestamp;

  const PlantIdentification({
    required this.id,
    required this.imagePath,
    required this.results,
    required this.timestamp,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    return PlantIdentification(
      id: json['id'] as String,
      imagePath: json['image_path'] as String,
      results: (json['results'] as List)
          .map((r) => IdentificationResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'results': results.map((r) => r.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class IdentificationResult {
  final Plant plant;
  final double confidence;

  const IdentificationResult({
    required this.plant,
    required this.confidence,
  });

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    return IdentificationResult(
      plant: Plant.fromJson(json['plant'] as Map<String, dynamic>),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant': plant.toJson(),
      'confidence': confidence,
    };
  }
}