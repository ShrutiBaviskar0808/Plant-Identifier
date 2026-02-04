import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/data/models/plant.dart';
import '../../../core/data/services/plant_database_service.dart';
import '../../../core/data/services/user_plant_service.dart';
import '../../garden/controllers/garden_controller.dart';

class PlantSearchView extends StatefulWidget {
  const PlantSearchView({super.key});

  @override
  State<PlantSearchView> createState() => _PlantSearchViewState();
}

class _PlantSearchViewState extends State<PlantSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final PlantDatabaseService _plantService = PlantDatabaseService();
  List<Plant> _searchResults = [];
  List<Plant> _allPlants = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadAllPlants();
  }

  Future<void> _loadAllPlants() async {
    setState(() => _isLoading = true);
    try {
      // Load database plants
      await _plantService.initializeSampleData();
      List<Plant> databasePlants = await _plantService.getAllPlants();
      
      // Load catalog plants from API
      List<Plant> catalogPlants = await _loadCatalogPlants();
      
      // Combine both lists
      _allPlants = [...databasePlants, ...catalogPlants];
      _searchResults = _allPlants;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load plants');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Plant>> _loadCatalogPlants() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json',
        ),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final List<Plant> catalogPlants = [];

        if (jsonData is Map<String, dynamic>) {
          jsonData.forEach((key, value) {
            if (value is List) {
              for (var plant in value) {
                if (plant is Map<String, dynamic>) {
                  catalogPlants.add(Plant(
                    id: plant['name'].toString().replaceAll(' ', '_').toLowerCase(),
                    commonName: plant['name'] ?? 'Unknown Plant',
                    scientificName: plant['scientificName'] ?? plant['scientific_name'] ?? '',
                    category: 'catalog',
                    family: 'Unknown',
                    description: plant['description'] ?? '',
                    imageUrls: plant['images'] is List && plant['images'].isNotEmpty 
                        ? [plant['images'][0].toString().replaceAll('"', '').trim()] 
                        : [],
                    tags: [plant['difficulty'] ?? 'Easy'],
                    careRequirements: PlantCareRequirements(
                      water: WaterRequirement(
                        frequency: plant['water_requirement'] ?? 'Weekly',
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
                  ));
                }
              }
            }
          });
        }
        return catalogPlants;
      }
    } catch (e) {
      print('Error loading catalog plants: $e');
    }
    return [];
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _selectedCategory == 'All' 
            ? _allPlants 
            : _allPlants.where((p) => p.category == _selectedCategory).toList();
      } else {
        _searchResults = _allPlants.where((plant) {
          final matchesQuery = plant.commonName.toLowerCase().contains(query.toLowerCase()) ||
                              plant.scientificName.toLowerCase().contains(query.toLowerCase()) ||
                              plant.family.toLowerCase().contains(query.toLowerCase());
          final matchesCategory = _selectedCategory == 'All' || plant.category == _selectedCategory;
          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _performSearch(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...(_allPlants.map((p) => p.category).toSet().toList())];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Plants',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search plants by name, family...',
                      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: _performSearch,
                  ),
                  SizedBox(height: 12),
                  // Category Filter
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == _selectedCategory;
                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category, style: TextStyle(fontSize: 13)),
                            selected: isSelected,
                            onSelected: (_) => _filterByCategory(category),
                            backgroundColor: Colors.white,
                            selectedColor: Colors.green.withValues(alpha: 0.2),
                            checkmarkColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.green))
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return _buildPlantCard(_searchResults[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage(Plant plant) {
    // Map plant names to correct asset paths
    String getAssetPath(String plantName) {
      final name = plantName.toLowerCase();
      
      // Direct mappings for specific plants
      final Map<String, String> plantImageMap = {
        'hibiscus': 'assets/images/hibiscus.jpg',
        'monstera deliciosa': 'assets/images/Monstera Deliciosa.jpg',
        'monstera': 'assets/images/Monstera Deliciosa.jpg',
        'snake plant': 'assets/images/Snake Plant.jpg',
        'snake': 'assets/images/Snake Plant.jpg',
        'sansevieria': 'assets/images/Snake Plant.jpg',
        'pothos': 'assets/images/Pothos.jpg',
        'peace lily': 'assets/images/Peace Lily.jpg',
        'rubber plant': 'assets/images/Rubber Plant.jpg',
        'spider plant': 'assets/images/Spider Plant.jpg',
        'aloe vera': 'assets/images/Aloe vera.jpg',
        'jade plant': 'assets/images/Jade Plant.jpg',
        'zz plant': 'assets/images/ZZ Plant.jpg',
        'fiddle leaf fig': 'assets/images/Fiddle Leaf Fig.jpg',
      };
      
      // Check for exact matches first
      if (plantImageMap.containsKey(name)) {
        return plantImageMap[name]!;
      }
      
      // Check for partial matches
      for (String key in plantImageMap.keys) {
        if (name.contains(key) || key.contains(name)) {
          return plantImageMap[key]!;
        }
      }
      
      // Try direct asset path with plant name
      return 'assets/images/${plant.commonName}.jpg';
    }
    
    return Image.asset(
      getAssetPath(plant.commonName),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If network image URL exists, try that
        if (plant.imageUrls.isNotEmpty) {
          return Image.network(
            plant.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.green.withValues(alpha: 0.1),
                child: Icon(Icons.local_florist, color: Colors.green, size: 30),
              );
            },
          );
        }
        return Container(
          color: Colors.green.withValues(alpha: 0.1),
          child: Icon(Icons.local_florist, color: Colors.green, size: 30),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No plants found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(Plant plant) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildPlantImage(plant),
          ),
        ),
        title: Text(
          plant.commonName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant.scientificName,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plant.category,
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plant.careRequirements.water.frequency.isNotEmpty ? '💧 ${plant.careRequirements.water.frequency}' : '🌱 Low maintenance',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_circle, color: Colors.green, size: 28),
          onPressed: () => _showAddToGardenDialog(plant),
        ),
        onTap: () => _showPlantDetails(plant),
      ),
    );
  }

  void _showPlantDetails(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PlantDetailFullScreen(plant: plant),
      ),
    );
  }

  void _showAddToGardenDialog(Plant plant) {
    final nameController = TextEditingController(text: plant.commonName);
    final notesController = TextEditingController();
    String selectedGroup = 'indoor';

    Get.dialog(
      AlertDialog(
        title: Text('Add to My Garden'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Plant Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGroup,
                  decoration: InputDecoration(
                    labelText: 'Group',
                    border: OutlineInputBorder(),
                  ),
                  items: ['indoor', 'outdoor', 'edible', 'decorative']
                      .map((group) => DropdownMenuItem(
                            value: group,
                            child: Text(group.capitalize!),
                          ))
                      .toList(),
                  onChanged: (value) => selectedGroup = value!,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _addPlantToGarden(
              plant,
              nameController.text,
              notesController.text,
              selectedGroup,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPlantToGarden(Plant plant, String customName, String notes, String group) async {
    try {
      final userPlantService = UserPlantService();
      
      // For catalog plants, we'll use the network image URL as imagePath
      String? imagePath;
      if (plant.imageUrls.isNotEmpty) {
        imagePath = plant.imageUrls.first;
      }
      
      await userPlantService.addPlant(
        plant,
        customName: customName.isNotEmpty ? customName : null,
        notes: notes.isNotEmpty ? notes : null,
        group: group,
        imagePath: imagePath,
      );

      // Refresh garden data if controller exists
      try {
        final gardenController = Get.find<GardenController>();
        await gardenController.loadUserPlants();
      } catch (e) {
        // Garden controller not found, that's okay
      }

      Get.back(); // Close dialog
      
      Get.snackbar(
        'Success!',
        'Plant added to your garden successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add plant: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class _PlantDetailFullScreen extends StatefulWidget {
  final Plant plant;

  const _PlantDetailFullScreen({required this.plant});

  @override
  State<_PlantDetailFullScreen> createState() => _PlantDetailFullScreenState();
}

class _PlantDetailFullScreenState extends State<_PlantDetailFullScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pageController = PageController();
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _getPlantImages();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(images),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPlantHeader(),
                          const SizedBox(height: 20),
                          _buildQuickStats(),
                          const SizedBox(height: 24),
                          if (widget.plant.description.isNotEmpty) ...[
                            _buildDescriptionSection(),
                            const SizedBox(height: 24),
                          ],
                          _buildCareInformation(),
                          const SizedBox(height: 24),
                          _buildActionButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(List<String> images) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentImageIndex = index);
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return _buildPlantImage(images[index]);
              },
            ),
            if (images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == entry.key
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.plant.commonName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.plant.scientificName,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTag(widget.plant.category, Colors.blue),
            const SizedBox(width: 8),
            _buildTag(widget.plant.family, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.05),
            Colors.teal.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(Icons.water_drop, 'Water', widget.plant.careRequirements.water.frequency),
          _buildStatItem(Icons.wb_sunny, 'Light', widget.plant.careRequirements.light.level),
          _buildStatItem(Icons.thermostat, 'Temp', '${widget.plant.careRequirements.temperature.minTemp}-${widget.plant.careRequirements.temperature.maxTemp}°C'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info_outline, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'About This Plant',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.plant.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.06),
            Colors.teal.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.spa, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Care Requirements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCareItem(Icons.water_drop, 'Watering', widget.plant.careRequirements.water.frequency),
          _buildCareItem(Icons.wb_sunny, 'Light Requirements', widget.plant.careRequirements.light.level),
          _buildCareItem(Icons.grass, 'Soil Type', widget.plant.careRequirements.soilType),
          _buildCareItem(Icons.eco, 'Fertilizer', widget.plant.careRequirements.fertilizer),
        ],
      ),
    );
  }

  Widget _buildCareItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[600], size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.teal],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _addToGarden,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add to My Garden',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage(String imageUrl) {
    String getAssetPath(String plantName) {
      final name = plantName.toLowerCase();
      
      // Direct mappings for specific plants
      final Map<String, String> plantImageMap = {
        'hibiscus': 'assets/images/hibiscus.jpg',
        'monstera deliciosa': 'assets/images/Monstera Deliciosa.jpg',
        'monstera': 'assets/images/Monstera Deliciosa.jpg',
        'snake plant': 'assets/images/Snake Plant.jpg',
        'snake': 'assets/images/Snake Plant.jpg',
        'sansevieria': 'assets/images/Snake Plant.jpg',
        'pothos': 'assets/images/Pothos.jpg',
        'peace lily': 'assets/images/Peace Lily.jpg',
        'rubber plant': 'assets/images/Rubber Plant.jpg',
        'spider plant': 'assets/images/Spider Plant.jpg',
        'aloe vera': 'assets/images/Aloe vera.jpg',
        'jade plant': 'assets/images/Jade Plant.jpg',
        'zz plant': 'assets/images/ZZ Plant.jpg',
        'fiddle leaf fig': 'assets/images/Fiddle Leaf Fig.jpg',
      };
      
      // Check for exact matches first
      if (plantImageMap.containsKey(name)) {
        return plantImageMap[name]!;
      }
      
      // Check for partial matches
      for (String key in plantImageMap.keys) {
        if (name.contains(key) || key.contains(name)) {
          return plantImageMap[key]!;
        }
      }
      
      // Try direct asset path with plant name
      return 'assets/images/${widget.plant.commonName}.jpg';
    }

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
          size: 60,
        ),
      );
    }

    return Image.asset(
      getAssetPath(widget.plant.commonName),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        if (widget.plant.imageUrls.isNotEmpty) {
          return Image.network(
            widget.plant.imageUrls.first,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
                  size: 60,
                ),
              );
            },
          );
        }
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
            size: 60,
          ),
        );
      },
    );
  }

  List<String> _getPlantImages() {
    List<String> images = [];

    if (widget.plant.imageUrls.isNotEmpty) {
      images.addAll(widget.plant.imageUrls.take(3));
    }

    if (images.isEmpty) {
      images.add('');
    }

    return images;
  }

  void _addToGarden() {
    try {
      final controller = Get.find<GardenController>();
      
      controller.addPlantToGarden(widget.plant);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.plant.commonName} added to your garden!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add plant to garden'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}