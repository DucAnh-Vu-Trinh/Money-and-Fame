import 'package:flutter/material.dart';
import 'package:my_test_app/Functions/Preferences/my_preferences.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late TargetPlatform _platform;
  late MyThemePreferences _preferences;

  bool get isDark => _isDark;
  TargetPlatform get platform => _platform;

  ModelTheme() {
    _isDark = false;
    TargetPlatform _platform = TargetPlatform.iOS;
    _preferences = MyThemePreferences();
    getPreferences();
  }

//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }

  set platform(TargetPlatform value) {
    _platform = value;
    notifyListeners();
  }
}