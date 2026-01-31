import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/services/notification_service.dart';
import 'watering_guide_view.dart';
import 'light_requirements_view.dart';
import 'fertilizing_tips_view.dart';
import 'pest_control_view.dart';


class CareView extends StatefulWidget {
  const CareView({super.key});

  @override
  State<CareView> createState() => _CareViewState();
}

class _CareViewState extends State<CareView> {
  List<bool> taskCompleted = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Care',
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green[800]),

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTodaysReminders(),
              _buildCareGuides(),
              _buildPlantTips(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysReminders() {
    final reminders = [
      {
        'plant': 'Monstera Deliciosa',
        'task': 'Watering',
        'time': '9:00 AM',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'image': '🌿'
      },
      {
        'plant': 'Snake Plant',
        'task': 'Fertilizing',
        'time': '2:00 PM',
        'icon': Icons.eco,
        'color': Colors.green,
        'image': '🐍'
      },
      {
        'plant': 'Peace Lily',
        'task': 'Misting',
        'time': '6:00 PM',
        'icon': Icons.opacity,
        'color': Colors.purple,
        'image': '🕊️'
      },
    ];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'Today\'s Care Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...reminders.map((reminder) => Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (reminder['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      reminder['image'] as String,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${reminder['plant']} - ${reminder['task']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Scheduled at ${reminder['time']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        taskCompleted[reminders.indexOf(reminder)] = !taskCompleted[reminders.indexOf(reminder)];
                      });
                      NotificationService.addNotification(PlantNotification(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: 'Task Completed! 🎉',
                        message: '${reminder['plant']} ${reminder['task']} completed successfully',
                        type: NotificationType.general,
                      ));
                      Get.snackbar(
                        'Task Completed',
                        '${reminder['task']} for ${reminder['plant']} marked as done!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Icon(
                      taskCompleted[reminders.indexOf(reminder)] ? Icons.check : Icons.add,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCareGuides() {
    final guides = [
      {
        'title': 'Watering Guide',
        'desc': 'Perfect watering techniques',
        'icon': '💧',
        'color': Colors.blue,
        'tips': '2-3 times per week'
      },
      {
        'title': 'Light Requirements',
        'desc': 'Optimal lighting conditions',
        'icon': '☀️',
        'color': Colors.orange,
        'tips': 'Bright indirect light'
      },
      {
        'title': 'Fertilizing Tips',
        'desc': 'Nutrient management',
        'icon': '🌱',
        'color': Colors.green,
        'tips': 'Monthly feeding'
      },
      {
        'title': 'Pest Control',
        'desc': 'Keep plants healthy',
        'icon': '🛡️',
        'color': Colors.red,
        'tips': 'Weekly inspection'
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: Colors.purple, size: 20),
              SizedBox(width: 8),
              Text(
                'Care Guides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: guides.map((guide) => InkWell(
              onTap: () {
                Widget targetView;
                switch (guide['title']) {
                  case 'Watering Guide':
                    targetView = WateringGuideView();
                    break;
                  case 'Light Requirements':
                    targetView = LightRequirementsView();
                    break;
                  case 'Fertilizing Tips':
                    targetView = FertilizingTipsView();
                    break;
                  case 'Pest Control':
                    targetView = PestControlView();
                    break;
                  default:
                    targetView = WateringGuideView();
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => targetView));
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (guide['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          guide['icon'] as String,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      guide['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      guide['tips'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantTips() {
    final tips = [
      {'tip': 'Water plants early morning for best absorption', 'icon': '🌅'},
      {'tip': 'Check soil moisture before watering - finger test', 'icon': '👆'},
      {'tip': 'Rotate plants weekly for even growth', 'icon': '🔄'},
      {'tip': 'Clean leaves monthly for better photosynthesis', 'icon': '🧽'},
      {'tip': 'Group plants with similar care needs', 'icon': '👥'},
      {'tip': 'Use room temperature water to avoid shock', 'icon': '🌡️'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb, color: Colors.orange, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Expert Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...tips.map((tip) => Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  tip['icon'] as String,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip['tip'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}