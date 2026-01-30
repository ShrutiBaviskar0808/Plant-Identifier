import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/data/models/plant_catalog.dart';
import '../../../core/data/models/plant_api_model.dart';

class PlantDetailView extends StatelessWidget {
  final PlantCatalogItem? plant;
  final PlantApiModel? plantApi;

  const PlantDetailView({super.key, this.plant, this.plantApi});

  String get plantName => plant?.name ?? plantApi?.name ?? '';
  String get scientificName => plant?.scientificName ?? plantApi?.scientificName ?? '';
  String get description => plant?.description ?? plantApi?.description ?? '';
  String get imageUrl => plant?.imageUrl ?? plantApi?.imageUrl ?? '';
  bool get isApiPlant => plantApi != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          plantName,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: _buildPlantImage(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    scientificName,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  _buildCareInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    if (isApiPlant) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
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
          return _buildErrorWidget();
        },
      );
    }
    
    return Builder(
      builder: (context) => FutureBuilder<bool>(
        future: _checkAssetExists(imageUrl, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }
          
          if (snapshot.hasData && snapshot.data == true) {
            return Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              cacheWidth: kIsWeb ? null : 800,
              cacheHeight: kIsWeb ? null : 600,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            );
          }
          
          return _buildErrorWidget();
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text('Image not available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkAssetExists(String assetPath, BuildContext context) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildCareInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Care Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        if (isApiPlant) ..._buildApiCareInfo() else ..._buildLegacyCareInfo(),
      ],
    );
  }

  List<Widget> _buildApiCareInfo() {
    return [
      _buildInfoRow(Icons.water_drop, 'Watering', plantApi!.waterRequirement),
      _buildInfoRow(Icons.wb_sunny, 'Light', plantApi!.lightRequirement),
      _buildInfoRow(Icons.thermostat, 'Temperature', plantApi!.temperature),
      _buildInfoRow(Icons.grass, 'Soil', plantApi!.soilType),
      _buildInfoRow(Icons.science, 'Fertilizer', plantApi!.fertilizer),
      _buildInfoRow(Icons.warning, 'Toxicity', plantApi!.toxicity),
      _buildInfoRow(Icons.straighten, 'Mature Size', plantApi!.matureSize),
      _buildInfoRow(Icons.calendar_month, 'Growing Season', plantApi!.growingSeason),
      if (plantApi!.benefits.isNotEmpty)
        _buildBenefitsSection(plantApi!.benefits),
    ];
  }

  List<Widget> _buildLegacyCareInfo() {
    return [
      _buildInfoRow(Icons.water_drop, 'Watering', '${plant!.waterRequirement.frequency} - ${plant!.waterRequirement.amount}'),
      _buildInfoRow(Icons.wb_sunny, 'Light', plant!.lightRequirement),
      _buildInfoRow(Icons.thermostat, 'Temperature', plant!.temperature),
      _buildInfoRow(Icons.grass, 'Soil', plant!.soilType),
      _buildInfoRow(Icons.science, 'Fertilizer', plant!.fertilizer),
      _buildInfoRow(Icons.warning, 'Toxicity', plant!.toxicity),
      if (plant!.benefits.isNotEmpty)
        _buildBenefitsSection(plant!.benefits),
    ];
  }

  Widget _buildBenefitsSection(List<String> benefits) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Text(
                'Benefits',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: benefits.map((benefit) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                benefit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}