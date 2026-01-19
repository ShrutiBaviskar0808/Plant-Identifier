import 'package:get/get.dart';
import '../../../core/data/models/user_plant.dart';
import '../../../core/data/local/database_service.dart';

class GardenController extends GetxController {
  final RxList<UserPlant> _userPlants = <UserPlant>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();

  List<UserPlant> get userPlants => _userPlants;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  int get plantCount => _userPlants.length;

  @override
  void onInit() {
    super.onInit();
    loadUserPlants();
  }

  Future<void> loadUserPlants() async {
    try {
      _isLoading.value = true;
      _error.value = null;
      
      final plants = await DatabaseService.getUserPlants();
      _userPlants.assignAll(plants);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removePlant(String plantId) async {
    try {
      await DatabaseService.deleteUserPlant(plantId);
      _userPlants.removeWhere((plant) => plant.id == plantId);
      Get.snackbar('Success', 'Plant removed from garden');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove plant: $e');
    }
  }

  List<String> getUniqueCategories() {
    return _userPlants
        .map((plant) => plant.plant.category)
        .toSet()
        .toList();
  }

  int getPlantsAddedThisMonth() {
    final now = DateTime.now();
    return _userPlants
        .where((plant) => 
            plant.dateAdded.year == now.year && 
            plant.dateAdded.month == now.month)
        .length;
  }
}