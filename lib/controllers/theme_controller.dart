import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_tech/theme/light_dark_theme.dart';

class ThemeController extends GetxController {
  ThemeData theme = MyThemes.lightTheme;
  bool darkTheme = false;

  // set variable to SharedPreferences for short and make more beautiful
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  // store key string to prevent write wrong words
  static const String themePreferenceKey = 'preference';

  // to change theme color
  void toggleTheme() {
    theme = darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme;
    _saveThemeToPreferences();
    update();
  }

  // load preference theme data to remember the last change theme is
  Future<void> loadThemeFromPreferences() async {
    final SharedPreferences prefs = await pref;
    int themeIndex = prefs.getInt(themePreferenceKey) ?? 0;
    darkTheme = themeIndex != 0;
    theme = darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme;
    update();
  }
  // to update theme data when user change theme
  Future<void> _saveThemeToPreferences() async {
    final SharedPreferences prefs = await pref;
    int themeIndex = darkTheme ? 1 : 0;
    await prefs.setInt(themePreferenceKey, themeIndex);
    update();
  }
}