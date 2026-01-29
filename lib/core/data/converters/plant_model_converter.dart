import '../models/plant.dart';
import '../models/plant_api_model.dart';

class PlantModelConverter {
  static Plant fromApiModel(PlantApiModel apiModel) {
    return Plant(
      id: apiModel.id.toString(),
      commonName: apiModel.name,
      scientificName: apiModel.scientificName,
      category: _extractCategory(apiModel.name, apiModel.description),
      family: _extractFamily(apiModel.scientificName),
      description: apiModel.description,
      careRequirements: PlantCareRequirements(
        water: WaterRequirement(
          frequency: _extractWaterFrequency(apiModel.waterRequirement),
          amount: _extractWaterAmount(apiModel.waterRequirement),
          notes: apiModel.waterRequirement,
        ),
        light: LightRequirement(
          level: _extractLightLevel(apiModel.lightRequirement),
          hoursPerDay: _extractLightHours(apiModel.lightRequirement),
          placement: 'indoor',
        ),
        soilType: apiModel.soilType,
        growthSeason: apiModel.growingSeason,
        temperature: _parseTemperature(apiModel.temperature),
        fertilizer: apiModel.fertilizer,
        pruning: 'As needed',
      ),
      imageUrls: [apiModel.imageUrl],
      tags: [...apiModel.benefits, apiModel.difficulty],
    );
  }

  static List<Plant> fromApiModelList(List<PlantApiModel> apiModels) {
    return apiModels.map((apiModel) => fromApiModel(apiModel)).toList();
  }

  static String _extractCategory(String name, String description) {
    final lowerName = name.toLowerCase();
    final lowerDesc = description.toLowerCase();
    
    if (lowerName.contains('cactus') || lowerName.contains('succulent') || 
        lowerDesc.contains('succulent') || lowerDesc.contains('drought')) {
      return 'succulent';
    }
    if (lowerName.contains('palm') || lowerName.contains('tree') || 
        lowerDesc.contains('tree')) {
      return 'tree';
    }
    if (lowerName.contains('fern') || lowerName.contains('ivy') || 
        lowerDesc.contains('vine') || lowerDesc.contains('trailing')) {
      return 'shrub';
    }
    return 'flower';
  }

  static String _extractFamily(String scientificName) {
    // Extract genus from scientific name (first word)
    final parts = scientificName.split(' ');
    return parts.isNotEmpty ? '${parts[0]}aceae' : 'Unknown';
  }

  static String _extractWaterFrequency(String waterReq) {
    final lower = waterReq.toLowerCase();
    if (lower.contains('daily')) return 'daily';
    if (lower.contains('weekly')) return 'weekly';
    if (lower.contains('bi-weekly') || lower.contains('biweekly')) return 'bi-weekly';
    if (lower.contains('monthly')) return 'monthly';
    return 'weekly'; // default
  }

  static String _extractWaterAmount(String waterReq) {
    final lower = waterReq.toLowerCase();
    if (lower.contains('low') || lower.contains('sparingly')) return 'low';
    if (lower.contains('high') || lower.contains('moist')) return 'high';
    return 'medium'; // default
  }

  static String _extractLightLevel(String lightReq) {
    final lower = lightReq.toLowerCase();
    if (lower.contains('low')) return 'low';
    if (lower.contains('bright') || lower.contains('high')) return 'high';
    if (lower.contains('direct')) return 'full-sun';
    if (lower.contains('partial')) return 'partial-shade';
    return 'medium'; // default
  }

  static int _extractLightHours(String lightReq) {
    final lower = lightReq.toLowerCase();
    if (lower.contains('low')) return 4;
    if (lower.contains('bright') || lower.contains('high')) return 8;
    if (lower.contains('direct')) return 10;
    return 6; // default
  }

  static TemperatureRange _parseTemperature(String tempStr) {
    // Parse temperature ranges like "65-80°F (18-27°C)"
    final regex = RegExp(r'(\d+)-(\d+)°[CF]');
    final match = regex.firstMatch(tempStr);
    
    if (match != null) {
      final min = int.tryParse(match.group(1) ?? '') ?? 18;
      final max = int.tryParse(match.group(2) ?? '') ?? 25;
      
      // Convert to Celsius if needed
      if (tempStr.contains('°F')) {
        final minC = ((min - 32) * 5 / 9).round();
        final maxC = ((max - 32) * 5 / 9).round();
        return TemperatureRange(minTemp: minC, maxTemp: maxC, unit: 'celsius');
      }
      
      return TemperatureRange(minTemp: min, maxTemp: max, unit: 'celsius');
    }
    
    // Default temperature range
    return TemperatureRange(minTemp: 18, maxTemp: 25, unit: 'celsius');
  }
}