import 'package:get/get.dart';
import '../controllers/network_controller.dart';
import '../../features/identification/controllers/identification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.lazyPut<IdentificationController>(() => IdentificationController());
  }
}