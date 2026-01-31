import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant.dart';

class UserPlantService {
  static final UserPlantService _instance = UserPlantService._internal();
  factory UserPlantService() => _instance;
  UserPlantService._internal();

  static const String _userPlantsKey = 'user_plants';
  List<UserPlant> _userPlants = [];

  // Load user plants from local storage
  Future<void> loadUserPlants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final plantsJson = prefs.getString(_userPlantsKey);
      
      if (plantsJson != null) {
        final List<dynamic> plantsList = json.decode(plantsJson);
        _userPlants = plantsList.map((json) => UserPlant.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading user plants: $e');
      _userPlants = [];
    }
  }

  // Save user plants to local storage
  Future<void> _saveUserPlants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final plantsJson = json.encode(_userPlants.map((plant) => plant.toJson()).toList());
      await prefs.setString(_userPlantsKey, plantsJson);
    } catch (e) {
      print('Error saving user plants: $e');
    }
  }

  // Add plant to user collection
  Future<void> addPlant(Plant plant, {
    String? customName,
    String? notes,
    String? group,
    String? imagePath,
  }) async {
    final userPlant = UserPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plant: plant,
      customName: customName,
      notes: notes,
      group: group,
      imagePath: imagePath,
    );

    _userPlants.add(userPlant);
    await _saveUserPlants();
  }

  // Remove plant from collection
  Future<void> removePlant(String userPlantId) async {
    _userPlants.removeWhere((plant) => plant.id == userPlantId);
    await _saveUserPlants();
  }

  // Update plant in collection
  Future<void> updatePlant(String userPlantId, {
    String? customName,
    String? notes,
    String? group,
  }) async {
    final index = _userPlants.indexWhere((plant) => plant.id == userPlantId);
    if (index != -1) {
      final existingPlant = _userPlants[index];
      _userPlants[index] = UserPlant(
        id: existingPlant.id,
        plant: existingPlant.plant,
        customName: customName ?? existingPlant.customName,
        notes: notes ?? existingPlant.notes,
        group: group ?? existingPlant.group,
        dateAdded: existingPlant.dateAdded,
        imagePath: existingPlant.imagePath,
      );
      await _saveUserPlants();
    }
  }

  // Get all user plants
  List<UserPlant> getUserPlants() {
    return List.from(_userPlants);
  }

  // Get plants by group
  List<UserPlant> getPlantsByGroup(String group) {
    return _userPlants.where((plant) => plant.group == group).toList();
  }

  // Get available groups
  List<String> getGroups() {
    return _userPlants
        .where((plant) => plant.group != null)
        .map((plant) => plant.group!)
        .toSet()
        .toList();
  }

  // Search user plants
  List<UserPlant> searchUserPlants(String query) {
    if (query.isEmpty) return _userPlants;
    
    query = query.toLowerCase();
    return _userPlants.where((userPlant) {
      return (userPlant.customName?.toLowerCase().contains(query) ?? false) ||
             userPlant.plant.commonName.toLowerCase().contains(query) ||
             userPlant.plant.scientificName.toLowerCase().contains(query) ||
             (userPlant.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Get plant count
  int getPlantCount() => _userPlants.length;

  // Check if plant exists in collection
  bool hasPlant(String plantId) {
    return _userPlants.any((userPlant) => userPlant.plant.id == plantId);
  }

  // Get plants added this month
  int getPlantsAddedThisMonth() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1); // Start of current month
    return _userPlants.where((plant) {
      return plant.dateAdded.isAfter(thisMonth.subtract(Duration(days: 1))) && 
             plant.dateAdded.isBefore(now.add(Duration(days: 1)));
    }).length;
  }
}