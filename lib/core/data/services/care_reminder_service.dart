import '../models/care_models.dart';
import '../models/plant.dart';
import 'notification_service.dart';

class CareReminderService {
  static final List<CareReminder> _reminders = [];
  static final List<GrowthEntry> _growthEntries = [];

  // Reminder Management
  static Future<void> addReminder(CareReminder reminder) async {
    _reminders.add(reminder);
    
    // Schedule notification
    NotificationService.scheduleReminderNotification(
      'Your Plant',
      reminder.type.displayName.toLowerCase(),
      reminder.nextDue,
    );
  }

  static List<CareReminder> getRemindersForPlant(String plantId) {
    return _reminders.where((r) => r.plantId == plantId && r.isActive).toList();
  }

  static List<CareReminder> getTodaysReminders() {
    final today = DateTime.now();
    return _reminders.where((r) => 
      r.isActive && 
      r.nextDue.year == today.year &&
      r.nextDue.month == today.month &&
      r.nextDue.day == today.day
    ).toList();
  }

  static Future<void> completeReminder(String reminderId) async {
    final reminder = _reminders.firstWhere((r) => r.id == reminderId);
    final nextDue = reminder.nextDue.add(Duration(days: reminder.intervalDays));
    
    final updatedReminder = CareReminder(
      id: reminder.id,
      plantId: reminder.plantId,
      type: reminder.type,
      title: reminder.title,
      description: reminder.description,
      nextDue: nextDue,
      intervalDays: reminder.intervalDays,
      isActive: reminder.isActive,
      createdAt: reminder.createdAt,
    );
    
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    _reminders[index] = updatedReminder;
    
    // Schedule next notification
    NotificationService.scheduleReminderNotification(
      'Your Plant',
      reminder.type.displayName.toLowerCase(),
      nextDue,
    );
  }

  // Auto-suggest reminders based on plant type
  static List<CareReminder> suggestReminders(Plant plant) {
    final suggestions = <CareReminder>[];
    final now = DateTime.now();
    
    // Watering reminder
    int wateringDays = _getWateringInterval(plant.careRequirements.water.frequency);
    suggestions.add(CareReminder(
      id: '${plant.id}_water',
      plantId: plant.id,
      type: ReminderType.watering,
      title: 'Water ${plant.commonName}',
      nextDue: now.add(Duration(days: wateringDays)),
      intervalDays: wateringDays,
    ));

    // Fertilizing reminder
    suggestions.add(CareReminder(
      id: '${plant.id}_fertilize',
      plantId: plant.id,
      type: ReminderType.fertilizing,
      title: 'Fertilize ${plant.commonName}',
      nextDue: now.add(Duration(days: 30)),
      intervalDays: 30,
    ));

    return suggestions;
  }

  static int _getWateringInterval(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily': return 1;
      case 'weekly': return 7;
      case 'bi-weekly': return 14;
      case 'monthly': return 30;
      default: return 7;
    }
  }

  // Growth Journal
  static Future<void> addGrowthEntry(GrowthEntry entry) async {
    _growthEntries.add(entry);
  }

  static List<GrowthEntry> getGrowthEntries(String plantId) {
    return _growthEntries
        .where((e) => e.plantId == plantId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Water Calculator
  static double calculateWaterAmount({
    required double potSizeCm,
    required String plantType,
    required String season,
  }) {
    double baseAmount = potSizeCm * 0.1; // Base: 10% of pot diameter in liters
    
    // Adjust for plant type
    switch (plantType.toLowerCase()) {
      case 'succulent':
        baseAmount *= 0.5;
        break;
      case 'tropical':
        baseAmount *= 1.2;
        break;
      case 'flowering':
        baseAmount *= 1.1;
        break;
    }
    
    // Adjust for season
    switch (season.toLowerCase()) {
      case 'summer':
        baseAmount *= 1.3;
        break;
      case 'winter':
        baseAmount *= 0.7;
        break;
      case 'spring':
      case 'fall':
        baseAmount *= 1.0;
        break;
    }
    
    return double.parse(baseAmount.toStringAsFixed(1));
  }
}