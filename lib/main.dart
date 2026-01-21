import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/bindings/initial_binding.dart';
import 'core/ai/services/ai_model_manager.dart';
import 'core/data/local/database_service.dart';
import 'core/utils/edge_to_edge_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable edge-to-edge
  EdgeToEdgeHelper.enableEdgeToEdge();
  
  // Initialize AI Models (with error handling)
  try {
    await AIModelManager.initialize();
  } catch (e) {
    print('AI Model initialization failed: $e');
  }
  
  // Initialize Database
  try {
    await DatabaseService.initialize();
  } catch (e) {
    print('Database initialization failed: $e');
  }
  
  runApp(const PlantIdentifierApp());
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