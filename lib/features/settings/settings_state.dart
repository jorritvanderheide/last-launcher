import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SettingsState(this._prefs) {
    _load();
  }

  /// Incremented when theme-related settings change.
  final themeNotifier = ValueNotifier<int>(0);

  static const _themeKey = 'theme_mode';
  static const _amoledKey = 'amoled';
  static const _autoKeyboardKey = 'auto_keyboard';
  static const _searchOnlyKey = 'search_only';
  static const _autoLaunchKey = 'auto_launch';
  static const _tasksEnabledKey = 'tasks_enabled';
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  bool _amoled = false;
  bool _autoKeyboard = true;
  bool _searchOnly = false;
  bool _autoLaunch = false;
  bool _tasksEnabled = true;
  ThemeMode get themeMode => _themeMode;
  bool get amoled => _amoled;
  bool get autoKeyboard => _autoKeyboard;
  bool get searchOnly => _searchOnly;
  bool get autoLaunch => _autoLaunch;
  bool get tasksEnabled => _tasksEnabled;

  void _load() {
    final value = _prefs.getString(_themeKey);
    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _amoled = _prefs.getBool(_amoledKey) ?? false;
    _autoKeyboard = _prefs.getBool(_autoKeyboardKey) ?? true;
    _searchOnly = _prefs.getBool(_searchOnlyKey) ?? false;
    _autoLaunch = _prefs.getBool(_autoLaunchKey) ?? false;
    _tasksEnabled = _prefs.getBool(_tasksEnabledKey) ?? true;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    themeNotifier.value++;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_themeKey, value);
  }

  Future<void> setAmoled(bool enabled) async {
    _amoled = enabled;
    notifyListeners();
    themeNotifier.value++;
    await _prefs.setBool(_amoledKey, enabled);
  }

  Future<void> setAutoKeyboard(bool enabled) async {
    _autoKeyboard = enabled;
    notifyListeners();
    await _prefs.setBool(_autoKeyboardKey, enabled);
  }

  Future<void> setSearchOnly(bool enabled) async {
    _searchOnly = enabled;
    notifyListeners();
    await _prefs.setBool(_searchOnlyKey, enabled);
  }

  Future<void> setAutoLaunch(bool enabled) async {
    _autoLaunch = enabled;
    notifyListeners();
    await _prefs.setBool(_autoLaunchKey, enabled);
  }

  Future<void> setTasksEnabled(bool enabled) async {
    _tasksEnabled = enabled;
    notifyListeners();
    await _prefs.setBool(_tasksEnabledKey, enabled);
  }
}
