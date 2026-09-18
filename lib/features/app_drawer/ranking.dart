import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/shared/data/fold_for_search.dart';
import 'package:last_launcher/shared/data/hints.dart';
import 'package:last_launcher/shared/data/models.dart';

/// The app drawer's visible app list for one query, ranked for display.
///
/// Built once per query (or state) change and shared by the list, the
/// auto-launch check and the submit action, so all three always agree on which
/// app a query means.
class DrawerResults {
  const DrawerResults({
    required this.apps,
    required this.query,
    required this.searchTerm,
    this.action,
  });

  static const empty = DrawerResults(apps: [], query: '', searchTerm: '');

  /// Set when the query starts with an action prefix. The drawer then shows
  /// that action alone, in place of apps.
  final PrefixMatch? action;

  /// Apps to show, best match first.
  final List<AppInfo> apps;

  /// The raw query, profile prefix included.
  final String query;

  /// The query with the profile prefix stripped.
  final String searchTerm;

  bool get isEmpty => apps.isEmpty;

  bool get isSearching => query.isNotEmpty;

  /// The app that submitting the field should launch.
  AppInfo? get best => apps.isEmpty ? null : apps.first;

  /// The single remaining match, or null when the query is empty or still
  /// ambiguous. This is what auto-launch fires on.
  AppInfo? get onlyMatch => isSearching && apps.length == 1 ? apps.first : null;
}

/// Orders [apps] for display.
///
/// In order: when [sortByHint] is set, apps carrying a quick-launch hint come
/// before apps without one and shorter hints come first; then prefix matches
/// come before substring matches (substring rank is skipped under
/// [sortByHint], where the hint already expresses it); then alphabetically.
///
/// [searchLabel] supplies the label a match was found in, which is not always
/// the label being displayed, and [hints] is keyed by [AppInfo.key].
List<AppInfo> rankApps({
  required List<AppInfo> apps,
  required String searchTerm,
  required Map<String, SubstringHint?> hints,
  required bool sortByHint,
  required String Function(AppInfo) searchLabel,
}) {
  if (apps.isEmpty) return apps;
  final needle = searchTerm.isNotEmpty ? foldForSearch(searchTerm) : '';
  final entries = apps.map((app) {
    final folded = foldForSearch(searchLabel(app));
    var startsWith = false;
    var contains = false;
    if (searchTerm.isNotEmpty) {
      startsWith = folded.startsWith(needle);
      contains = !startsWith && folded.contains(needle);
    }
    return _RankEntry(
      app: app,
      folded: folded,
      startsWith: startsWith,
      contains: contains,
      hint: hints[app.key],
    );
  }).toList();

  entries.sort((a, b) {
    if (sortByHint) {
      if (a.hint == null && b.hint != null) return 1;
      if (a.hint != null && b.hint == null) return -1;
      if (a.hint != null && a.hint!.length != b.hint!.length) {
        return a.hint!.length.compareTo(b.hint!.length);
      }
    }
    if (searchTerm.isNotEmpty) {
      if (a.startsWith != b.startsWith) return a.startsWith ? -1 : 1;
      if (!sortByHint && a.contains != b.contains) return a.contains ? -1 : 1;
    }
    return a.folded.compareTo(b.folded);
  });

  return entries.map((e) => e.app).toList();
}

class _RankEntry {
  _RankEntry({
    required this.app,
    required this.folded,
    required this.startsWith,
    required this.contains,
    required this.hint,
  });

  final AppInfo app;
  final String folded;
  final bool startsWith;
  final bool contains;
  final SubstringHint? hint;
}
