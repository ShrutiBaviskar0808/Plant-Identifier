import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/providers/theme_provider.dart';
import 'routes.dart';
import 'theme.dart';

class PlantIdentifierApp extends StatelessWidget {
  const PlantIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Plant Identifier',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}