import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/garden_provider.dart';
import '../../../core/data/models/user_plant.dart';

class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Consumer<GardenProvider>(
        builder: (context, gardenProvider, child) {
          if (gardenProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gardenProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading plants',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gardenProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => gardenProvider.loadUserPlants(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final plants = _getFilteredPlants(gardenProvider.userPlants);

          if (plants.isEmpty) {
            return _EmptyGardenView();
          }

          return Column(
            children: [
              // Stats Card
              Container(
                margin: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.local_florist,
                          label: 'Total Plants',
                          value: '${gardenProvider.plantCount}',
                        ),
                        _StatItem(
                          icon: Icons.category,
                          label: 'Categories',
                          value: '${_getUniqueCategories(gardenProvider.userPlants).length}',
                        ),
                        _StatItem(
                          icon: Icons.calendar_today,
                          label: 'This Month',
                          value: '${_getPlantsAddedThisMonth(gardenProvider.userPlants)}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Filter
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildCategoryChips(gardenProvider.userPlants),
                ),
              ),

              const SizedBox(height: 16),

              // Plants Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: plants.length,
                  itemBuilder: (context, index) => _PlantCard(
                    plant: plants[index],
                    onTap: () => _showPlantDetails(plants[index]),
                    onDelete: () => _deletePlant(gardenProvider, plants[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/camera'),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<UserPlant> _getFilteredPlants(List<UserPlant> plants) {
    var filtered = plants;

    if (_searchQuery.isNotEmpty) {
      filtered = plants.where((plant) {
        return plant.plant.commonName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               plant.plant.scientificName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (plant.customName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered.where((plant) => plant.plant.category == _selectedCategory).toList();
    }

    return filtered;
  }

  Set<String> _getUniqueCategories(List<UserPlant> plants) {
    return plants.map((plant) => plant.plant.category).toSet();
  }

  int _getPlantsAddedThisMonth(List<UserPlant> plants) {
    final now = DateTime.now();
    return plants.where((plant) {
      return plant.dateAdded.year == now.year && plant.dateAdded.month == now.month;
    }).length;
  }

  List<Widget> _buildCategoryChips(List<UserPlant> plants) {
    final categories = ['All', ..._getUniqueCategories(plants)];
    
    return categories.map((category) {
      final isSelected = category == _selectedCategory;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _selectedCategory = category);
          },
        ),
      );
    }).toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Plants'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter plant name...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showPlantDetails(UserPlant plant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => _PlantDetailsSheet(
          plant: plant,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _deletePlant(GardenProvider provider, UserPlant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Plant'),
        content: Text('Are you sure you want to remove ${plant.customName ?? plant.plant.commonName} from your garden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removePlant(plant.id);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _PlantCard extends StatelessWidget {
  final UserPlant plant;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PlantCard({
    required this.plant,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: plant.photos.isNotEmpty
                    ? Image.asset(
                        plant.photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _PlaceholderImage(),
                      )
                    : _PlaceholderImage(),
              ),
            ),
            
            // Plant Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.customName ?? plant.plant.commonName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      plant.plant.scientificName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${plant.dateAdded.day}/${plant.dateAdded.month}/${plant.dateAdded.year}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
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

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.local_florist,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _EmptyGardenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist_outlined,
              size: 96,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Your garden is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by identifying your first plant using the camera',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/camera'),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Identify Plant'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantDetailsSheet extends StatelessWidget {
  final UserPlant plant;
  final ScrollController scrollController;

  const _PlantDetailsSheet({
    required this.plant,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Plant Name
            Text(
              plant.customName ?? plant.plant.commonName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              plant.plant.scientificName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            
            // Care Requirements
            Text(
              'Care Requirements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            _CareRequirementItem(
              icon: Icons.water_drop,
              label: 'Water',
              value: plant.plant.care.waterFrequency,
            ),
            _CareRequirementItem(
              icon: Icons.wb_sunny,
              label: 'Light',
              value: plant.plant.care.lightRequirement,
            ),
            _CareRequirementItem(
              icon: Icons.grass,
              label: 'Soil',
              value: plant.plant.care.soilType,
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            if (plant.notes.isNotEmpty) ...[
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...plant.notes.map((note) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $note'),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _CareRequirementItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CareRequirementItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}