import 'package:get/get.dart';
import '../controllers/care_controller.dart';

class CareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CareController>(() => CareController());
  }
}