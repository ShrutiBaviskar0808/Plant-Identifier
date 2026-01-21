import '../models/plant.dart';

class PlantDatabaseService {
  static final PlantDatabaseService _instance = PlantDatabaseService._internal();
  factory PlantDatabaseService() => _instance;
  PlantDatabaseService._internal();

  final List<Plant> _plants = [];

  // Initialize with sample plant data
  void initializeSampleData() {
    if (_plants.isNotEmpty) return;

    _plants.addAll([
      Plant(
        id: '1',
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
        id: '2',
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
      Plant(
        id: '3',
        commonName: 'Peace Lily',
        scientificName: 'Spathiphyllum wallisii',
        category: 'flowering',
        family: 'Araceae',
        description: 'Elegant flowering plant that thrives in low light.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'weekly',
            amount: 'medium',
            notes: 'Keep soil consistently moist but not soggy',
          ),
          light: LightRequirement(
            level: 'low',
            hoursPerDay: 4,
            placement: 'indoor',
          ),
          soilType: 'Well-draining potting soil',
          growthSeason: 'Year-round',
          temperature: TemperatureRange(minTemp: 16, maxTemp: 25),
          fertilizer: 'Monthly with diluted liquid fertilizer',
          pruning: 'Remove spent flowers and yellow leaves',
        ),
        tags: ['indoor', 'flowering', 'low-light', 'air-purifying'],
      ),
      Plant(
        id: '4',
        commonName: 'Rubber Plant',
        scientificName: 'Ficus elastica',
        category: 'tree',
        family: 'Moraceae',
        description: 'Popular indoor tree with glossy, dark green leaves.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'weekly',
            amount: 'medium',
            notes: 'Water when top 2 inches of soil are dry',
          ),
          light: LightRequirement(
            level: 'high',
            hoursPerDay: 8,
            placement: 'indoor',
          ),
          soilType: 'Well-draining potting mix',
          growthSeason: 'Spring to Fall',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 24),
          fertilizer: 'Monthly during growing season',
          pruning: 'Prune to maintain shape',
        ),
        tags: ['indoor', 'tree', 'glossy-leaves'],
      ),
      Plant(
        id: '5',
        commonName: 'Fiddle Leaf Fig',
        scientificName: 'Ficus lyrata',
        category: 'tree',
        family: 'Moraceae',
        description: 'Trendy indoor tree with large, violin-shaped leaves.',
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: 'weekly',
            amount: 'medium',
            notes: 'Water thoroughly when top inch is dry',
          ),
          light: LightRequirement(
            level: 'high',
            hoursPerDay: 8,
            placement: 'indoor',
          ),
          soilType: 'Well-draining, nutrient-rich soil',
          growthSeason: 'Spring to Summer',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 26),
          fertilizer: 'Monthly with balanced fertilizer',
          pruning: 'Minimal pruning needed',
        ),
        tags: ['indoor', 'tree', 'statement-plant'],
      ),
    ]);
  }

  // Search plants by name
  List<Plant> searchPlants(String query) {
    if (query.isEmpty) return _plants;
    
    query = query.toLowerCase();
    return _plants.where((plant) {
      return plant.commonName.toLowerCase().contains(query) ||
             plant.scientificName.toLowerCase().contains(query) ||
             plant.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  // Get plants by category
  List<Plant> getPlantsByCategory(String category) {
    return _plants.where((plant) => plant.category == category).toList();
  }

  // Get all categories
  List<String> getCategories() {
    return _plants.map((plant) => plant.category).toSet().toList();
  }

  // Get plant by ID
  Plant? getPlantById(String id) {
    try {
      return _plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all plants
  List<Plant> getAllPlants() {
    return List.from(_plants);
  }

  // Simulate plant identification from image
  Future<List<Plant>> identifyPlantFromImage(String imagePath) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 2));
    
    // Return random plants as identification results
    final shuffled = List<Plant>.from(_plants)..shuffle();
    return shuffled.take(3).toList();
  }
}