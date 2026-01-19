import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../garden/controllers/garden_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GardenController>(() => GardenController());
  }
}