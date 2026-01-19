import 'package:flutter/material.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.schedule), text: 'Reminders'),
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            Tab(icon: Icon(Icons.tips_and_updates), text: 'Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _RemindersTab(),
          _CalculatorTab(),
          _TipsTab(),
        ],
      ),
    );
  }
}

class _RemindersTab extends StatelessWidget {
  const _RemindersTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Today's Tasks Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Today\'s Tasks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _TaskItem(
                    icon: Icons.water_drop,
                    task: 'Water Monstera',
                    time: '9:00 AM',
                    isCompleted: false,
                  ),
                  const _TaskItem(
                    icon: Icons.eco,
                    task: 'Fertilize Rose',
                    time: '2:00 PM',
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Upcoming Tasks
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Tasks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: const [
                          _UpcomingTaskItem(
                            plant: 'Snake Plant',
                            task: 'Water',
                            date: 'Tomorrow',
                          ),
                          _UpcomingTaskItem(
                            plant: 'Fiddle Leaf Fig',
                            task: 'Rotate',
                            date: 'In 2 days',
                          ),
                          _UpcomingTaskItem(
                            plant: 'Peace Lily',
                            task: 'Mist leaves',
                            date: 'In 3 days',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final IconData icon;
  final String task;
  final String time;
  final bool isCompleted;

  const _TaskItem({
    required this.icon,
    required this.task,
    required this.time,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted 
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                    : null,
              ),
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingTaskItem extends StatelessWidget {
  final String plant;
  final String task;
  final String date;

  const _UpcomingTaskItem({
    required this.plant,
    required this.task,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.local_florist,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text('$task $plant'),
      subtitle: Text(date),
      trailing: IconButton(
        icon: const Icon(Icons.notifications_none),
        onPressed: () {},
      ),
    );
  }
}

class _CalculatorTab extends StatefulWidget {
  const _CalculatorTab();

  @override
  State<_CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<_CalculatorTab> {
  final _potSizeController = TextEditingController();
  String _selectedPlantType = 'Houseplant';
  String _selectedSeason = 'Spring';
  double _calculatedAmount = 0.0;

  final List<String> _plantTypes = [
    'Houseplant',
    'Succulent',
    'Tropical',
    'Flowering',
    'Herb',
  ];

  final List<String> _seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
  ];

  @override
  void dispose() {
    _potSizeController.dispose();
    super.dispose();
  }

  void _calculateWater() {
    final potSize = double.tryParse(_potSizeController.text) ?? 0.0;
    if (potSize > 0) {
      // Simple calculation formula
      double baseAmount = potSize * 0.1; // 10% of pot volume
      
      // Adjust for plant type
      switch (_selectedPlantType) {
        case 'Succulent':
          baseAmount *= 0.5;
          break;
        case 'Tropical':
          baseAmount *= 1.3;
          break;
        case 'Flowering':
          baseAmount *= 1.2;
          break;
      }
      
      // Adjust for season
      switch (_selectedSeason) {
        case 'Summer':
          baseAmount *= 1.4;
          break;
        case 'Winter':
          baseAmount *= 0.7;
          break;
        case 'Fall':
          baseAmount *= 0.8;
          break;
      }
      
      setState(() {
        _calculatedAmount = baseAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Calculator',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Pot Size Input
                  TextField(
                    controller: _potSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pot Size (inches)',
                      hintText: 'Enter pot diameter',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Plant Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedPlantType,
                    decoration: const InputDecoration(
                      labelText: 'Plant Type',
                      prefixIcon: Icon(Icons.local_florist),
                    ),
                    items: _plantTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedPlantType = value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Season Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedSeason,
                    decoration: const InputDecoration(
                      labelText: 'Season',
                      prefixIcon: Icon(Icons.wb_sunny),
                    ),
                    items: _seasons.map((season) {
                      return DropdownMenuItem(
                        value: season,
                        child: Text(season),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedSeason = value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Calculate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _calculateWater,
                      child: const Text('Calculate Water Amount'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Result Card
          if (_calculatedAmount > 0)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recommended Amount',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_calculatedAmount.toStringAsFixed(1)} cups',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Water slowly until soil is moist but not soggy',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TipsTab extends StatelessWidget {
  const _TipsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _TipCard(
          icon: Icons.water_drop,
          title: 'Watering Tips',
          content: 'Check soil moisture before watering. Most plants prefer soil that\'s slightly dry between waterings.',
        ),
        _TipCard(
          icon: Icons.wb_sunny,
          title: 'Light Requirements',
          content: 'Rotate your plants weekly to ensure even growth. Most houseplants prefer bright, indirect light.',
        ),
        _TipCard(
          icon: Icons.thermostat,
          title: 'Temperature Control',
          content: 'Keep plants away from heating vents and air conditioners. Most houseplants thrive in 65-75°F.',
        ),
        _TipCard(
          icon: Icons.opacity,
          title: 'Humidity',
          content: 'Increase humidity by grouping plants together or using a humidifier. Many plants prefer 40-60% humidity.',
        ),
        _TipCard(
          icon: Icons.eco,
          title: 'Fertilizing',
          content: 'Feed plants during growing season (spring/summer). Use diluted fertilizer every 2-4 weeks.',
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.content,
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
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}