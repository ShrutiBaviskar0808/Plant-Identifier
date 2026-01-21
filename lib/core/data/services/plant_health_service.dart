import 'dart:io';

class HealthScore {
  final int score; // 0-100
  final String status;
  final List<String> factors;
  final List<String> recommendations;
  final DateTime timestamp;

  HealthScore({
    required this.score,
    required this.status,
    required this.factors,
    required this.recommendations,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get statusColor {
    if (score >= 80) return 'excellent';
    if (score >= 60) return 'good';
    if (score >= 40) return 'fair';
    return 'poor';
  }
}

class PlantHealthService {
  static Future<HealthScore> analyzeHealth({
    required File plantImage,
    required String plantId,
    List<String>? careHistory,
    Map<String, dynamic>? weatherData,
  }) async {
    // Simulate AI analysis
    await Future.delayed(Duration(seconds: 2));
    
    int baseScore = 75;
    List<String> factors = [];
    List<String> recommendations = [];
    
    // Analyze care history
    if (careHistory != null && careHistory.isNotEmpty) {
      baseScore += 10;
      factors.add('Regular care routine detected');
    } else {
      baseScore -= 15;
      factors.add('Irregular care pattern');
      recommendations.add('Set up consistent watering reminders');
    }
    
    // Weather impact
    if (weatherData != null) {
      final temp = weatherData['temperature'] ?? 22;
      if (temp > 30) {
        baseScore -= 10;
        factors.add('High temperature stress');
        recommendations.add('Increase watering frequency during heat');
      }
    }
    
    // Image analysis simulation
    final imageScore = _analyzeImageHealth(plantImage);
    baseScore += imageScore;
    
    if (imageScore > 0) {
      factors.add('Healthy leaf appearance');
    } else {
      factors.add('Signs of stress detected in leaves');
      recommendations.add('Check for pests or nutrient deficiency');
    }
    
    baseScore = baseScore.clamp(0, 100);
    
    return HealthScore(
      score: baseScore,
      status: _getHealthStatus(baseScore),
      factors: factors,
      recommendations: recommendations,
    );
  }
  
  static int _analyzeImageHealth(File image) {
    // Simulate computer vision analysis
    // In real implementation, use ML model to detect:
    // - Leaf color and texture
    // - Growth patterns
    // - Disease symptoms
    return [5, 0, -5, -10][DateTime.now().second % 4];
  }
  
  static String _getHealthStatus(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Attention';
  }
}