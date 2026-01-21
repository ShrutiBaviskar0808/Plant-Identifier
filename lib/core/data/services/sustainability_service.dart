class SustainabilityMetrics {
  final double co2AbsorbedKg;
  final double oxygenProducedKg;
  final int ecoScore;
  final int plantsCount;
  final DateTime calculatedAt;

  SustainabilityMetrics({
    required this.co2AbsorbedKg,
    required this.oxygenProducedKg,
    required this.ecoScore,
    required this.plantsCount,
    DateTime? calculatedAt,
  }) : calculatedAt = calculatedAt ?? DateTime.now();
}

class SustainabilityService {
  static SustainabilityMetrics calculateImpact(List<String> plantIds) {
    // Average CO2 absorption per plant per year (kg)
    const Map<String, double> plantCO2Rates = {
      'small_plant': 2.5,    // Small houseplants
      'medium_plant': 5.0,   // Medium plants like monstera
      'large_plant': 12.0,   // Large plants/trees
      'succulent': 1.0,      // Succulents (lower rate)
    };
    
    double totalCO2 = 0;
    int plantsCount = plantIds.length;
    
    for (String plantId in plantIds) {
      // Simulate plant size classification
      String category = _classifyPlantSize(plantId);
      totalCO2 += plantCO2Rates[category] ?? 3.0;
    }
    
    // Oxygen production is roughly 1.5x CO2 absorption
    double oxygenProduced = totalCO2 * 1.5;
    
    // Calculate eco score (0-100)
    int ecoScore = _calculateEcoScore(plantsCount, totalCO2);
    
    return SustainabilityMetrics(
      co2AbsorbedKg: totalCO2,
      oxygenProducedKg: oxygenProduced,
      ecoScore: ecoScore,
      plantsCount: plantsCount,
    );
  }
  
  static String _classifyPlantSize(String plantId) {
    // Simulate plant classification
    if (plantId.contains('succulent') || plantId.contains('cactus')) {
      return 'succulent';
    } else if (plantId.contains('tree') || plantId.contains('ficus')) {
      return 'large_plant';
    } else if (plantId.contains('monstera') || plantId.contains('palm')) {
      return 'medium_plant';
    }
    return 'small_plant';
  }
  
  static int _calculateEcoScore(int plantsCount, double co2Absorbed) {
    int baseScore = (plantsCount * 10).clamp(0, 50);
    int co2Score = (co2Absorbed * 2).round().clamp(0, 50);
    return (baseScore + co2Score).clamp(0, 100);
  }
  
  static List<String> getEcoTips(SustainabilityMetrics metrics) {
    List<String> tips = [];
    
    if (metrics.plantsCount < 3) {
      tips.add('🌱 Add more plants to increase your environmental impact!');
    }
    
    if (metrics.ecoScore < 30) {
      tips.add('🌿 Consider adding larger plants for better CO2 absorption');
    }
    
    if (metrics.co2AbsorbedKg > 20) {
      tips.add('🌍 Great job! Your plants absorb significant CO2');
    }
    
    tips.add('💚 Every plant makes a difference for our planet');
    
    return tips;
  }
  
  static String getImpactComparison(double co2Kg) {
    if (co2Kg >= 50) {
      return 'Equivalent to planting a small tree! 🌳';
    } else if (co2Kg >= 20) {
      return 'Like removing a car from the road for 2 days! 🚗';
    } else if (co2Kg >= 10) {
      return 'Equivalent to 50 miles of walking vs driving! 🚶';
    } else {
      return 'Every bit helps our planet! 🌍';
    }
  }
}