import 'package:flutter/material.dart';

enum ToxicityLevel {
  safe,
  mildlyToxic,
  moderatelyToxic,
  highlyToxic;

  String get displayName {
    switch (this) {
      case ToxicityLevel.safe:
        return 'Safe';
      case ToxicityLevel.mildlyToxic:
        return 'Mildly Toxic';
      case ToxicityLevel.moderatelyToxic:
        return 'Moderately Toxic';
      case ToxicityLevel.highlyToxic:
        return 'Highly Toxic';
    }
  }

  Color get color {
    switch (this) {
      case ToxicityLevel.safe:
        return Colors.green;
      case ToxicityLevel.mildlyToxic:
        return Colors.yellow;
      case ToxicityLevel.moderatelyToxic:
        return Colors.orange;
      case ToxicityLevel.highlyToxic:
        return Colors.red;
    }
  }
}

class SafetyInfo {
  final ToxicityLevel petToxicity;
  final ToxicityLevel humanToxicity;
  final List<String> symptoms;
  final List<String> precautions;
  final int allergenLevel; // 1-10 scale
  final bool producesPollenAllergens;

  SafetyInfo({
    required this.petToxicity,
    required this.humanToxicity,
    required this.symptoms,
    required this.precautions,
    required this.allergenLevel,
    required this.producesPollenAllergens,
  });
}

class SafetyService {
  static final Map<String, SafetyInfo> _safetyDatabase = {
    'monstera_deliciosa': SafetyInfo(
      petToxicity: ToxicityLevel.moderatelyToxic,
      humanToxicity: ToxicityLevel.mildlyToxic,
      symptoms: ['Oral irritation', 'Difficulty swallowing', 'Vomiting'],
      precautions: ['Keep away from pets and children', 'Wash hands after handling'],
      allergenLevel: 3,
      producesPollenAllergens: false,
    ),
    'sansevieria_trifasciata': SafetyInfo(
      petToxicity: ToxicityLevel.mildlyToxic,
      humanToxicity: ToxicityLevel.safe,
      symptoms: ['Nausea', 'Vomiting (if ingested in large quantities)'],
      precautions: ['Generally safe but avoid ingestion'],
      allergenLevel: 1,
      producesPollenAllergens: false,
    ),
    'spathiphyllum_wallisii': SafetyInfo(
      petToxicity: ToxicityLevel.moderatelyToxic,
      humanToxicity: ToxicityLevel.mildlyToxic,
      symptoms: ['Oral irritation', 'Difficulty swallowing', 'Skin irritation'],
      precautions: ['Keep away from pets', 'Use gloves when handling'],
      allergenLevel: 6,
      producesPollenAllergens: true,
    ),
  };

  static SafetyInfo? getSafetyInfo(String plantId) {
    return _safetyDatabase[plantId.toLowerCase().replaceAll(' ', '_')];
  }

  static List<String> getPetSafePlants() {
    return _safetyDatabase.entries
        .where((entry) => entry.value.petToxicity == ToxicityLevel.safe)
        .map((entry) => entry.key)
        .toList();
  }

  static List<String> getLowAllergenPlants() {
    return _safetyDatabase.entries
        .where((entry) => entry.value.allergenLevel <= 3 && !entry.value.producesPollenAllergens)
        .map((entry) => entry.key)
        .toList();
  }
}