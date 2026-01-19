import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  void changeTabIndex(int index) {
    _currentIndex.value = index;
  }

  void navigateToCamera() {
    Get.toNamed('/camera');
  }

  void navigateToGarden() {
    Get.toNamed('/garden');
  }
}