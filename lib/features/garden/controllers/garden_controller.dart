import 'package:get/get.dart';
import '../../../core/data/models/plant.dart';
import '../../../core/data/services/user_plant_service.dart';

class GardenController extends GetxController {
  final UserPlantService _userPlantService = UserPlantService();
  
  final RxList<UserPlant> _userPlants = <UserPlant>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedGroup = 'all'.obs;

  List<UserPlant> get userPlants => _searchQuery.isEmpty && _selectedGroup.value == 'all'
      ? _userPlants
      : _getFilteredPlants();
  
  bool get isLoading => _isLoading.value;
  String? get error => _error.value.isEmpty ? null : _error.value;
  int get plantCount => _userPlants.length;
  String get searchQuery => _searchQuery.value;
  String get selectedGroup => _selectedGroup.value;

  @override
  void onInit() {
    super.onInit();
    loadUserPlants();
  }

  Future<void> loadUserPlants() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      await _userPlantService.loadUserPlants();
      _userPlants.value = _userPlantService.getUserPlants();
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removePlant(String userPlantId) async {
    try {
      await _userPlantService.removePlant(userPlantId);
      _userPlants.removeWhere((plant) => plant.id == userPlantId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove plant: $e');
    }
  }

  Future<void> updatePlant(String userPlantId, {
    String? customName,
    String? notes,
    String? group,
  }) async {
    try {
      await _userPlantService.updatePlant(
        userPlantId,
        customName: customName,
        notes: notes,
        group: group,
      );
      await loadUserPlants(); // Refresh the list
    } catch (e) {
      Get.snackbar('Error', 'Failed to update plant: $e');
    }
  }

  void searchPlants(String query) {
    _searchQuery.value = query;
  }

  void filterByGroup(String group) {
    _selectedGroup.value = group;
  }

  List<UserPlant> _getFilteredPlants() {
    List<UserPlant> filtered = _userPlants;

    // Apply group filter
    if (_selectedGroup.value != 'all') {
      filtered = filtered.where((plant) => plant.group == _selectedGroup.value).toList();
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = _userPlantService.searchUserPlants(_searchQuery.value);
      if (_selectedGroup.value != 'all') {
        filtered = filtered.where((plant) => plant.group == _selectedGroup.value).toList();
      }
    }

    return filtered;
  }

  List<String> getUniqueCategories() {
    return _userPlants
        .map((userPlant) => userPlant.plant.category)
        .toSet()
        .toList();
  }

  List<String> getAvailableGroups() {
    final groups = _userPlantService.getGroups();
    return ['all', ...groups];
  }

  int getPlantsAddedThisMonth() {
    return _userPlantService.getPlantsAddedThisMonth();
  }

  int getPlantsByGroupCount(String group) {
    return _userPlants.where((plant) => plant.group == group).length;
  }

  void clearSearch() {
    _searchQuery.value = '';
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedGroup.value = 'all';
  }
}