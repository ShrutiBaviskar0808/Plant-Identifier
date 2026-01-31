import 'package:flutter/material.dart';

class PestControlView extends StatelessWidget {
  const PestControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pest Control', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
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
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text('🛡️', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keep Plants Healthy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Identify and treat common plant pests', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildSection('Common Pests', [
                'Aphids: Small green/black insects on leaves',
                'Spider Mites: Tiny webs, stippled leaves',
                'Mealybugs: White cottony masses',
                'Scale: Brown/white bumps on stems',
                'Fungus Gnats: Small flies around soil',
              ]),
              _buildSection('Natural Treatments', [
                'Neem oil spray for most pests',
                'Insecticidal soap for soft-bodied insects',
                'Rubbing alcohol on cotton swab for mealybugs',
                'Yellow sticky traps for flying pests',
                'Diatomaceous earth for crawling insects',
              ]),
              _buildSection('Prevention Tips', [
                'Inspect new plants before bringing home',
                'Quarantine new plants for 2 weeks',
                'Keep plants clean and dust-free',
                'Avoid overwatering to prevent fungus gnats',
                'Provide good air circulation',
                'Remove dead or damaged plant material',
              ]),
              _buildSection('When to Act', [
                'Weekly inspection of all plants',
                'Look under leaves and along stems',
                'Check soil surface for pests',
                'Isolate infected plants immediately',
                'Treat early for best results',
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
              Icon(Icons.shield, color: Colors.red, size: 16),
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