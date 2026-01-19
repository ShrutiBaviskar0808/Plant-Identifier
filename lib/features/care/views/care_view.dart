import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/care_controller.dart';

class CareView extends GetView<CareController> {
  const CareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Tasks
            Text(
              'Today\'s Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No tasks for today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Care Tips
            Text(
              'Care Tips',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildCareTip(
              context,
              Icons.water_drop,
              'Watering',
              'Check soil moisture before watering',
            ),
            _buildCareTip(
              context,
              Icons.wb_sunny,
              'Light',
              'Most plants need bright, indirect light',
            ),
            _buildCareTip(
              context,
              Icons.thermostat,
              'Temperature',
              'Keep plants away from drafts and heat sources',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareTip(BuildContext context, IconData icon, String title, String tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tip),
      ),
    );
  }
}