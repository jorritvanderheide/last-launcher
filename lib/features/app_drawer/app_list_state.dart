import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart'
    as prefixes_lib;
import 'package:last_launcher/features/app_drawer/search.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/fold_for_search.dart';
import 'package:last_launcher/shared/data/hints.dart';
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

  /// Owned by [SettingsState]; pushed in through [applyPrefs] at startup and
  /// whenever one of them changes.
  SearchPrefs _searchPrefs = const SearchPrefs(
    matchOriginal: true,
    includeHidden: false,
    hidePersonalWhenWorkActive: false,
  );
  bool _hasWorkProfile = false;
  final Map<String, String> _customLabels = {};
  final Set<String> _hiddenApps = {};
  Map<String, SubstringHint?> _hints = {};

  List<AppInfo> get allApps => List.unmodifiable(_allApps);
  Set<String> get workPackages => {
    for (final a in _allApps)
      if (a.isWorkApp) a.packageName,
  };
  bool get hasWorkApps => _allApps.any((a) => a.isWorkApp);
  bool get hasWorkProfile => _hasWorkProfile;
  bool get profilePrefixEnabled =>
      _hasWorkProfile && !_searchPrefs.hidePersonalWhenWorkActive;
  String get query => _query;

  List<AppInfo> get hiddenApps =>
      _allApps.where((a) => _hiddenApps.contains(a.key)).toList();

  Map<String, SubstringHint?> get hints => _hints;

  /// [key] is an entry's [AppInfo.key].
  bool isHidden(String key) => _hiddenApps.contains(key);

  void applyPrefs(SearchPrefs prefs) {
    _searchPrefs = prefs;
    _computeHints();
    notifyListeners();
  }

  /// [query] split into its prefix, if any, and the rest, under the
  /// current prefixes.
  SearchQuery parseQuery(String query) => SearchQuery.parse(
    query,
    prefixes: _searchPrefs.prefixes,
    allowProfileFilter: profilePrefixEnabled,
  );

  /// See [mayBecomePrefix].
  bool mayBecomePrefix(String query) =>
      prefixes_lib.mayBecomePrefix(query, _searchPrefs.prefixes);

  List<AppInfo> search(
    String query, {
    bool includeHidden = false,
    bool matchOriginal = true,
  }) {
    var source = includeHidden
        ? _allApps
        : _allApps.where((a) => !_hiddenApps.contains(a.key));
    if (_searchPrefs.hidePersonalWhenWorkActive && hasWorkApps) {
      source = source.where((a) => a.isWorkApp);
    }
    return searchApps(
      source,
      query,
      matchOriginal: matchOriginal,
      displayLabel: displayLabel,
      allowProfileFilter: profilePrefixEnabled,
      prefixes: _searchPrefs.prefixes,
    );
  }

  Future<void> loadApps() async {
    if (_loading) return;
    _loading = true;
    try {
      _allApps = await _channel.getInstalledApps();
      _hasWorkProfile = await _channel.hasWorkProfile();
      _sortApps();
      _pruneOrphanedState();
      _computeHints();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load installed apps: $e');
    } finally {
      _loading = false;
    }
  }

  /// Re-reads labels and hidden apps after storage was replaced wholesale,
  /// e.g. by restoring a backup.
  void reload() {
    _customLabels.clear();
    _hiddenApps.clear();
    _loadCustomLabels();
    _loadHiddenApps();
    _sortApps();
    _computeHints();
    notifyListeners();
  }

  /// Drop entries from [_customLabels] and [_hiddenApps] for packages that are
  /// no longer installed. Saves and notifies if anything changed. Skipped when
  /// [_allApps] is empty (e.g. failed channel call), so a transient failure
  /// can't wipe valid state.
  ///
  /// Work-app entries are never pruned
  /// because the work profile can be paused temporarily, making those apps
  /// disappear from the installed list. Pruning them would lose user state
  /// (hidden status, custom labels) across a pause/unpause cycle.
  void _pruneOrphanedState() {
    if (_allApps.isEmpty) return;
    final installedCompound = {for (final a in _allApps) a.key};
    var changed = false;
    final workPackages = {
      for (final key in _hiddenApps)
        if (AppInfo.isWorkKey(key)) AppInfo.packageOfKey(key),
    };
    final droppedLabels = _customLabels.keys
        .where(
          (k) =>
              !installedCompound.contains(k) &&
              !AppInfo.isWorkKey(k) &&
              !workPackages.contains(AppInfo.packageOfKey(k)),
        )
        .toList();
    if (droppedLabels.isNotEmpty) {
      for (final k in droppedLabels) {
        _customLabels.remove(k);
      }
      changed = true;
    }
    final droppedHidden = _hiddenApps
        .where((p) => !installedCompound.contains(p))
        .where((p) => !AppInfo.isWorkKey(p))
        .toList();
    if (droppedHidden.isNotEmpty) {
      _hiddenApps.removeAll(droppedHidden);
      changed = true;
    }
    if (changed) {
      _saveCustomLabels();
      _saveHiddenApps();
    }
  }

  void filter(String query) {
    _query = query;
    _computeHints();
    notifyListeners();
  }

  void clearFilter() {
    _query = '';
    _computeHints();
    notifyListeners();
  }

  /// An empty [label] goes back to the app's own name.
  void setCustomLabel(String key, String label) {
    if (label.isEmpty) {
      _customLabels.remove(key);
    } else {
      _customLabels[key] = label;
    }
    _sortApps();
    _computeHints();
    notifyListeners();
    _saveCustomLabels();
  }

  void hideApp(String key) {
    _hiddenApps.add(key);
    _computeHints();
    notifyListeners();
    _saveHiddenApps();
  }

  void unhideApp(String key) {
    _hiddenApps.remove(key);
    _computeHints();
    notifyListeners();
    _saveHiddenApps();
  }

  String displayLabelFor(String key, String fallback) =>
      _customLabels[key] ?? fallback;

  /// The name of the app in [package], as shown in the drawer; null when
  /// it isn't installed.
  String? labelForPackage(String package) {
    for (final app in _allApps) {
      if (app.packageName == package && !app.isShortcut) {
        return displayLabel(app);
      }
    }
    return null;
  }

  String displayLabel(AppInfo app) {
    return displayLabelFor(app.key, app.label);
  }

  String displayLabelForSearch(AppInfo app, String query) {
    if (!_searchPrefs.matchOriginal || query.isEmpty) return displayLabel(app);
    final label = displayLabel(app);
    if (label == app.label) return label;

    final foldedQuery = foldForSearch(query);
    final foldedLabel = foldForSearch(label);
    if (foldedLabel.startsWith(foldedQuery)) return label;

    final foldedOriginal = foldForSearch(app.label);
    if (foldedOriginal.startsWith(foldedQuery)) return app.label;

    final alphaNum = RegExp(r'[^\p{L}\p{N}]', unicode: true);
    final cleanQuery = foldedQuery.replaceAll(alphaNum, '');
    final cleanOriginal = cleanQuery.length >= 2
        ? foldedOriginal.replaceAll(alphaNum, '')
        : null;
    if (cleanQuery.length >= 2) {
      if (cleanOriginal!.startsWith(cleanQuery) &&
          !foldedLabel.replaceAll(alphaNum, '').startsWith(cleanQuery)) {
        return app.label;
      }
    }

    // Query matches via original-name contains but not display-name contains.
    if (foldedOriginal.contains(foldedQuery) &&
        !foldedLabel.contains(foldedQuery)) {
      return app.label;
    }
    if (cleanQuery.length >= 2) {
      final cleanLabel = foldedLabel.replaceAll(alphaNum, '');
      if (cleanOriginal!.contains(cleanQuery) &&
          !cleanLabel.contains(cleanQuery)) {
        return app.label;
      }
    }

    return label;
  }

  void _computeHints() {
    Iterable<AppInfo> visible = _searchPrefs.includeHidden
        ? _allApps
        : _allApps.where((a) => !_hiddenApps.contains(a.key));
    if (_searchPrefs.hidePersonalWhenWorkActive && hasWorkApps) {
      visible = visible.where((a) => a.isWorkApp);
    }
    if (_query.isNotEmpty) {
      final searchTerm = parseQuery(_query).searchTerm;
      final matching = search(
        _query,
        includeHidden: _searchPrefs.includeHidden,
        matchOriginal: _searchPrefs.matchOriginal,
      );
      final displayLabels = matching
          .map((a) => displayLabelForSearch(a, _query))
          .toList();
      final originals = _searchPrefs.matchOriginal
          ? matching.map((a) => a.label).toList()
          : displayLabels;
      final hintList = computeHintsWithQuery(
        displayLabels,
        originals,
        searchTerm,
      );
      _hints = {
        for (var i = 0; i < matching.length; i++) matching[i].key: hintList[i],
      };
    } else {
      final visibleList = visible.toList();
      final displayLabels = visibleList.map(displayLabel).toList();
      final originals = _searchPrefs.matchOriginal
          ? visibleList.map((a) => a.label).toList()
          : displayLabels;
      final hintList = computeHints(displayLabels, originals);
      _hints = {
        for (var i = 0; i < visibleList.length; i++)
          visibleList[i].key: hintList[i],
      };
    }
  }

  void _sortApps() {
    _allApps.sort((a, b) {
      final cmp = foldForSearch(
        displayLabel(a),
      ).compareTo(foldForSearch(displayLabel(b)));
      if (cmp != 0) return cmp;
      // Same label: personal before work
      if (a.isWorkApp != b.isWorkApp) return a.isWorkApp ? 1 : -1;
      return 0;
    });
  }

  void _loadCustomLabels() {
    final json = _prefs.getString(_labelsKey);
    if (json == null) return;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      for (final entry in map.entries) {
        final key = entry.key;
        // Legacy: plain packageName → compound key with false
        final compoundKey = key.contains('|') ? key : '$key|false';
        _customLabels[compoundKey] = entry.value as String;
      }
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
      for (final item in list) {
        if (item is! String) continue;
        // Legacy format: packageName only, assume personal profile
        if (!item.contains('|')) {
          _hiddenApps.add('$item|false');
        } else {
          _hiddenApps.add(item);
        }
      }
    } on FormatException {
      debugPrint('Corrupt hidden apps JSON, resetting');
      _prefs.remove(_hiddenKey);
    }
  }

  Future<void> _saveHiddenApps() async {
    await _prefs.setString(_hiddenKey, jsonEncode(_hiddenApps.toList()));
  }
}
