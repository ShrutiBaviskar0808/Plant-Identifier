import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxBool _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    // Default to system theme
    _isDarkMode.value = Get.isPlatformDarkMode;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
  }

  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(themeMode);
  }
}