enum ReminderType {
  watering,
  fertilizing,
  repotting,
  pruning,
  custom;

  String get displayName {
    switch (this) {
      case ReminderType.watering:
        return 'Watering';
      case ReminderType.fertilizing:
        return 'Fertilizing';
      case ReminderType.repotting:
        return 'Repotting';
      case ReminderType.pruning:
        return 'Pruning';
      case ReminderType.custom:
        return 'Custom';
    }
  }
}

class CareReminder {
  final String id;
  final String plantId;
  final ReminderType type;
  final String title;
  final String? description;
  final DateTime nextDue;
  final int intervalDays;
  final bool isActive;
  final DateTime createdAt;

  CareReminder({
    required this.id,
    required this.plantId,
    required this.type,
    required this.title,
    this.description,
    required this.nextDue,
    required this.intervalDays,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CareReminder.fromJson(Map<String, dynamic> json) {
    return CareReminder(
      id: json['id'],
      plantId: json['plantId'],
      type: ReminderType.values[json['type']],
      title: json['title'],
      description: json['description'],
      nextDue: DateTime.parse(json['nextDue']),
      intervalDays: json['intervalDays'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'type': type.index,
      'title': title,
      'description': description,
      'nextDue': nextDue.toIso8601String(),
      'intervalDays': intervalDays,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class GrowthEntry {
  final String id;
  final String plantId;
  final String title;
  final String? notes;
  final String? imagePath;
  final DateTime date;

  GrowthEntry({
    required this.id,
    required this.plantId,
    required this.title,
    this.notes,
    this.imagePath,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory GrowthEntry.fromJson(Map<String, dynamic> json) {
    return GrowthEntry(
      id: json['id'],
      plantId: json['plantId'],
      title: json['title'],
      notes: json['notes'],
      imagePath: json['imagePath'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'title': title,
      'notes': notes,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
    };
  }
}