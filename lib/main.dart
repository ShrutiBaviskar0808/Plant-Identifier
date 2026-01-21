import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/bindings/initial_binding.dart';
import 'core/data/services/plant_database_service.dart';
import 'core/data/services/user_plant_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services for MVP
  await _initializeServices();
  
  runApp(const PlantIdentifierApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize plant database
    final plantService = PlantDatabaseService();
    plantService.initializeSampleData();
    
    // Initialize user plant service
    final userPlantService = UserPlantService();
    await userPlantService.loadUserPlants();
    
    print('Services initialized successfully');
  } catch (e) {
    print('Service initialization failed: $e');
  }
}

class PlantIdentifierApp extends StatelessWidget {
  const PlantIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plant Identifier',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}