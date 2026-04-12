import 'package:flutter/foundation.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeState extends ChangeNotifier {
  HomeState(this._prefs) {
    _load();
  }

  static const _key = 'pinned_apps';
  // 28px font * 1.2 line height + 2 * 9px padding
  static const _itemHeight = 28.0 * 1.2 + 2 * 9.0;

  final SharedPreferences _prefs;
  List<PinnedApp> _pinnedApps = [];

  List<PinnedApp> get pinnedApps => List.unmodifiable(_pinnedApps);

  void _load() {
    final json = _prefs.getString(_key);
    if (json == null) return;
    try {
      _pinnedApps = PinnedApp.decodeList(json);
    } on FormatException {
      debugPrint('Corrupt pinned apps JSON, resetting');
      _prefs.remove(_key);
    }
  }

  Future<void> _save() async {
    await _prefs.setString(_key, PinnedApp.encodeList(_pinnedApps));
  }

  bool isPinned(String packageName) {
    return _pinnedApps.any((a) => a.packageName == packageName);
  }

  int _maxPinnedApps = 10;

  int get maxPinnedApps => _maxPinnedApps;
  bool get isFull => _pinnedApps.length >= _maxPinnedApps;

  void updateMaxApps(double availableHeight) {
    _maxPinnedApps = (availableHeight / _itemHeight).floor().clamp(1, 10);
  }

  Future<void> addApp(PinnedApp app) async {
    if (isPinned(app.packageName) || isFull) return;
    _pinnedApps.add(app);
    notifyListeners();
    await _save();
  }

  Future<void> removeApp(String packageName) async {
    _pinnedApps.removeWhere((a) => a.packageName == packageName);
    notifyListeners();
    await _save();
  }

  Future<void> reorderApps(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex == newIndex) return;

    final app = _pinnedApps.removeAt(oldIndex);
    _pinnedApps.insert(newIndex, app);

    notifyListeners();
    await _save();
  }
}
