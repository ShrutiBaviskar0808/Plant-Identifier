import 'plant.dart';

class UserPlant {
  final String id;
  final Plant plant;
  final String? customName;
  final List<String> notes;
  final DateTime dateAdded;
  final String? location;
  final List<String> photos;

  const UserPlant({
    required this.id,
    required this.plant,
    this.customName,
    required this.notes,
    required this.dateAdded,
    this.location,
    required this.photos,
  });

  factory UserPlant.fromJson(Map<String, dynamic> json) {
    return UserPlant(
      id: json['id'] as String,
      plant: Plant.fromJson(json['plant'] as Map<String, dynamic>),
      customName: json['custom_name'] as String?,
      notes: List<String>.from(json['notes'] as List),
      dateAdded: DateTime.parse(json['date_added'] as String),
      location: json['location'] as String?,
      photos: List<String>.from(json['photos'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant': plant.toJson(),
      'custom_name': customName,
      'notes': notes,
      'date_added': dateAdded.toIso8601String(),
      'location': location,
      'photos': photos,
    };
  }

  UserPlant copyWith({
    String? id,
    Plant? plant,
    String? customName,
    List<String>? notes,
    DateTime? dateAdded,
    String? location,
    List<String>? photos,
  }) {
    return UserPlant(
      id: id ?? this.id,
      plant: plant ?? this.plant,
      customName: customName ?? this.customName,
      notes: notes ?? this.notes,
      dateAdded: dateAdded ?? this.dateAdded,
      location: location ?? this.location,
      photos: photos ?? this.photos,
    );
  }
}