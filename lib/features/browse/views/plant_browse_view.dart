import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/models/plant.dart';
import '../../../core/data/services/plant_database_service.dart';
import '../../../core/data/services/user_plant_service.dart';

class PlantBrowseView extends StatefulWidget {
  const PlantBrowseView({super.key});

  @override
  State<PlantBrowseView> createState() => _PlantBrowseViewState();
}

class _PlantBrowseViewState extends State<PlantBrowseView> {
  final PlantDatabaseService _plantService = PlantDatabaseService();
  final UserPlantService _userPlantService = UserPlantService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];
  String _selectedCategory = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _plantService.initializeSampleData();
    _plants = _plantService.getAllPlants();
    _filteredPlants = _plants;
    setState(() {
      _isLoading = false;
    });
  }

  void _filterPlants() {
    List<Plant> filtered = _plants;

    if (_selectedCategory != 'all') {
      filtered = filtered.where((plant) => plant.category == _selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = _plantService.searchPlants(_searchController.text);
      if (_selectedCategory != 'all') {
        filtered = filtered.where((plant) => plant.category == _selectedCategory).toList();
      }
    }

    setState(() {
      _filteredPlants = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Browse Plants')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Plants', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    hintStyle: TextStyle(fontSize: 16),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => _filterPlants(),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('all', 'All'),
                      ..._plantService.getCategories().map(
                        (category) => _buildCategoryChip(category, category),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredPlants.length,
              itemBuilder: (context, index) {
                return _buildPlantCard(_filteredPlants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 16)),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
          _filterPlants();
        },
      ),
    );
  }

  Widget _buildPlantCard(Plant plant) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.local_florist, color: Colors.green),
        title: Text(plant.commonName, style: TextStyle(fontSize: 18)),
        subtitle: Text(plant.scientificName, style: TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _addToGarden(plant),
        ),
        onTap: () => _showPlantDetails(plant),
      ),
    );
  }

  void _showPlantDetails(Plant plant) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant.commonName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(plant.scientificName, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
            SizedBox(height: 16),
            Text(plant.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _addToGarden(plant);
              },
              child: Text('Add to Garden'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToGarden(Plant plant) async {
    try {
      await _userPlantService.addPlant(plant, group: 'indoor');
      Get.snackbar('Success', 'Plant added to your garden');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add plant');
    }
  }
}
