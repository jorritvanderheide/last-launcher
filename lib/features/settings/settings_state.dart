import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SettingsState(this._prefs) {
    _load();
  }

  /// Incremented when settings that require rebuilding the [MaterialApp]
  /// subtree change (theme mode, status bar visibility). Exists separately
  /// from [notifyListeners] so routine setting changes (e.g. keyboard toggle)
  /// don't rebuild the entire app.
  final themeNotifier = ValueNotifier<int>(0);

  static const _themeKey = 'theme_mode';
  static const _autoKeyboardKey = 'auto_keyboard';
  static const _autoKeyboardTasksKey = 'auto_keyboard_tasks';
  static const _searchOnlyKey = 'search_only';
  static const _autoLaunchKey = 'auto_launch';
  static const _tasksEnabledKey = 'tasks_enabled';
  static const _showHintsKey = 'show_hints';
  static const _removeOnCompleteKey = 'remove_on_complete';
  static const _hideStatusBarKey = 'hide_status_bar';
  static const _hidePinnedFromDrawerKey = 'hide_pinned_from_drawer';
  static const _includeHiddenInSearchKey = 'include_hidden_in_search';
  static const _lockedKey = 'locked';
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  bool _extraTheme = false;
  bool _autoKeyboard = true;
  bool _autoKeyboardTasks = true;
  bool _searchOnly = false;
  bool _autoLaunch = true;
  bool _tasksEnabled = false;
  bool _showHints = true;
  bool _removeOnComplete = false;
  bool _hideStatusBar = false;
  bool _hidePinnedFromDrawer = true;
  bool _includeHiddenInSearch = false;
  bool _locked = false;
  ThemeMode get themeMode => _extraTheme ? ThemeMode.dark : _themeMode;
  bool get isExtra => _extraTheme;
  bool get autoKeyboard => _autoKeyboard;
  bool get autoKeyboardTasks => _autoKeyboardTasks;
  bool get searchOnly => _searchOnly;
  bool get autoLaunch => _autoLaunch;
  bool get tasksEnabled => _tasksEnabled;
  bool get showHints => _showHints;
  bool get removeOnComplete => _removeOnComplete;
  bool get hideStatusBar => _hideStatusBar;
  bool get hidePinnedFromDrawer => _hidePinnedFromDrawer;
  bool get includeHiddenInSearch => !_searchOnly && _includeHiddenInSearch;
  bool get locked => _locked;

  void _load() {
    final value = _prefs.getString(_themeKey);
    _extraTheme = value == 'extra';
    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _autoKeyboard = _prefs.getBool(_autoKeyboardKey) ?? true;
    _autoKeyboardTasks = _prefs.getBool(_autoKeyboardTasksKey) ?? true;
    _searchOnly = _prefs.getBool(_searchOnlyKey) ?? false;
    _autoLaunch = _prefs.getBool(_autoLaunchKey) ?? true;
    _tasksEnabled = _prefs.getBool(_tasksEnabledKey) ?? false;
    _showHints = _prefs.getBool(_showHintsKey) ?? true;
    _removeOnComplete = _prefs.getBool(_removeOnCompleteKey) ?? false;
    _hideStatusBar = _prefs.getBool(_hideStatusBarKey) ?? false;
    _hidePinnedFromDrawer = _prefs.getBool(_hidePinnedFromDrawerKey) ?? true;
    _includeHiddenInSearch = _prefs.getBool(_includeHiddenInSearchKey) ?? false;
    _locked = _prefs.getBool(_lockedKey) ?? false;
  }

  Future<void> setTheme(String value) async {
    _extraTheme = value == 'extra';
    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'extra' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
    themeNotifier.value++;
    await _prefs.setString(_themeKey, value);
  }

  String get themeValue {
    if (_extraTheme) return 'extra';
    return switch (_themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  Future<void> setAutoKeyboard(bool enabled) async {
    _autoKeyboard = enabled;
    notifyListeners();
    await _prefs.setBool(_autoKeyboardKey, enabled);
  }

  Future<void> setAutoKeyboardTasks(bool enabled) async {
    _autoKeyboardTasks = enabled;
    notifyListeners();
    await _prefs.setBool(_autoKeyboardTasksKey, enabled);
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

  Future<void> setShowHints(bool enabled) async {
    _showHints = enabled;
    notifyListeners();
    await _prefs.setBool(_showHintsKey, enabled);
  }

  Future<void> setRemoveOnComplete(bool enabled) async {
    _removeOnComplete = enabled;
    notifyListeners();
    await _prefs.setBool(_removeOnCompleteKey, enabled);
  }

  Future<void> setHideStatusBar(bool enabled) async {
    _hideStatusBar = enabled;
    notifyListeners();
    themeNotifier.value++;
    await _prefs.setBool(_hideStatusBarKey, enabled);
  }

  Future<void> setHidePinnedFromDrawer(bool enabled) async {
    _hidePinnedFromDrawer = enabled;
    notifyListeners();
    await _prefs.setBool(_hidePinnedFromDrawerKey, enabled);
  }

  Future<void> setIncludeHiddenInSearch(bool enabled) async {
    _includeHiddenInSearch = enabled;
    notifyListeners();
    await _prefs.setBool(_includeHiddenInSearchKey, enabled);
  }

  Future<void> setLocked(bool enabled) async {
    _locked = enabled;
    notifyListeners();
    await _prefs.setBool(_lockedKey, enabled);
  }
}
