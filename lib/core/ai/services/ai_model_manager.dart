import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../data/models/plant.dart';
import '../../data/models/plant_identification.dart';

class AIModelManager {
  static Interpreter? _plantClassifier;
  static List<String>? _plantLabels;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      // Load plant classification model
      _plantClassifier = await Interpreter.fromAsset('assets/models/plant_classifier.tflite');
      
      // Load plant labels (would be loaded from assets)
      _plantLabels = await _loadPlantLabels();
      
      _isInitialized = true;
      print('AI Models initialized successfully');
    } catch (e) {
      print('Error initializing AI models: $e');
      _isInitialized = false;
    }
  }

  static Future<List<String>> _loadPlantLabels() async {
    // Mock labels - in real app, load from assets/data/plant_labels.txt
    return [
      'Rose',
      'Sunflower',
      'Tulip',
      'Daisy',
      'Lily',
      'Orchid',
      'Cactus',
      'Fern',
      'Monstera',
      'Snake Plant',
    ];
  }

  static Future<PlantIdentification> identifyPlant(File imageFile) async {
    if (!_isInitialized || _plantClassifier == null) {
      throw Exception('AI models not initialized');
    }

    try {
      // Preprocess image
      final input = await _preprocessImage(imageFile);
      
      // Run inference
      final output = List.filled(1 * _plantLabels!.length, 0.0).reshape([1, _plantLabels!.length]);
      _plantClassifier!.run(input, output);
      
      // Process results
      final results = _processResults(output[0]);
      
      return PlantIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: imageFile.path,
        results: results,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error identifying plant: $e');
    }
  }

  static Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    // Read and decode image
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Could not decode image');
    }

    // Resize to model input size (224x224)
    final resized = img.copyResize(image, width: 224, height: 224);
    
    // Convert to normalized float values
    final input = List.generate(1, (i) =>
      List.generate(224, (y) =>
        List.generate(224, (x) =>
          List.generate(3, (c) {
            final pixel = resized.getPixel(x, y);
            switch (c) {
              case 0: return img.getRed(pixel) / 255.0;
              case 1: return img.getGreen(pixel) / 255.0;
              case 2: return img.getBlue(pixel) / 255.0;
              default: return 0.0;
            }
          })
        )
      )
    );

    return input;
  }

  static List<IdentificationResult> _processResults(List<double> output) {
    final results = <IdentificationResult>[];
    
    // Create list of (index, confidence) pairs
    final indexedResults = <MapEntry<int, double>>[];
    for (int i = 0; i < output.length; i++) {
      indexedResults.add(MapEntry(i, output[i]));
    }
    
    // Sort by confidence (descending)
    indexedResults.sort((a, b) => b.value.compareTo(a.value));
    
    // Take top 3 results
    for (int i = 0; i < 3 && i < indexedResults.length; i++) {
      final entry = indexedResults[i];
      if (entry.value > 0.1) { // Minimum confidence threshold
        results.add(IdentificationResult(
          plant: _createMockPlant(_plantLabels![entry.key]),
          confidence: entry.value,
        ));
      }
    }
    
    return results;
  }

  static Plant _createMockPlant(String name) {
    // Mock plant data - in real app, fetch from database
    return Plant(
      id: name.toLowerCase().replaceAll(' ', '_'),
      commonName: name,
      scientificName: '$name species',
      family: 'Plant Family',
      category: 'Flowering Plant',
      description: 'A beautiful $name plant.',
      imageUrl: 'assets/images/plants/${name.toLowerCase()}.jpg',
      care: const CareRequirements(
        waterFrequency: 'Weekly',
        lightRequirement: 'Bright indirect light',
        soilType: 'Well-draining',
        temperature: '18-24°C',
        humidity: '40-60%',
        fertilizer: 'Monthly during growing season',
      ),
      tags: ['indoor', 'easy-care'],
    );
  }

  static void dispose() {
    _plantClassifier?.close();
    _plantClassifier = null;
    _plantLabels = null;
    _isInitialized = false;
  }
}