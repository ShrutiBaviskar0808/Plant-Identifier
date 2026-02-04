import 'package:flutter/material.dart';

class LightRequirementsView extends StatelessWidget {
  const LightRequirementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Light Requirements', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 18)),
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text('☀️', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Optimal Lighting Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Understanding light needs for healthy plants', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildSection('Light Types', [
                'Direct Light: 6+ hours of direct sunlight',
                'Bright Indirect: Bright but no direct sun rays',
                'Medium Light: Some direct morning/evening sun',
                'Low Light: Minimal natural light, can use artificial',
              ]),
              _buildSection('Plant Categories', [
                'Full Sun: Succulents, cacti, herbs',
                'Bright Indirect: Monstera, fiddle leaf fig',
                'Medium Light: Pothos, snake plant',
                'Low Light: ZZ plant, peace lily, cast iron plant',
              ]),
              _buildSection('Signs of Too Much Light', [
                'Scorched or brown leaf edges',
                'Faded or washed-out colors',
                'Wilting during hottest part of day',
                'Dry, crispy leaves',
              ]),
              _buildSection('Signs of Too Little Light', [
                'Leggy, stretched growth',
                'Small, pale leaves',
                'Slow or no growth',
                'Leaning toward light source',
                'Loss of variegation in colorful plants',
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
              Icon(Icons.wb_sunny, color: Colors.orange, size: 16),
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