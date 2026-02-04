import 'package:flutter/material.dart';

class SoilAnalysisView extends StatelessWidget {
  const SoilAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Soil Analysis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.brown[800]),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.science, color: Colors.brown, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Soil Health',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Analyze soil conditions for optimal plant growth',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Soil Parameters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildParameterCard('pH Level', '6.0 - 7.0', 'Optimal acidity for most plants', Icons.science),
              _buildParameterCard('Moisture', '40 - 60%', 'Proper water retention', Icons.water_drop),
              _buildParameterCard('Nutrients', 'N-P-K Balance', 'Essential macro nutrients', Icons.eco),
              _buildParameterCard('Drainage', 'Well-draining', 'Prevents root rot', Icons.grain),
              SizedBox(height: 24),
              Text(
                'Testing Methods',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildFeatureItem(Icons.thermostat, 'Digital pH Meter', 'Accurate pH level measurement'),
              _buildFeatureItem(Icons.opacity, 'Moisture Sensor', 'Real-time soil moisture monitoring'),
              _buildFeatureItem(Icons.biotech, 'Nutrient Test Kit', 'Check N-P-K levels and deficiencies'),
              _buildFeatureItem(Icons.timer, 'Drainage Test', 'Evaluate soil water retention'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterCard(String parameter, String range, String description, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parameter,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '$range - $description',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.brown, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}