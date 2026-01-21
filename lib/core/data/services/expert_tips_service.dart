class ExpertTip {
  final String id;
  final String title;
  final String content;
  final String category;
  final List<String> tags;

  ExpertTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
  });
}

class ExpertTipsService {
  static final List<ExpertTip> _tips = [
    ExpertTip(
      id: '1',
      title: 'Morning Watering Benefits',
      content: 'Water your plants in the morning to allow excess moisture to evaporate during the day, reducing the risk of fungal diseases.',
      category: 'Watering',
      tags: ['watering', 'timing', 'disease-prevention'],
    ),
    ExpertTip(
      id: '2',
      title: 'Light Exposure Guidelines',
      content: 'Most houseplants prefer bright, indirect light. Direct sunlight can scorch leaves, while too little light causes leggy growth.',
      category: 'Light',
      tags: ['light', 'placement', 'growth'],
    ),
    ExpertTip(
      id: '3',
      title: 'Soil Moisture Check',
      content: 'Insert your finger 1-2 inches into the soil. If it feels dry, it\'s time to water. Different plants have different moisture needs.',
      category: 'Watering',
      tags: ['watering', 'soil', 'technique'],
    ),
    ExpertTip(
      id: '4',
      title: 'Seasonal Care Adjustments',
      content: 'Reduce watering frequency in winter as plants grow slower. Increase humidity during heating season with a humidifier or pebble tray.',
      category: 'Seasonal',
      tags: ['seasonal', 'winter', 'humidity'],
    ),
    ExpertTip(
      id: '5',
      title: 'Fertilizer Guidelines',
      content: 'Feed plants during growing season (spring-summer) with diluted liquid fertilizer. Avoid fertilizing dormant plants in winter.',
      category: 'Fertilizing',
      tags: ['fertilizer', 'nutrients', 'seasonal'],
    ),
    ExpertTip(
      id: '6',
      title: 'Pest Prevention',
      content: 'Inspect plants weekly for pests. Quarantine new plants for 2 weeks. Clean leaves monthly to prevent dust buildup.',
      category: 'Pest Control',
      tags: ['pests', 'prevention', 'maintenance'],
    ),
    ExpertTip(
      id: '7',
      title: 'Repotting Signs',
      content: 'Repot when roots circle the pot bottom, water drains too quickly, or growth slows despite good care. Spring is ideal timing.',
      category: 'Repotting',
      tags: ['repotting', 'roots', 'timing'],
    ),
    ExpertTip(
      id: '8',
      title: 'Propagation Basics',
      content: 'Many plants can be propagated from stem cuttings. Cut below a node, remove lower leaves, and root in water or moist soil.',
      category: 'Propagation',
      tags: ['propagation', 'cuttings', 'technique'],
    ),
  ];

  static List<ExpertTip> getAllTips() => List.from(_tips);

  static List<ExpertTip> getTipsByCategory(String category) {
    return _tips.where((tip) => tip.category == category).toList();
  }

  static List<String> getCategories() {
    return _tips.map((tip) => tip.category).toSet().toList();
  }

  static List<ExpertTip> searchTips(String query) {
    query = query.toLowerCase();
    return _tips.where((tip) =>
      tip.title.toLowerCase().contains(query) ||
      tip.content.toLowerCase().contains(query) ||
      tip.tags.any((tag) => tag.toLowerCase().contains(query))
    ).toList();
  }

  static ExpertTip? getTipById(String id) {
    try {
      return _tips.firstWhere((tip) => tip.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ExpertTip> getRandomTips(int count) {
    final shuffled = List<ExpertTip>.from(_tips)..shuffle();
    return shuffled.take(count).toList();
  }
}