import 'package:flutter/material.dart';

class FertilizingTipsView extends StatelessWidget {
  const FertilizingTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fertilizing Tips', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text('🌱', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nutrient Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Feed your plants for optimal growth', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildSection('Fertilizer Types', [
                'Liquid: Fast-acting, easy to control dosage',
                'Granular: Slow-release, long-lasting nutrition',
                'Organic: Compost, worm castings, fish emulsion',
                'Synthetic: Concentrated nutrients, quick results',
              ]),
              _buildSection('NPK Numbers', [
                'N (Nitrogen): Promotes leaf and stem growth',
                'P (Phosphorus): Encourages root and flower development',
                'K (Potassium): Strengthens overall plant health',
                'Balanced (10-10-10): Good for most houseplants',
              ]),
              _buildSection('Feeding Schedule', [
                'Growing season (Spring/Summer): Every 2-4 weeks',
                'Dormant season (Fall/Winter): Monthly or stop feeding',
                'Fast growers: More frequent feeding',
                'Slow growers: Less frequent feeding',
                'Always water before fertilizing',
              ]),
              _buildSection('Signs of Over-fertilizing', [
                'Excessive green growth with few flowers',
                'Brown leaf tips or edges',
                'White crust on soil surface',
                'Wilting despite adequate water',
                'Stunted growth',
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
              Icon(Icons.eco, color: Colors.green, size: 16),
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