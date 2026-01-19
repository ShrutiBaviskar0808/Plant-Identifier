import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/data/models/user_plant.dart';
import '../../../core/data/models/plant.dart';
import '../../../core/data/local/database_service.dart';

class GardenProvider extends ChangeNotifier {
  List<UserPlant> _userPlants = [];
  bool _isLoading = false;
  String? _error;

  List<UserPlant> get userPlants => _userPlants;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get plantCount => _userPlants.length;

  GardenProvider() {
    loadUserPlants();
  }

  Future<void> loadUserPlants() async {
    _setLoading(true);
    _error = null;

    try {
      _userPlants = await DatabaseService.getUserPlants();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load plants: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPlant(Plant plant, {String? customName, String? location}) async {
    try {
      final userPlant = UserPlant(
        id: const Uuid().v4(),
        plant: plant,
        customName: customName,
        notes: [],
        dateAdded: DateTime.now(),
        location: location,
        photos: [],
      );

      await DatabaseService.insertUserPlant(userPlant);
      _userPlants.add(userPlant);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add plant: $e';
      notifyListeners();
    }
  }

  Future<void> removePlant(String plantId) async {
    try {
      await DatabaseService.deleteUserPlant(plantId);
      _userPlants.removeWhere((plant) => plant.id == plantId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to remove plant: $e';
      notifyListeners();
    }
  }

  Future<void> updatePlant(UserPlant updatedPlant) async {
    try {
      await DatabaseService.insertUserPlant(updatedPlant);
      final index = _userPlants.indexWhere((plant) => plant.id == updatedPlant.id);
      if (index != -1) {
        _userPlants[index] = updatedPlant;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update plant: $e';
      notifyListeners();
    }
  }

  Future<void> addNote(String plantId, String note) async {
    final plantIndex = _userPlants.indexWhere((plant) => plant.id == plantId);
    if (plantIndex != -1) {
      final plant = _userPlants[plantIndex];
      final updatedNotes = List<String>.from(plant.notes)..add(note);
      final updatedPlant = plant.copyWith(notes: updatedNotes);
      await updatePlant(updatedPlant);
    }
  }

  Future<void> addPhoto(String plantId, String photoPath) async {
    final plantIndex = _userPlants.indexWhere((plant) => plant.id == plantId);
    if (plantIndex != -1) {
      final plant = _userPlants[plantIndex];
      final updatedPhotos = List<String>.from(plant.photos)..add(photoPath);
      final updatedPlant = plant.copyWith(photos: updatedPhotos);
      await updatePlant(updatedPlant);
    }
  }

  List<UserPlant> getPlantsByCategory(String category) {
    return _userPlants.where((plant) => plant.plant.category == category).toList();
  }

  List<UserPlant> searchPlants(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _userPlants.where((plant) {
      return plant.plant.commonName.toLowerCase().contains(lowercaseQuery) ||
             plant.plant.scientificName.toLowerCase().contains(lowercaseQuery) ||
             (plant.customName?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}