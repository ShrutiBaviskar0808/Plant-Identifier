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
      if (name.contains('hibiscus')) return 'assets/images/hibiscus.jpg';
      if (name.contains('monstera')) return 'assets/images/Monstera Deliciosa.jpg';
      if (name.contains('snake')) return 'assets/images/Snake Plant.jpg';
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

class _PlantDetailFullScreen extends StatelessWidget {
  final Plant plant;

  const _PlantDetailFullScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            plant.commonName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plant Image
              Container(
                height: 250,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: () {
                    // Map plant names to correct asset paths
                    String getAssetPath(String plantName) {
                      final name = plantName.toLowerCase();
                      if (name.contains('hibiscus')) return 'assets/images/hibiscus.jpg';
                      if (name.contains('monstera')) return 'assets/images/Monstera Deliciosa.jpg';
                      if (name.contains('snake')) return 'assets/images/Snake Plant.jpg';
                      return 'assets/images/${plant.commonName}.jpg';
                    }
                    
                    return Image.asset(
                      getAssetPath(plant.commonName),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (plant.imageUrls.isNotEmpty) {
                          return Image.network(
                            plant.imageUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.green.withValues(alpha: 0.1),
                                child: Icon(Icons.local_florist, color: Colors.green, size: 60),
                              );
                            },
                          );
                        }
                        return Container(
                          color: Colors.green.withValues(alpha: 0.1),
                          child: Icon(Icons.local_florist, color: Colors.green, size: 60),
                        );
                      },
                    );
                  }(),
                ),
              ),
              // Plant Info
              Text(
                plant.commonName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                plant.scientificName,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              if (plant.description.isNotEmpty) ...[
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  plant.description,
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                SizedBox(height: 16),
              ],
              Text('Category: ${plant.category}'),
              Text('Family: ${plant.family}'),
              SizedBox(height: 16),
              Text(
                'Care Requirements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.water_drop, size: 16, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text('Water: ${plant.careRequirements.water.frequency}'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, size: 16, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text('Light: ${plant.careRequirements.light.level}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}