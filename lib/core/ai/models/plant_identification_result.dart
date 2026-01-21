class PlantIdentificationResult {
  final String id;
  final List<PlantMatch> matches;
  final double confidence;
  final int processingTime;
  final String imageUrl;
  final String identificationType;
  final Map<String, double>? location;
  final String? error;

  PlantIdentificationResult({
    required this.id,
    required this.matches,
    required this.confidence,
    required this.processingTime,
    required this.imageUrl,
    required this.identificationType,
    this.location,
    this.error,
  });

  factory PlantIdentificationResult.fromMap(Map<String, dynamic> map) {
    return PlantIdentificationResult(
      id: map['id'] ?? '',
      matches: (map['matches'] as List<dynamic>?)
          ?.map((match) => PlantMatch.fromMap(match))
          .toList() ?? [],
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      processingTime: map['processingTime'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      identificationType: map['identificationType'] ?? '',
      location: map['location'] != null 
          ? Map<String, double>.from(map['location'])
          : null,
      error: map['error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matches': matches.map((match) => match.toMap()).toList(),
      'confidence': confidence,
      'processingTime': processingTime,
      'imageUrl': imageUrl,
      'identificationType': identificationType,
      'location': location,
      'error': error,
    };
  }
}

class PlantMatch {
  final String plantId;
  final String scientificName;
  final String commonName;
  final double confidence;
  final String family;
  final String genus;
  final String species;

  PlantMatch({
    required this.plantId,
    required this.scientificName,
    required this.commonName,
    required this.confidence,
    required this.family,
    required this.genus,
    required this.species,
  });

  factory PlantMatch.fromMap(Map<String, dynamic> map) {
    return PlantMatch(
      plantId: map['plantId'] ?? '',
      scientificName: map['scientificName'] ?? '',
      commonName: map['commonName'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      family: map['family'] ?? '',
      genus: map['genus'] ?? '',
      species: map['species'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'scientificName': scientificName,
      'commonName': commonName,
      'confidence': confidence,
      'family': family,
      'genus': genus,
      'species': species,
    };
  }
}