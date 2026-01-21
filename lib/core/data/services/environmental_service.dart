class WeatherData {
  final double temperature;
  final int humidity;
  final String condition;
  final double uvIndex;
  final String location;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.uvIndex,
    required this.location,
  });
}

class WeatherAlert {
  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class EnvironmentalService {
  static WeatherData? _currentWeather;
  static final List<WeatherAlert> _alerts = [];
  
  static Future<WeatherData> getCurrentWeather() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    _currentWeather = WeatherData(
      temperature: 22.5,
      humidity: 65,
      condition: 'partly_cloudy',
      uvIndex: 6.2,
      location: 'Your Location',
    );
    
    _checkForAlerts(_currentWeather!);
    return _currentWeather!;
  }
  
  static List<WeatherAlert> getAlerts() => List.from(_alerts);
  
  static void _checkForAlerts(WeatherData weather) {
    _alerts.clear();
    
    if (weather.temperature > 30) {
      _alerts.add(WeatherAlert(
        id: 'heat_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Heat Wave Warning',
        message: 'High temperatures detected. Increase watering frequency and provide shade for outdoor plants.',
        severity: 'high',
      ));
    }
    
    if (weather.temperature < 5) {
      _alerts.add(WeatherAlert(
        id: 'frost_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Frost Warning',
        message: 'Freezing temperatures expected. Bring sensitive plants indoors.',
        severity: 'critical',
      ));
    }
    
    if (weather.humidity < 30) {
      _alerts.add(WeatherAlert(
        id: 'dry_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Low Humidity Alert',
        message: 'Dry air detected. Consider using a humidifier or pebble tray for tropical plants.',
        severity: 'medium',
      ));
    }
  }
  
  static List<String> getWeatherBasedTips(WeatherData weather) {
    List<String> tips = [];
    
    if (weather.condition == 'sunny' && weather.uvIndex > 7) {
      tips.add('☀️ High UV levels - provide shade for sensitive plants');
    }
    
    if (weather.humidity > 80) {
      tips.add('💨 High humidity - ensure good air circulation to prevent fungal issues');
    }
    
    if (weather.temperature > 25) {
      tips.add('🌡️ Hot weather - water early morning or evening to reduce evaporation');
    }
    
    return tips;
  }
}