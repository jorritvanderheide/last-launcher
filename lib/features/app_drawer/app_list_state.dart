import 'package:flutter/foundation.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppListState extends ChangeNotifier {
  AppListState(this._channel);

  final AppChannel _channel;
  List<AppInfo> _allApps = [];
  List<AppInfo> _filteredApps = [];
  String _query = '';
  final Map<String, String> _customLabels = {};

  List<AppInfo> get filteredApps => _filteredApps;
  String get query => _query;
  bool get hasSingleResult => _filteredApps.length == 1;

  Future<void> loadApps() async {
    _allApps = await _channel.getInstalledApps();
    _applyFilter();
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
    notifyListeners();
  }

  String displayLabel(AppInfo app) {
    return _customLabels[app.packageName] ?? app.label;
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filteredApps = List.of(_allApps);
    } else {
      final lower = _query.toLowerCase();
      _filteredApps = _allApps.where((app) {
        final label = displayLabel(app).toLowerCase();
        return label.contains(lower);
      }).toList();
    }
    notifyListeners();
  }
}
