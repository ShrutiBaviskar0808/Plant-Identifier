import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/identification/screens/camera_screen.dart';
import '../features/garden/screens/my_garden_screen.dart';
import '../features/care/screens/care_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String camera = '/camera';
  static const String garden = '/garden';
  static const String care = '/care';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      camera: (context) => const CameraScreen(),
      garden: (context) => const MyGardenScreen(),
      care: (context) => const CareScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}