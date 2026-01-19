import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/network_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}