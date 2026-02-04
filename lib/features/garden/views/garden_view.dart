import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/garden_controller.dart';
import '../../../core/data/models/plant.dart';
import 'garden_plant_detail_view.dart';
import 'dart:io';


class GardenView extends GetView<GardenController> {
  const GardenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Garden',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
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
                  controller.error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadUserPlants,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.userPlants.isEmpty) {
          return const _EmptyGardenView();
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
                        value: '${controller.plantCount}',
                      ),
                      _StatItem(
                        icon: Icons.category,
                        label: 'Categories',
                        value: '${controller.getUniqueCategories().length}',
                      ),
                      _StatItem(
                        icon: Icons.calendar_today,
                        label: 'This Month',
                        value: '${controller.getPlantsAddedThisMonth()}',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Plants Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.userPlants.length,
                itemBuilder: (context, index) => _PlantCard(
                  plant: controller.userPlants[index],
                  onTap: () => _showPlantDetails(controller.userPlants[index]),
                  onDelete: () => _deletePlant(controller.userPlants[index]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showPlantDetails(UserPlant plant) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => GardenPlantDetailView(userPlant: plant),
      ),
    );
  }

  void _deletePlant(UserPlant plant) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Plant'),
        content: Text(
          'Are you sure you want to remove ${plant.customName ?? plant.plant.commonName} from your garden?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removePlant(plant.id);
              Get.back();
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

  Widget _buildAssetImageFallback(Plant plant) {
    // Map plant names to correct asset paths
    String getAssetPath(String plantName) {
      final name = plantName.toLowerCase();
      if (name.contains('hibiscus')) return 'assets/images/hibiscus.jpg';
      if (name.contains('monstera')) return 'assets/images/Monstera Deliciosa.jpg';
      if (name.contains('snake')) return 'assets/images/Snake Plant.jpg';
      return 'assets/images/${plant.commonName}.jpg';
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.asset(
        getAssetPath(plant.commonName),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (plant.imageUrls.isNotEmpty) {
            return Image.network(
              plant.imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.local_florist, size: 48);
              },
            );
          }
          return Icon(Icons.local_florist, size: 48);
        },
      ),
    );
  }

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
                child: plant.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: plant.imagePath!.startsWith('http')
                            ? Image.network(
                                plant.imagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAssetImageFallback(plant.plant);
                                },
                              )
                            : Image.file(
                                File(plant.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAssetImageFallback(plant.plant);
                                },
                              ),
                      )
                    : _buildAssetImageFallback(plant.plant),
              ),
            ),
            
            // Plant Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plant.customName ?? plant.plant.commonName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plant.plant.scientificName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
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
                          size: 10,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${plant.dateAdded.day}/${plant.dateAdded.month}/${plant.dateAdded.year}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                            Icons.delete_outline,
                            size: 14,
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

class _EmptyGardenView extends StatelessWidget {
  const _EmptyGardenView();

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
              'Use the Scan tab to identify and add plants to your garden',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
