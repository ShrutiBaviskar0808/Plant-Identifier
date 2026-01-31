import 'package:flutter/material.dart';

class WateringGuideView extends StatelessWidget {
  const WateringGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watering Guide', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green[800]),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text('💧', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Perfect Watering Techniques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Learn how to water your plants properly', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildSection('General Guidelines', [
                'Check soil moisture before watering',
                'Water early morning for best absorption',
                'Use room temperature water',
                'Water slowly and deeply',
                'Ensure proper drainage',
              ]),
              _buildSection('Frequency Guide', [
                'Succulents: Once every 1-2 weeks',
                'Tropical plants: 2-3 times per week',
                'Cacti: Once every 2-3 weeks',
                'Ferns: Keep soil consistently moist',
                'Snake plants: Every 2-3 weeks',
              ]),
              _buildSection('Signs of Overwatering', [
                'Yellow leaves',
                'Musty smell from soil',
                'Fungus gnats',
                'Soft, brown roots',
                'Wilting despite wet soil',
              ]),
              _buildSection('Signs of Underwatering', [
                'Dry, crispy leaves',
                'Soil pulling away from pot edges',
                'Drooping or wilting',
                'Slow growth',
                'Brown leaf tips',
              ]),
            ],
          ),
          ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Expanded(child: Text(item, style: TextStyle(fontSize: 14))),
            ],
          ),
        )),
        SizedBox(height: 20),
      ],
    );
  }
}