import 'package:get/get.dart';
import '../controllers/garden_controller.dart';

class GardenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GardenController>(() => GardenController());
  }
}