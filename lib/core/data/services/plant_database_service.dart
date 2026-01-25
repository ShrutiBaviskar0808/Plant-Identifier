import '../models/plant.dart';
import 'plant_api_service.dart';

class PlantDatabaseService {
  static final PlantDatabaseService _instance = PlantDatabaseService._internal();
  factory PlantDatabaseService() => _instance;
  PlantDatabaseService._internal();

  final PlantApiService _apiService = PlantApiService();
  final List<Plant> _localPlants = [];

  // Initialize with sample plant data and fetch from API
  Future<void> initializeSampleData() async {
    if (_localPlants.isNotEmpty) return;

    // Add some local sample plants for offline use
    _localPlants.addAll([
      Plant(
        id: 'hibiscus_1',
        commonName: 'Hibiscus',
        scientificName: 'Hibiscus rosa-sinensis',
        category: 'flowering',
        family: 'Malvaceae',
        description: 'Beautiful tropical flowering plant with large, colorful blooms.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'daily',
            amount: 'high',
            notes: 'Keep soil consistently moist, especially during blooming',
          ),
          light: LightRequirement(
            level: 'high',
            hoursPerDay: 8,
            placement: 'outdoor',
          ),
          soilType: 'Rich, well-draining soil',
          growthSeason: 'Year-round in tropical climates',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 35),
          fertilizer: 'Weekly during growing season',
          pruning: 'Regular deadheading to encourage blooms',
        ),
        tags: ['flowering', 'tropical', 'outdoor', 'colorful'],
      ),
      Plant(
        id: 'local_1',
        commonName: 'Monstera Deliciosa',
        scientificName: 'Monstera deliciosa',
        category: 'houseplant',
        family: 'Araceae',
        description: 'Popular indoor plant known for its split leaves and easy care.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'weekly',
            amount: 'medium',
            notes: 'Water when top inch of soil is dry',
          ),
          light: LightRequirement(
            level: 'medium',
            hoursPerDay: 6,
            placement: 'indoor',
          ),
          soilType: 'Well-draining potting mix',
          growthSeason: 'Spring to Fall',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 27),
          fertilizer: 'Monthly during growing season',
          pruning: 'Remove dead leaves as needed',
        ),
        tags: ['indoor', 'tropical', 'easy-care'],
      ),
      Plant(
        id: 'local_2',
        commonName: 'Snake Plant',
        scientificName: 'Sansevieria trifasciata',
        category: 'succulent',
        family: 'Asparagaceae',
        description: 'Low-maintenance succulent perfect for beginners.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'bi-weekly',
            amount: 'low',
            notes: 'Allow soil to dry completely between waterings',
          ),
          light: LightRequirement(
            level: 'low',
            hoursPerDay: 4,
            placement: 'indoor',
          ),
          soilType: 'Cactus/succulent mix',
          growthSeason: 'Spring to Summer',
          temperature: TemperatureRange(minTemp: 15, maxTemp: 30),
          fertilizer: 'Rarely needed',
          pruning: 'Remove damaged leaves',
        ),
        tags: ['indoor', 'succulent', 'low-light', 'beginner'],
      ),
    ]);

    // Try to fetch from API
    try {
      await _apiService.fetchPlantsFromApi();
    } catch (e) {
      print('Failed to fetch plants from API: $e');
    }
  }

  // Search plants from both local and API sources
  Future<List<Plant>> searchPlants(String query) async {
    try {
      // Try API first
      final apiResults = await _apiService.searchPlants(query);
      if (apiResults.isNotEmpty) {
        return apiResults;
      }
    } catch (e) {
      print('API search failed: $e');
    }

    // Fallback to local search
    if (query.isEmpty) return _localPlants;
    
    query = query.toLowerCase();
    return _localPlants.where((plant) {
      return plant.commonName.toLowerCase().contains(query) ||
             plant.scientificName.toLowerCase().contains(query) ||
             plant.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  // Get plants by category
  Future<List<Plant>> getPlantsByCategory(String category) async {
    try {
      final allPlants = await _apiService.fetchPlantsFromApi();
      return allPlants.where((plant) => plant.category == category).toList();
    } catch (e) {
      return _localPlants.where((plant) => plant.category == category).toList();
    }
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final allPlants = await _apiService.fetchPlantsFromApi();
      return allPlants.map((plant) => plant.category).toSet().toList();
    } catch (e) {
      return _localPlants.map((plant) => plant.category).toSet().toList();
    }
  }

  // Get plant by ID
  Future<Plant?> getPlantById(String id) async {
    try {
      // Try API first
      final apiPlant = await _apiService.getPlantById(id);
      if (apiPlant != null) return apiPlant;
    } catch (e) {
      print('API getPlantById failed: $e');
    }

    // Fallback to local
    try {
      return _localPlants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all plants
  Future<List<Plant>> getAllPlants() async {
    try {
      final apiPlants = await _apiService.fetchPlantsFromApi();
      return [...apiPlants, ..._localPlants];
    } catch (e) {
      return List.from(_localPlants);
    }
  }

  // Plant identification from image using API
  Future<List<Plant>> identifyPlantFromImage(String imagePath) async {
    try {
      return await _apiService.identifyPlantFromImage(imagePath);
    } catch (e) {
      print('API identification failed: $e');
      // Fallback to local simulation
      await Future.delayed(Duration(seconds: 2));
      final shuffled = List<Plant>.from(_localPlants)..shuffle();
      return shuffled.take(3).toList();
    }
  }
}