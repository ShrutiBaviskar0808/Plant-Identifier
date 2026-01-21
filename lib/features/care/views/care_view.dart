import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/care_controller.dart';
import '../../../core/data/models/care_models.dart';
import '../../../core/data/services/care_reminder_service.dart';
import '../../../core/data/services/environmental_service.dart';
import '../../../core/data/services/sustainability_service.dart';
import 'care_coach_view.dart';
import 'ar_camera_view.dart';

class CareView extends GetView<CareController> {
  const CareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm),
            onPressed: () => _showAddReminderDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger rebuild
          (context as Element).markNeedsBuild();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodaysReminders(),
              const SizedBox(height: 16),
              _buildWeatherAlerts(),
              const SizedBox(height: 24),
              _buildQuickTools(context),
              const SizedBox(height: 24),
              _buildExpertTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysReminders() {
    final todaysReminders = CareReminderService.getTodaysReminders();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.today, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Today\'s Care Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (todaysReminders.isEmpty)
              const Text('No tasks for today! 🌱')
            else
              ...todaysReminders.map((reminder) => _buildReminderTile(reminder)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTile(CareReminder reminder) {
    return ListTile(
      leading: Icon(_getReminderIcon(reminder.type)),
      title: Text(reminder.title),
      subtitle: Text(reminder.description ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.check_circle_outline),
        onPressed: () {
          CareReminderService.completeReminder(reminder.id);
          Get.snackbar('Completed', '${reminder.title} marked as done!');
        },
      ),
    );
  }

  Widget _buildQuickTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Care Tools',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _buildToolCard(
              icon: Icons.smart_toy,
              title: 'AI Coach',
              onTap: () => Get.to(() => const CareCoachView()),
            ),
            _buildToolCard(
              icon: Icons.camera_enhance,
              title: 'AR Care View',
              onTap: () => Get.to(() => const ARCameraView()),
            ),
            _buildToolCard(
              icon: Icons.health_and_safety,
              title: 'Health Score',
              onTap: () => _showHealthScore(context),
            ),
            _buildToolCard(
              icon: Icons.eco,
              title: 'Eco Impact',
              onTap: () => _showSustainabilityMetrics(context),
            ),
            _buildToolCard(
              icon: Icons.water_drop,
              title: 'Water Calculator',
              onTap: () => _showWaterCalculator(context),
            ),
            _buildToolCard(
              icon: Icons.pets,
              title: 'Pet Safety',
              onTap: () => _showSafetyInfo(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpertTips() {
    final tips = [
      'Water in the morning for best absorption',
      'Check soil moisture before watering',
      'Rotate plants weekly for even growth',
      'Clean leaves monthly for better photosynthesis',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Quick Tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  IconData _getReminderIcon(ReminderType type) {
    switch (type) {
      case ReminderType.watering:
        return Icons.water_drop;
      case ReminderType.fertilizing:
        return Icons.eco;
      case ReminderType.repotting:
        return Icons.grass;
      case ReminderType.pruning:
        return Icons.content_cut;
      case ReminderType.custom:
        return Icons.task_alt;
    }
  }

  void _showAddReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddReminderDialog(),
    );
  }

  void _showWaterCalculator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const WaterCalculatorDialog(),
    );
  }

  Widget _buildWeatherAlerts() {
    return FutureBuilder<WeatherData>(
      future: EnvironmentalService.getCurrentWeather(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        final alerts = EnvironmentalService.getAlerts();
        if (alerts.isEmpty) return const SizedBox.shrink();
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Weather Alerts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...alerts.map((alert) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: alert.severity == 'critical' ? Colors.red : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              alert.message,
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSafetyInfo(BuildContext context) {
    Get.snackbar('Pet Safety', 'Check plant toxicity for pets and allergies');
  }

  void _showHealthScore(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plant Health Score'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              '85/100',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Excellent Health'),
            const SizedBox(height: 16),
            const Text('✓ Regular watering detected\n✓ Good light conditions\n⚠ Consider fertilizing'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSustainabilityMetrics(BuildContext context) {
    final metrics = SustainabilityService.calculateImpact(['plant1', 'plant2', 'plant3']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Eco Impact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.co2, color: Colors.green, size: 32),
                    Text('${metrics.co2AbsorbedKg.toStringAsFixed(1)} kg'),
                    const Text('CO₂ Absorbed', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.air, color: Colors.blue, size: 32),
                    Text('${metrics.oxygenProducedKg.toStringAsFixed(1)} kg'),
                    const Text('O₂ Produced', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Eco Score: ${metrics.ecoScore}/100',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class WaterCalculatorDialog extends StatefulWidget {
  const WaterCalculatorDialog({super.key});

  @override
  State<WaterCalculatorDialog> createState() => _WaterCalculatorDialogState();
}

class _WaterCalculatorDialogState extends State<WaterCalculatorDialog> {
  final _potSizeController = TextEditingController();
  String _plantType = 'tropical';
  String _season = 'spring';
  double? _waterAmount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Water Calculator'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _potSizeController,
            decoration: const InputDecoration(
              labelText: 'Pot Size (cm)',
              hintText: 'Enter pot diameter',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _plantType,
            decoration: const InputDecoration(labelText: 'Plant Type'),
            items: ['tropical', 'succulent', 'flowering', 'tree']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_capitalize(type)),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _plantType = value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _season,
            decoration: const InputDecoration(labelText: 'Season'),
            items: ['spring', 'summer', 'fall', 'winter']
                .map((season) => DropdownMenuItem(
                      value: season,
                      child: Text(_capitalize(season)),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _season = value!),
          ),
          if (_waterAmount != null)
            const SizedBox(height: 16),
          if (_waterAmount != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Recommended: ${_waterAmount!} liters',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: _calculateWater,
          child: const Text('Calculate'),
        ),
      ],
    );
  }

  void _calculateWater() {
    final potSize = double.tryParse(_potSizeController.text);
    if (potSize != null) {
      setState(() {
        _waterAmount = CareReminderService.calculateWaterAmount(
          potSizeCm: potSize,
          plantType: _plantType,
          season: _season,
        );
      });
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _potSizeController.dispose();
    super.dispose();
  }
}

class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({super.key});

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final _titleController = TextEditingController();
  ReminderType _type = ReminderType.watering;
  int _intervalDays = 7;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Reminder Title',
              hintText: 'e.g., Water my Monstera',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ReminderType>(
            value: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: ReminderType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _type = value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _intervalDays,
            decoration: const InputDecoration(labelText: 'Repeat Every'),
            items: [1, 3, 7, 14, 30]
                .map((days) => DropdownMenuItem(
                      value: days,
                      child: Text('$days day${days > 1 ? 's' : ''}'),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _intervalDays = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addReminder,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addReminder() {
    if (_titleController.text.isNotEmpty) {
      final reminder = CareReminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        plantId: 'default',
        type: _type,
        title: _titleController.text,
        nextDue: DateTime.now().add(Duration(days: _intervalDays)),
        intervalDays: _intervalDays,
      );
      
      CareReminderService.addReminder(reminder);
      Navigator.pop(context);
      Get.snackbar('Success', 'Reminder added successfully!');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}