import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/data/models/plant_identification.dart';
import '../../../core/data/models/plant.dart';

class PlantResultScreen extends StatelessWidget {
  final PlantIdentification identification;

  const PlantResultScreen({
    super.key,
    required this.identification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(identification.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Results Header
                  Text(
                    'Identification Results',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results List
                  if (identification.results.isEmpty)
                    _NoResultsCard()
                  else
                    ...identification.results.asMap().entries.map(
                      (entry) => _ResultCard(
                        result: entry.value,
                        rank: entry.key + 1,
                        onAddToGarden: () => _addToGarden(context, entry.value),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Try Again'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          ),
                          icon: const Icon(Icons.home),
                          label: const Text('Home'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToGarden(BuildContext context, IdentificationResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.plant.commonName} added to your garden!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final IdentificationResult result;
  final int rank;
  final VoidCallback onAddToGarden;

  const _ResultCard({
    required this.result,
    required this.rank,
    required this.onAddToGarden,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.plant.commonName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        result.plant.scientificName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(result.confidence).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(result.confidence * 100).toInt()}%',
                    style: TextStyle(
                      color: _getConfidenceColor(result.confidence),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Text(
              result.plant.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddToGarden,
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Garden'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showPlantDetails(context),
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  void _showPlantDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.plant.commonName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result.plant.scientificName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                _CareInfoSection(care: result.plant.careRequirements),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CareInfoSection extends StatelessWidget {
  final PlantCareRequirements care;

  const _CareInfoSection({required this.care});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Care Requirements',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        _CareItem(icon: Icons.water_drop, label: 'Water', value: '${care.water.frequency} - ${care.water.amount}'),
        _CareItem(icon: Icons.wb_sunny, label: 'Light', value: '${care.light.level} (${care.light.hoursPerDay}h/day)'),
        _CareItem(icon: Icons.grass, label: 'Soil', value: care.soilType),
        _CareItem(icon: Icons.thermostat, label: 'Temperature', value: '${care.temperature.minTemp}-${care.temperature.maxTemp}°${care.temperature.unit}'),
        _CareItem(icon: Icons.eco, label: 'Fertilizer', value: care.fertilizer),
        _CareItem(icon: Icons.content_cut, label: 'Pruning', value: care.pruning),
      ],
    );
  }
}

class _CareItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CareItem({
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

class _NoResultsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No plants identified',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try taking a clearer photo or adjusting the lighting',
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

class _AddToGardenDialog extends StatefulWidget {
  final Plant plant;
  final Function(String?, String?) onAdd;

  const _AddToGardenDialog({
    required this.plant,
    required this.onAdd,
  });

  @override
  State<_AddToGardenDialog> createState() => _AddToGardenDialogState();
}

class _AddToGardenDialogState extends State<_AddToGardenDialog> {
  final _customNameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _customNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.plant.commonName} to Garden'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _customNameController,
            decoration: const InputDecoration(
              labelText: 'Custom Name (Optional)',
              hintText: 'My favorite rose',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location (Optional)',
              hintText: 'Living room, Garden bed 1',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => widget.onAdd(
            _customNameController.text.isEmpty ? null : _customNameController.text,
            _locationController.text.isEmpty ? null : _locationController.text,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}