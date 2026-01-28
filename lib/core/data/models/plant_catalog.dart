class PlantCatalogItem {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String imageUrl;
  final WaterRequirement waterRequirement;
  final String growingSeason;
  final String humidity;
  final String matureSize;
  final String lightRequirement;
  final String soilType;
  final String temperature;
  final String fertilizer;
  final String toxicity;
  final List<String> benefits;
  final String difficulty;

  PlantCatalogItem({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.waterRequirement,
    required this.growingSeason,
    required this.humidity,
    required this.matureSize,
    required this.lightRequirement,
    required this.soilType,
    required this.temperature,
    required this.fertilizer,
    required this.toxicity,
    required this.benefits,
    required this.difficulty,
  });
}

class WaterRequirement {
  final String frequency;
  final String amount;
  final String description;

  WaterRequirement({
    required this.frequency,
    required this.amount,
    required this.description,
  });
}

class PlantCatalogData {
  static List<PlantCatalogItem> getAllPlants() {
    return [
      PlantCatalogItem(
        id: '1',
        name: 'Monstera Deliciosa',
        scientificName: 'Monstera deliciosa',
        description: 'A stunning tropical plant known for its large, split leaves.',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        waterRequirement: WaterRequirement(
          frequency: 'Weekly',
          amount: 'Moderate',
          description: 'Water when top 2 inches of soil are dry',
        ),
        growingSeason: 'Spring to Fall',
        humidity: '60-70%',
        matureSize: '6-10 feet tall',
        lightRequirement: 'Bright, indirect light',
        soilType: 'Well-draining potting mix',
        temperature: '65-80°F (18-27°C)',
        fertilizer: 'Monthly during growing season',
        toxicity: 'Toxic to pets and children',
        benefits: ['Air purifying', 'Low maintenance', 'Fast growing'],
        difficulty: 'Easy',
      ),
      PlantCatalogItem(
        id: '2',
        name: 'Snake Plant',
        scientificName: 'Sansevieria trifasciata',
        description: 'An extremely hardy plant with upright, sword-like leaves.',
        imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=400',
        waterRequirement: WaterRequirement(
          frequency: 'Bi-weekly',
          amount: 'Low',
          description: 'Allow soil to dry completely between waterings',
        ),
        growingSeason: 'Year-round',
        humidity: '30-50%',
        matureSize: '2-4 feet tall',
        lightRequirement: 'Low to bright, indirect light',
        soilType: 'Cactus or succulent mix',
        temperature: '60-80°F (15-27°C)',
        fertilizer: 'Every 2-3 months',
        toxicity: 'Mildly toxic to pets',
        benefits: ['Air purifying', 'Drought tolerant', 'Low light tolerant'],
        difficulty: 'Very Easy',
      ),
    ];
  }
}