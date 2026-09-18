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

  /// Re-reads pinned apps after storage was replaced wholesale, e.g. by
  /// restoring a backup.
  void reload() {
    _pinnedApps = [];
    _load();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs.setString(_key, PinnedApp.encodeList(_pinnedApps));
  }

  /// [key] is an entry's [AppInfo.key] or [PinnedApp.key].
  bool isPinned(String key) => _pinnedApps.any((a) => a.key == key);

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
    if (isPinned(app.key) || isFull) return;
    _pinnedApps.add(app);
    notifyListeners();
    await _save();
  }

  Future<void> removeApp(String key) async {
    _pinnedApps.removeWhere((a) => a.key == key);
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

  /// Unpins what is no longer installed, given everything that is. An empty
  /// list (a failed read) prunes nothing.
  ///
  /// A paused work profile still exists but lists no apps, so its pins are
  /// kept for when it's back; they're pruned once their app is really gone,
  /// or the profile is.
  Future<void> pruneMissing(
    List<AppInfo> installed, {
    required bool hasWorkProfile,
  }) async {
    if (installed.isEmpty) return;
    final keys = {for (final app in installed) app.key};
    final packages = {for (final app in installed) app.packageName};
    final workPaused = hasWorkProfile && !installed.any((a) => a.isWorkApp);
    bool keep(PinnedApp pin) {
      if (pin.isWorkApp) return workPaused || keys.contains(pin.key);
      // Shortcuts share their app's package, so only their own key counts.
      if (pin.shortcutId != null) return keys.contains(pin.key);
      // Pins from before work profiles were supported carry no work flag,
      // so the package installed in any profile counts.
      return packages.contains(pin.packageName);
    }

    final before = _pinnedApps.length;
    _pinnedApps.retainWhere(keep);
    if (_pinnedApps.length == before) return;
    notifyListeners();
    await _save();
  }
}
