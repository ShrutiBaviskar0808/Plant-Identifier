import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../identification/screens/camera_screen.dart';
import '../../garden/screens/my_garden_screen.dart';
import '../../care/screens/care_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../shared/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const CameraScreen(),
    const MyGardenScreen(),
    const CareScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'Identify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            activeIcon: Icon(Icons.local_florist),
            label: 'Garden',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined),
            activeIcon: Icon(Icons.schedule),
            label: 'Care',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  // Featured plants with attractive descriptions
  static final List<FeaturedPlant> _featuredPlants = [
    FeaturedPlant(
      name: 'Monstera Deliciosa',
      subtitle: 'Swiss Cheese Plant',
      description: 'The Instagram star of houseplants! 📸 Known for its stunning split leaves that create natural art in your home. Perfect for plant parents who love dramatic foliage.',
      difficulty: 'Easy',
      lightLevel: 'Bright Indirect',
      waterFreq: 'Weekly',
      specialFeature: '🌟 Air Purifier',
      plantIcon: Icons.park,
      gradientColors: [Color(0xFF4CAF50), Color(0xFF81C784)],
      accentColor: Color(0xFF2E7D32),
    ),
    FeaturedPlant(
      name: 'Snake Plant',
      subtitle: 'Sansevieria',
      description: 'The ultimate low-maintenance companion! 🐍 Thrives on neglect and works the night shift - releasing oxygen while you sleep. Perfect for busy lifestyles.',
      difficulty: 'Beginner',
      lightLevel: 'Low to Bright',
      waterFreq: 'Bi-weekly',
      specialFeature: '🌙 Night Oxygen',
      plantIcon: Icons.grass,
      gradientColors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
      accentColor: Color(0xFF1B5E20),
    ),
    FeaturedPlant(
      name: 'Fiddle Leaf Fig',
      subtitle: 'Ficus Lyrata',
      description: 'The diva of the plant world! 🎭 Stunning violin-shaped leaves that make a bold statement. Requires attention but rewards you with unmatched elegance.',
      difficulty: 'Intermediate',
      lightLevel: 'Bright Indirect',
      waterFreq: 'Weekly',
      specialFeature: '🎨 Statement Piece',
      plantIcon: Icons.eco,
      gradientColors: [Color(0xFF689F38), Color(0xFF9CCC65)],
      accentColor: Color(0xFF33691E),
    ),
    FeaturedPlant(
      name: 'Golden Pothos',
      subtitle: 'Devil\'s Ivy',
      description: 'The friendly neighborhood plant! 🏠 Cascading vines that forgive your mistakes and grow like magic. Perfect first plant for new plant parents.',
      difficulty: 'Beginner',
      lightLevel: 'Low to Medium',
      waterFreq: 'Weekly',
      specialFeature: '💚 Beginner Friendly',
      plantIcon: Icons.nature,
      gradientColors: [Color(0xFFFFB74D), Color(0xFFFFCC02)],
      accentColor: Color(0xFFE65100),
    ),
    FeaturedPlant(
      name: 'Peace Lily',
      subtitle: 'Spathiphyllum',
      description: 'The zen master of plants! 🕊️ Elegant white blooms that bring tranquility to any space. Tells you when it\'s thirsty with dramatic drooping.',
      difficulty: 'Easy',
      lightLevel: 'Medium',
      waterFreq: 'Weekly',
      specialFeature: '🌸 Beautiful Blooms',
      plantIcon: Icons.local_florist,
      gradientColors: [Color(0xFF7986CB), Color(0xFFB39DDB)],
      accentColor: Color(0xFF303F9F),
    ),
  ];

  String _getDailyTip() {
    final tips = [
      '🌅 Water your plants in the morning for optimal absorption and to prevent fungal issues.',
      '🔄 Rotate your plants weekly to ensure even growth and prevent them from leaning toward light.',
      '👆 Check soil moisture by inserting your finger 1-2 inches deep before watering.',
      '🧽 Clean plant leaves monthly with a damp cloth to improve photosynthesis and remove dust.',
      '🏠 Group plants with similar care needs together to create a thriving plant community.',
      '🌡️ Most houseplants prefer temperatures between 65-75°F (18-24°C) during the day.',
      '💧 Use room temperature water to avoid shocking your plants\' roots.',
    ];
    
    final dayOfYear = DateTime.now().dayOfYear;
    return tips[dayOfYear % tips.length];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Identifier'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Plant Identifier',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover and care for plants with AI-powered identification',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.camera_alt,
                    title: 'Identify Plant',
                    subtitle: 'Take a photo',
                    onTap: () => Navigator.pushNamed(context, '/camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.local_florist,
                    title: 'My Garden',
                    subtitle: 'View collection',
                    onTap: () => Navigator.pushNamed(context, '/garden'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Featured Plants
            Text(
              'Featured Plants',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _featuredPlants.length,
                itemBuilder: (context, index) {
                  final plant = _featuredPlants[index];
                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(right: index == _featuredPlants.length - 1 ? 0 : 16),
                    child: _FeaturedPlantCard(plant: plant),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Plant Care Tips
            Text(
              'Daily Plant Wisdom',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tip of the Day',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getDailyTip(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Plant Mood Tracker - Unique Feature
            Text(
              'Plant Mood Today 🌱',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PlantMoodCard(emoji: '😊', mood: 'Happy', color: Colors.green),
                  _PlantMoodCard(emoji: '😴', mood: 'Thirsty', color: Colors.blue),
                  _PlantMoodCard(emoji: '🥲', mood: 'Droopy', color: Colors.orange),
                  _PlantMoodCard(emoji: '🌟', mood: 'Thriving', color: Colors.purple),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // AI Plant Doctor - Unique Feature
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.teal.withValues(alpha: 0.1),
                      Colors.green.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.psychology,
                              color: Colors.teal,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Plant Doctor 🩺',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                Text(
                                  'Instant plant health diagnosis',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.teal.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.teal,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload a photo of your plant and get instant AI-powered health analysis with personalized treatment recommendations.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturedPlant {
  final String name;
  final String subtitle;
  final String description;
  final String difficulty;
  final String lightLevel;
  final String waterFreq;
  final String specialFeature;
  final IconData plantIcon;
  final List<Color> gradientColors;
  final Color accentColor;

  FeaturedPlant({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.difficulty,
    required this.lightLevel,
    required this.waterFreq,
    required this.specialFeature,
    required this.plantIcon,
    required this.gradientColors,
    required this.accentColor,
  });
}

class _FeaturedPlantCard extends StatelessWidget {
  final FeaturedPlant plant;

  const _FeaturedPlantCard({required this.plant});

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'easy':
        return Colors.lightGreen;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              plant.gradientColors[0].withValues(alpha: 0.1),
              plant.gradientColors[1].withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Creative Plant Header
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: plant.gradientColors,
                ),
              ),
              child: Stack(
                children: [
                  // Main plant icon with gradient background
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        plant.plantIcon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Difficulty badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(context, plant.difficulty),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        plant.difficulty,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Plant name overlay at bottom
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      plant.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Plant Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant subtitle and description
                    Text(
                      plant.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: plant.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description
                    Expanded(
                      child: Text(
                        plant.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Care Info with creative design
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: plant.gradientColors[0].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: plant.gradientColors[0].withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _CreativeCareChip(
                              icon: Icons.wb_sunny_outlined,
                              label: plant.lightLevel,
                              color: plant.accentColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CreativeCareChip(
                              icon: Icons.water_drop_outlined,
                              label: plant.waterFreq,
                              color: plant.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Special Feature with animation-like design
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            plant.accentColor.withValues(alpha: 0.8),
                            plant.accentColor.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: plant.accentColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              plant.specialFeature,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreativeCareChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CreativeCareChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to get day of year
extension DateTimeExtension on DateTime {
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays + 1;
  }
}

class _PlantMoodCard extends StatelessWidget {
  final String emoji;
  final String mood;
  final Color color;

  const _PlantMoodCard({
    required this.emoji,
    required this.mood,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  mood,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}