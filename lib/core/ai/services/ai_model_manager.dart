import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../data/models/plant.dart';
import '../../data/models/plant_identification.dart';

class AIModelManager {
  static Interpreter? _plantClassifier;
  static List<String>? _plantLabels;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      // For now, we'll skip loading the actual TensorFlow model
      // and just initialize with mock data
      print('Initializing AI Models (Mock Mode)');
      
      // Load plant labels (mock data for now)
      _plantLabels = await _loadPlantLabels();
      
      _isInitialized = true;
      print('AI Models initialized successfully (Mock Mode)');
    } catch (e) {
      print('Error initializing AI models: $e');
      // Initialize with basic functionality even if models fail to load
      _plantLabels = await _loadPlantLabels();
      _isInitialized = true;
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
    if (!_isInitialized || _plantLabels == null) {
      throw Exception('AI models not initialized');
    }

    try {
      // For now, return mock results since we don't have the actual model
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing time
      
      // Generate mock results
      final results = _generateMockResults();
      
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



  static List<IdentificationResult> _generateMockResults() {
    final results = <IdentificationResult>[];
    
    // Generate 3 mock results with decreasing confidence
    final selectedPlants = _plantLabels!.take(3).toList();
    final confidences = [0.85, 0.72, 0.58];
    
    for (int i = 0; i < selectedPlants.length; i++) {
      results.add(IdentificationResult(
        plant: _createMockPlant(selectedPlants[i]),
        confidence: confidences[i],
      ));
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