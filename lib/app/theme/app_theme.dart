import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF8BC34A);
  static const Color accentColor = Color(0xFF2E7D32);

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 64, fontWeight: FontWeight.w300, fontFamily: 'Poppins'),
      displayMedium: TextStyle(fontSize: 52, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      displaySmall: TextStyle(fontSize: 44, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      headlineMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      headlineSmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      titleSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins', // Set default font family
      textTheme: _textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.black87),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: _textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: _textTheme.labelMedium,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins', // Set default font family
      textTheme: _textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: _textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: _textTheme.labelMedium,
      ),
    );
  }
}