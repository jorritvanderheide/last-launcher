import 'package:flutter/foundation.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeState extends ChangeNotifier {
  HomeState(this._prefs) {
    _load();
  }

  static const _key = 'pinned_apps';

  final SharedPreferences _prefs;
  List<PinnedApp> _pinnedApps = [];

  List<PinnedApp> get pinnedApps => List.unmodifiable(_pinnedApps);

  void _load() {
    final json = _prefs.getString(_key);
    if (json != null) {
      _pinnedApps = PinnedApp.decodeList(json);
      _pinnedApps.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
  }

  Future<void> _save() async {
    await _prefs.setString(_key, PinnedApp.encodeList(_pinnedApps));
  }

  bool isPinned(String packageName) {
    return _pinnedApps.any((a) => a.packageName == packageName);
  }

  Future<void> addApp(PinnedApp app) async {
    if (isPinned(app.packageName)) return;
    final nextOrder = _pinnedApps.isEmpty ? 0 : _pinnedApps.last.sortOrder + 1;
    _pinnedApps.add(app.copyWith(sortOrder: nextOrder));
    notifyListeners();
    await _save();
  }

  Future<void> removeApp(String packageName) async {
    _pinnedApps.removeWhere((a) => a.packageName == packageName);
    notifyListeners();
    await _save();
  }

  Future<void> renameApp(String packageName, String customLabel) async {
    final index = _pinnedApps.indexWhere((a) => a.packageName == packageName);
    if (index == -1) return;
    _pinnedApps[index] = _pinnedApps[index].copyWith(
      customLabel: customLabel.isEmpty ? null : customLabel,
    );
    notifyListeners();
    await _save();
  }
}
