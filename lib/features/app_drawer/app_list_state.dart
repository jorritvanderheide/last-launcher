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
  List<AppInfo> _filteredApps = const [];
  String _query = '';
  bool _loading = false;
  final Map<String, String> _customLabels = {};
  final Set<String> _hiddenApps = {};

  List<AppInfo> get filteredApps => _filteredApps;
  String get query => _query;
  bool get hasSingleResult => _filteredApps.length == 1;

  List<AppInfo> get hiddenApps =>
      _allApps.where((a) => _hiddenApps.contains(a.packageName)).toList();

  bool isHidden(String packageName) => _hiddenApps.contains(packageName);

  Future<void> loadApps() async {
    if (_loading) return;
    _loading = true;
    try {
      _allApps = await _channel.getInstalledApps();
      _sortApps();
      _applyFilter();
    } finally {
      _loading = false;
    }
  }

  void filter(String query) {
    _query = query;
    _applyFilter();
  }

  void clearFilter() {
    _query = '';
    _applyFilter();
  }

  void setCustomLabel(String packageName, String label) {
    if (label.isEmpty) {
      _customLabels.remove(packageName);
    } else {
      _customLabels[packageName] = label;
    }
    _sortApps();
    _applyFilter();
    _saveCustomLabels();
  }

  void hideApp(String packageName) {
    _hiddenApps.add(packageName);
    _applyFilter();
    _saveHiddenApps();
  }

  void unhideApp(String packageName) {
    _hiddenApps.remove(packageName);
    _applyFilter();
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

  void _applyFilter() {
    final visible = _allApps.where((a) => !_hiddenApps.contains(a.packageName));
    if (_query.isEmpty) {
      _filteredApps = visible.toList();
    } else {
      final lower = _query.toLowerCase();
      _filteredApps = visible.where((app) {
        return displayLabel(app).toLowerCase().contains(lower) ||
            app.label.toLowerCase().contains(lower);
      }).toList();
    }
    notifyListeners();
  }
}
