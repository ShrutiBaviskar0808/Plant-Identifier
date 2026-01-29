import 'package:flutter/material.dart';
import '../../../core/data/services/plant_api_service.dart';
import '../../../core/data/models/plant_api_model.dart';
import 'plant_detail_view.dart';

class PlantCatalogListView extends StatefulWidget {
  const PlantCatalogListView({super.key});

  @override
  State<PlantCatalogListView> createState() => _PlantCatalogListViewState();
}

class _PlantCatalogListViewState extends State<PlantCatalogListView> {
  List<PlantApiModel> plants = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final fetchedPlants = await PlantApiService.fetchPlants();
      setState(() {
        plants = fetchedPlants;
        isLoading = false;
      });
    } catch (e) {
      print('API Error: $e');
      // Fallback to sample data if API fails
      setState(() {
        plants = _createSamplePlants();
        isLoading = false;
        errorMessage = null; // Don't show error if we have fallback data
      });
    }
  }

  List<PlantApiModel> _createSamplePlants() {
    return [
      PlantApiModel(
        id: 1,
        name: 'Monstera Deliciosa',
        scientificName: 'Monstera deliciosa',
        description: 'Popular houseplant with split leaves',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
        waterRequirement: 'Weekly',
        lightRequirement: 'Bright indirect light',
        soilType: 'Well-draining potting mix',
        temperature: '65-80°F (18-27°C)',
        humidity: '60-70%',
        fertilizer: 'Monthly during growing season',
        toxicity: 'Toxic to pets',
        difficulty: 'Easy',
        matureSize: '6-10 feet',
        growingSeason: 'Spring to Fall',
        benefits: ['Air purifying', 'Low maintenance'],
      ),
      PlantApiModel(
        id: 2,
        name: 'Snake Plant',
        scientificName: 'Sansevieria trifasciata',
        description: 'Low-maintenance succulent perfect for beginners',
        imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=300',
        waterRequirement: 'Bi-weekly',
        lightRequirement: 'Low to bright indirect light',
        soilType: 'Cactus or succulent mix',
        temperature: '60-80°F (15-27°C)',
        humidity: '30-50%',
        fertilizer: 'Every 2-3 months',
        toxicity: 'Mildly toxic to pets',
        difficulty: 'Very Easy',
        matureSize: '2-4 feet',
        growingSeason: 'Year-round',
        benefits: ['Air purifying', 'Drought tolerant', 'Low light tolerant'],
      ),
      PlantApiModel(
        id: 3,
        name: 'Pothos',
        scientificName: 'Epipremnum aureum',
        description: 'Trailing vine with heart-shaped leaves',
        imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=300',
        waterRequirement: 'Weekly',
        lightRequirement: 'Low to bright indirect light',
        soilType: 'Well-draining potting mix',
        temperature: '65-85°F (18-29°C)',
        humidity: '50-70%',
        fertilizer: 'Monthly during growing season',
        toxicity: 'Toxic to pets',
        difficulty: 'Very Easy',
        matureSize: '6-10 feet long',
        growingSeason: 'Year-round',
        benefits: ['Air purifying', 'Fast growing', 'Versatile placement'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Catalog',
          style: TextStyle(
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Loading plants...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Failed to load plants',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                _loadPlants();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: plants.length,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return _buildPlantListItem(plant, context);
      },
    );
  }

  Widget _buildPlantListItem(PlantApiModel plant, BuildContext context) {
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
          child: Image.network(
            plant.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorIcon();
            },
          ),
        ),
        title: Text(
          plant.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant.scientificName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.water_drop, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    plant.waterRequirement,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(plant.difficulty),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    plant.difficulty,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailView(plantApi: plant),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(
        Icons.local_florist,
        size: 30,
        color: Colors.grey,
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'very easy':
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
      case 'difficult':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}