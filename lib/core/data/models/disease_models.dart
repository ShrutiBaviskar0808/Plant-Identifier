enum DiseaseType {
  fungal,
  bacterial,
  viral,
  pest,
  nutrient,
  environmental;

  String get displayName {
    switch (this) {
      case DiseaseType.fungal:
        return 'Fungal Disease';
      case DiseaseType.bacterial:
        return 'Bacterial Disease';
      case DiseaseType.viral:
        return 'Viral Disease';
      case DiseaseType.pest:
        return 'Pest Infestation';
      case DiseaseType.nutrient:
        return 'Nutrient Deficiency';
      case DiseaseType.environmental:
        return 'Environmental Stress';
    }
  }
}

class DiseaseResult {
  final String id;
  final String name;
  final DiseaseType type;
  final double confidence;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> prevention;

  DiseaseResult({
    required this.id,
    required this.name,
    required this.type,
    required this.confidence,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.prevention,
  });

  factory DiseaseResult.fromJson(Map<String, dynamic> json) {
    return DiseaseResult(
      id: json['id'],
      name: json['name'],
      type: DiseaseType.values[json['type']],
      confidence: json['confidence'].toDouble(),
      description: json['description'],
      symptoms: List<String>.from(json['symptoms']),
      treatments: List<String>.from(json['treatments']),
      prevention: List<String>.from(json['prevention']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'confidence': confidence,
      'description': description,
      'symptoms': symptoms,
      'treatments': treatments,
      'prevention': prevention,
    };
  }
}