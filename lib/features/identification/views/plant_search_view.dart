import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      _plantService.initializeSampleData();
      _allPlants = _plantService.getAllPlants();
      _searchResults = _allPlants;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load plants');
    } finally {
      setState(() => _isLoading = false);
    }
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Plants'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
                          label: Text(category),
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
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_florist, color: Colors.green, size: 30),
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
                Text(
                  plant.family,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
            Row(
              children: [
                Icon(Icons.local_florist, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plant.commonName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              plant.scientificName,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Category', plant.category),
            _buildDetailRow('Family', plant.family),
            SizedBox(height: 16),
            Text(
              'Care Requirements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildCareDetails(plant.careRequirements),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                    label: Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _showAddToGardenDialog(plant);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add to Garden'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCareDetails(PlantCareRequirements care) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildCareRow(Icons.water_drop, 'Water', '${care.water.frequency}'),
          _buildCareRow(Icons.wb_sunny, 'Light', '${care.light.level}'),
          _buildCareRow(Icons.thermostat, 'Temperature', '${care.temperature.minTemp}-${care.temperature.maxTemp}°C'),
        ],
      ),
    );
  }

  Widget _buildCareRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green[700]),
          SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 12)),
          ),
        ],
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
        content: Column(
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
      await userPlantService.addPlant(
        plant,
        customName: customName.isNotEmpty ? customName : null,
        notes: notes.isNotEmpty ? notes : null,
        group: group,
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
        snackPosition: SnackPosition.TOP,
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