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

  bool isPinned(String packageName, {bool isWorkApp = false}) {
    return _pinnedApps.any(
      (a) => a.packageName == packageName && a.isWorkApp == isWorkApp,
    );
  }

  int _maxPinnedApps = 10;
  double? _lastAvailableHeight;
  double? _lastItemHeight;

  int get maxPinnedApps => _maxPinnedApps;
  bool get isFull => _pinnedApps.length >= _maxPinnedApps;

  /// How many apps fit on home: [itemHeight] depends on the text size.
  void updateMaxApps(double availableHeight, {required double itemHeight}) {
    if (_lastAvailableHeight == availableHeight &&
        _lastItemHeight == itemHeight) {
      return;
    }
    _lastAvailableHeight = availableHeight;
    _lastItemHeight = itemHeight;
    _maxPinnedApps = (availableHeight / itemHeight).floor().clamp(1, 10);
  }

  Future<void> addApp(PinnedApp app) async {
    if (isPinned(app.packageName, isWorkApp: app.isWorkApp) || isFull) return;
    _pinnedApps.add(app);
    notifyListeners();
    await _save();
  }

  Future<void> removeApp(String packageName, {bool isWorkApp = false}) async {
    _pinnedApps.removeWhere(
      (a) => a.packageName == packageName && a.isWorkApp == isWorkApp,
    );
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

  Future<void> pruneMissing(Set<String> installed) async {
    if (installed.isEmpty) return;
    final before = _pinnedApps.length;
    _pinnedApps.removeWhere((a) => !installed.contains(a.packageName));
    if (_pinnedApps.length == before) return;
    notifyListeners();
    await _save();
  }
}
