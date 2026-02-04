import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math' as math;
import '../../garden/controllers/garden_controller.dart';
import '../../../core/data/models/plant.dart';

class PlantCatalogView extends StatefulWidget {
  const PlantCatalogView({super.key});

  @override
  State<PlantCatalogView> createState() => _PlantCatalogViewState();
}

class _PlantCatalogViewState extends State<PlantCatalogView> {
  List<Map<String, dynamic>> plants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json',
        ),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> plantList = [];

        if (jsonData is Map<String, dynamic>) {
          jsonData.forEach((key, value) {
            if (value is List) {
              for (var plant in value) {
                if (plant is Map<String, dynamic>) {
                  // ✅ CORRECT IMAGE EXTRACTION
                  String imageUrl = '';
                  List<String> allImages = [];

                  // Extract all images from the images array
                  if (plant['images'] is List && plant['images'].isNotEmpty) {
                    for (var img in plant['images']) {
                      if (img != null && img.toString().isNotEmpty) {
                        String cleanUrl =
                            img.toString().replaceAll('"', '').trim();
                        if (cleanUrl.startsWith('http')) {
                          allImages.add(cleanUrl);
                        }
                      }
                    }
                    // Use first image as main image
                    if (allImages.isNotEmpty) {
                      imageUrl = allImages.first;
                    }
                  }

                  plantList.add({
                    'name': plant['name'] ?? 'Unknown Plant',
                    'scientific_name': plant['scientificName'] ?? plant['scientific_name'] ?? '',
                    'image_url': imageUrl,
                    'images': allImages, // Store all cleaned images
                    'water_requirement': plant['water_requirement'] ?? 'Weekly',
                    'difficulty': plant['difficulty'] ?? 'Easy',
                    'description': plant['description'] ?? '',
                    'habitat': plant['habitat'] ?? '',
                    'plantInfo': plant['plantInfo'] ?? {},
                  });
                }
              }
            }
          });
        }

        setState(() {
          plants = plantList;
          isLoading = false;
        });
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Plant Catalog',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4CAF50).withValues(alpha: 0.1),
                Color(0xFF8BC34A).withValues(alpha: 0.05),
              ],
            ),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(plants[index], context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 60,
            child: _buildPlantImage(plant),
          ),
        ),
        title: Text(
          plant['name'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.water_drop, size: 14, color: Colors.blue),
            SizedBox(width: 4),
            Text(
              plant['water_requirement'],
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _addToGarden(plant),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: Text('Add to Garden', style: TextStyle(fontSize: 10)),
        ),
        onTap: () => _showPlantDetails(plant),
      ),
    );
  }

  Widget _buildPlantImage(Map<String, dynamic> plant) {
    final imageUrl = plant['image_url'] ?? '';

    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.green[300],
        child: Icon(Icons.local_florist, color: Colors.white),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: Colors.green[300],
          child: Icon(Icons.local_florist, color: Colors.white),
        );
      },
    );
  }

  void _addToGarden(Map<String, dynamic> plant) {
    final controller = Get.find<GardenController>();

    controller.addPlantToGarden(
      Plant(
        id: plant['name'].toString().replaceAll(' ', '_').toLowerCase(),
        commonName: plant['name'],
        scientificName: plant['scientific_name'],
        category: 'houseplant',
        family: 'Unknown',
        description: plant['description'] ?? 'Added from catalog',
        imageUrls: plant['image_url'].isNotEmpty ? [plant['image_url']] : [],
        tags: [plant['difficulty']],
        careRequirements: PlantCareRequirements(
          water: WaterRequirement(
            frequency: plant['water_requirement'],
            amount: 'medium',
            notes: '',
          ),
          light: LightRequirement(
            level: 'medium',
            hoursPerDay: 6,
            placement: 'indoor',
          ),
          soilType: 'Well-draining',
          growthSeason: 'Spring',
          temperature: TemperatureRange(minTemp: 18, maxTemp: 25),
          fertilizer: 'Monthly',
          pruning: 'As needed',
        ),
      ),
    );
  }

  void _showPlantDetails(Map<String, dynamic> plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EnhancedPlantDetailScreen(plant: plant),
      ),
    );
  }
}

class _EnhancedPlantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> plant;

  const _EnhancedPlantDetailScreen({required this.plant});

  @override
  State<_EnhancedPlantDetailScreen> createState() => _EnhancedPlantDetailScreenState();
}

class _EnhancedPlantDetailScreenState extends State<_EnhancedPlantDetailScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late Animation<double> _floatingAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    

    
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _colorAnimation = ColorTween(
      begin: Colors.green.withValues(alpha: 0.1),
      end: Colors.green.withValues(alpha: 0.3),
    ).animate(_floatingController);
    
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fadeAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
              ),
              actions: [
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _fadeAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _build3DImageSlider(),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DImageSlider() {
    final images = _getPlantImages();
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
            Colors.purple.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 50 + _floatingAnimation.value,
                right: 30,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 100 - _floatingAnimation.value * 0.5,
                left: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                    value = (value * 0.038).clamp(-1, 1);
                  }
                  
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(value),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isImageExpanded = !_isImageExpanded;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: Matrix4.identity()
                              ..scale(_isImageExpanded ? 1.05 : 1.0),
                            child: _buildPlantImage(images[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: _currentImageIndex == index ? 30 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: _currentImageIndex == index
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _slideAnimation,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.green, Colors.teal],
                          ).createShader(bounds),
                          child: Text(
                            widget.plant['name'] ?? 'Unknown Plant',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          widget.plant['scientific_name'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value * 0.3),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF45A049), Color(0xFF2E7D32)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _addToGarden(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Add to Garden',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: const Text(
                          'Plant Information',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEnhancedInfoGrid(),
                  
                  const SizedBox(height: 20),
                  
                  if (widget.plant['description'] != null && widget.plant['description'].isNotEmpty) ...[
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.plant['description'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  _buildCareInformation(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedInfoGrid() {
    final infoItems = [
      {'icon': Icons.water_drop, 'title': 'Watering', 'subtitle': widget.plant['water_requirement'] ?? 'Weekly', 'color': Colors.blue, 'gradient': [Colors.blue, Colors.lightBlue]},
      {'icon': Icons.wb_sunny, 'title': 'Light', 'subtitle': widget.plant['light_requirement'] ?? 'Bright light', 'color': Colors.orange, 'gradient': [Colors.orange, Colors.deepOrange]},
      {'icon': Icons.star, 'title': 'Difficulty', 'subtitle': widget.plant['difficulty'] ?? 'Easy', 'color': Colors.purple, 'gradient': [Colors.purple, Colors.deepPurple]},
      {'icon': Icons.eco, 'title': 'Type', 'subtitle': 'Houseplant', 'color': Colors.green, 'gradient': [Colors.green, Colors.teal]},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(index.isEven ? -1 : 1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _slideController,
                curve: Interval(
                  index * 0.1,
                  0.5 + index * 0.1,
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: _buildEnhanced3DInfoCard(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                color: item['color'] as Color,
                gradient: item['gradient'] as List<Color>,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhanced3DInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
  }) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.1 * sin(_floatingController.value * 2 * 3.14159))
            ..rotateY(0.05 * cos(_floatingController.value * 2 * 3.14159)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 10,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCareInformation() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          )),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.withValues(alpha: 0.08),
                  Colors.teal.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.spa, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Care Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCareTip(Icons.lightbulb, 'Best grown in bright, indirect sunlight'),
                _buildCareTip(Icons.schedule, 'Water when top soil feels dry'),
                _buildCareTip(Icons.thermostat, 'Prefers temperatures between 18-25°C'),
                _buildCareTip(Icons.air, 'Enjoys good air circulation'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCareTip(IconData icon, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[600], size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.local_florist,
          color: Colors.white,
          size: 80,
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.green),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[300]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.local_florist,
            color: Colors.white,
            size: 80,
          ),
        );
      },
    );
  }

  List<String> _getPlantImages() {
    List<String> images = [];

    if (widget.plant['image_url'] != null && widget.plant['image_url'].isNotEmpty) {
      images.add(widget.plant['image_url']);
    }

    if (widget.plant['images'] is List && widget.plant['images'].isNotEmpty) {
      for (var img in widget.plant['images']) {
        if (img != null && img.toString().isNotEmpty && images.length < 3) {
          String imageUrl = img.toString().replaceAll('"', '').trim();
          if (imageUrl.startsWith('http') && !images.contains(imageUrl)) {
            images.add(imageUrl);
          }
        }
      }
    }

    if (images.isEmpty) {
      images.add(''); // Placeholder
    }

    return images.take(3).toList();
  }

  void _addToGarden() {
    try {
      final controller = Get.find<GardenController>();
      
      controller.addPlantToGarden(
        Plant(
          id: widget.plant['name'].toString().replaceAll(' ', '_').toLowerCase(),
          commonName: widget.plant['name'],
          scientificName: widget.plant['scientific_name'],
          category: 'houseplant',
          family: 'Unknown',
          description: widget.plant['description'] ?? 'Added from catalog',
          imageUrls: widget.plant['image_url'].isNotEmpty ? [widget.plant['image_url']] : [],
          tags: [widget.plant['difficulty']],
          careRequirements: PlantCareRequirements(
            water: WaterRequirement(
              frequency: widget.plant['water_requirement'],
              amount: 'medium',
              notes: '',
            ),
            light: LightRequirement(
              level: 'medium',
              hoursPerDay: 6,
              placement: 'indoor',
            ),
            soilType: 'Well-draining',
            growthSeason: 'Spring',
            temperature: TemperatureRange(minTemp: 18, maxTemp: 25),
            fertilizer: 'Monthly',
            pruning: 'As needed',
          ),
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.plant['name']} added to your garden!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add plant to garden'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  double sin(double value) => math.sin(value);
  double cos(double value) => math.cos(value);
}
