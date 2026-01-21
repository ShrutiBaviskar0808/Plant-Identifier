import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../garden/controllers/garden_controller.dart';
import '../../identification/controllers/identification_controller.dart';
import '../../care/controllers/care_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../app/controllers/theme_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GardenController>(() => GardenController());
    Get.lazyPut<IdentificationController>(() => IdentificationController());
    Get.lazyPut<CareController>(() => CareController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<ThemeController>(() => ThemeController());
  }
}