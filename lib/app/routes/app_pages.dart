import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/splash_view.dart';
import '../controllers/splash_controller.dart';
import '../../features/home/views/home_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/identification/views/camera_view.dart';
import '../../features/identification/bindings/identification_binding.dart';
import '../../features/garden/views/garden_view.dart';
import '../../features/garden/bindings/garden_binding.dart';
import '../../features/care/views/care_view.dart';
import '../../features/care/bindings/care_binding.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/identification/views/plant_result_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.camera,
      page: () => const CameraView(),
      binding: IdentificationBinding(),
    ),
    GetPage(
      name: AppRoutes.garden,
      page: () => const GardenView(),
      binding: GardenBinding(),
    ),
    GetPage(
      name: AppRoutes.care,
      page: () => const CareView(),
      binding: CareBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.plantResult,
      page: () => const PlantResultView(),
      binding: IdentificationBinding(),
    ),
  ];
}