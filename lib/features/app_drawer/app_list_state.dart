import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppListState extends ChangeNotifier {
  AppListState(this._channel, this._prefs) {
    _loadCustomLabels();
    _loadHiddenApps();
  }

  static const _labelsKey = 'custom_labels';
  static const _hiddenKey = 'hidden_apps';

  final AppChannel _channel;
  final SharedPreferences _prefs;
  List<AppInfo> _allApps = [];
  String _query = '';
  bool _loading = false;
  final Map<String, String> _customLabels = {};
  final Set<String> _hiddenApps = {};

  List<AppInfo> get allApps => List.unmodifiable(_allApps);
  String get query => _query;

  List<AppInfo> get hiddenApps =>
      _allApps.where((a) => _hiddenApps.contains(a.packageName)).toList();

  bool isHidden(String packageName) => _hiddenApps.contains(packageName);

  List<AppInfo> search(
    String query, {
    bool includeHidden = false,
    bool matchOriginal = true,
  }) {
    final source = includeHidden
        ? _allApps
        : _allApps.where((a) => !_hiddenApps.contains(a.packageName));
    if (query.isEmpty) return source.toList();
    final lower = query.toLowerCase();
    return source.where((app) {
      if (displayLabel(app).toLowerCase().contains(lower)) return true;
      if (matchOriginal && app.label.toLowerCase().contains(lower)) return true;
      return false;
    }).toList();
  }

  Future<void> loadApps() async {
    if (_loading) return;
    _loading = true;
    try {
      _allApps = await _channel.getInstalledApps();
      _sortApps();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load installed apps: $e');
    } finally {
      _loading = false;
    }
  }

  void filter(String query) {
    _query = query;
    notifyListeners();
  }

  void clearFilter() {
    _query = '';
    notifyListeners();
  }

  void setCustomLabel(String packageName, String label) {
    if (label.isEmpty) {
      _customLabels.remove(packageName);
    } else {
      _customLabels[packageName] = label;
    }
    _sortApps();
    notifyListeners();
    _saveCustomLabels();
  }

  void hideApp(String packageName) {
    _hiddenApps.add(packageName);
    notifyListeners();
    _saveHiddenApps();
  }

  void unhideApp(String packageName) {
    _hiddenApps.remove(packageName);
    notifyListeners();
    _saveHiddenApps();
  }

  String displayLabelFor(String packageName, String fallback) {
    return _customLabels[packageName] ?? fallback;
  }

  String displayLabel(AppInfo app) {
    return displayLabelFor(app.packageName, app.label);
  }

  void _sortApps() {
    _allApps.sort(
      (a, b) => displayLabel(
        a,
      ).toLowerCase().compareTo(displayLabel(b).toLowerCase()),
    );
  }

  void _loadCustomLabels() {
    final json = _prefs.getString(_labelsKey);
    if (json == null) return;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      _customLabels.addAll(map.cast<String, String>());
    } on FormatException {
      debugPrint('Corrupt custom labels JSON, resetting');
      _prefs.remove(_labelsKey);
    }
  }

  Future<void> _saveCustomLabels() async {
    await _prefs.setString(_labelsKey, jsonEncode(_customLabels));
  }

  void _loadHiddenApps() {
    final json = _prefs.getString(_hiddenKey);
    if (json == null) return;
    try {
      final list = jsonDecode(json) as List<dynamic>;
      _hiddenApps.addAll(list.cast<String>());
    } on FormatException {
      debugPrint('Corrupt hidden apps JSON, resetting');
      _prefs.remove(_hiddenKey);
    }
  }

  Future<void> _saveHiddenApps() async {
    await _prefs.setString(_hiddenKey, jsonEncode(_hiddenApps.toList()));
  }
}
