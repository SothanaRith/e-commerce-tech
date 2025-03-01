import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_tech/theme/light_dark_theme.dart';

class ThemeController extends GetxController {
  late ThemeData theme;
  late bool darkTheme;
  late SharedPreferences prefs; // Store instance instead of Future

  static const String themePreferenceKey = 'preference';

  @override
  void onInit() async {
    super.onInit();
    await _loadThemeFromPreferences();
  }

  // Toggle between dark and light theme
  void toggleTheme() {
    darkTheme = !darkTheme; // Fix: Update darkTheme boolean
    theme = darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme;
    _saveThemeToPreferences();
    update();
  }

  // Load the saved theme preference
  Future<void> _loadThemeFromPreferences() async {
    prefs = await SharedPreferences.getInstance();
    darkTheme = (prefs.getInt(themePreferenceKey) ?? 0) == 1;
    theme = darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme;
    update();
  }

  // Save the theme preference
  Future<void> _saveThemeToPreferences() async {
    await prefs.setInt(themePreferenceKey, darkTheme ? 1 : 0);
    update();
  }

  Color get primaryColor => theme.primaryColor;
}
