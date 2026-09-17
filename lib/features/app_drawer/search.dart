import 'package:last_launcher/shared/data/fold_for_search.dart';
import 'package:last_launcher/shared/data/models.dart';

final _stripPunct = RegExp(r'[^\p{L}\p{N}]', unicode: true);

// --- Query parsing ---

class SearchQuery {
  final String raw;
  final String searchTerm;
  final bool? requireWorkApp;

  String get needle => foldForSearch(searchTerm);

  SearchQuery._(this.raw, this.searchTerm, this.requireWorkApp);

  factory SearchQuery.parse(String query, {bool allowProfileFilter = true}) {
    if (allowProfileFilter) {
      if (query.startsWith('.')) {
        return SearchQuery._(query, query.substring(1), true);
      } else if (query.startsWith(' ')) {
        return SearchQuery._(query, query.substring(1), false);
      }
    }
    return SearchQuery._(query, query, null);
  }
}

// --- Per-app precomputed context (avoids redundant folding/cleaning) ---

class AppSearchContext {
  final String display;
  final String original;
  final bool checkOriginal;
  final String displayClean;
  final String originalClean;

  AppSearchContext._(
    this.display,
    this.original,
    this.checkOriginal,
    this.displayClean,
    this.originalClean,
  );

  factory AppSearchContext(
    AppInfo app,
    bool matchOriginal,
    String Function(AppInfo) labelOf,
  ) {
    final d = foldForSearch(labelOf(app));
    final o = foldForSearch(app.label);
    return AppSearchContext._(
      d,
      o,
      matchOriginal && d != o,
      d.replaceAll(_stripPunct, ''),
      o.replaceAll(_stripPunct, ''),
    );
  }
}

// --- Matcher interface ---

abstract class SearchMatcher {
  const SearchMatcher();
  bool matches(AppSearchContext ctx, SearchQuery query);
}

class DisplayStartsWith extends SearchMatcher {
  const DisplayStartsWith();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      ctx.display.startsWith(query.needle);
}

class OriginalStartsWith extends SearchMatcher {
  const OriginalStartsWith();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      ctx.checkOriginal && ctx.original.startsWith(query.needle);
}

class DisplayCleanStartsWith extends SearchMatcher {
  const DisplayCleanStartsWith();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      query.needle.length >= 2 && ctx.displayClean.startsWith(query.needle);
}

class OriginalCleanStartsWith extends SearchMatcher {
  const OriginalCleanStartsWith();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      query.needle.length >= 2 &&
      ctx.checkOriginal &&
      ctx.originalClean.startsWith(query.needle);
}

class DisplayContains extends SearchMatcher {
  const DisplayContains();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      ctx.display.contains(query.needle);
}

class DisplayCleanContains extends SearchMatcher {
  const DisplayCleanContains();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      query.needle.length >= 2 && ctx.displayClean.contains(query.needle);
}

class OriginalContains extends SearchMatcher {
  const OriginalContains();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      ctx.checkOriginal && ctx.original.contains(query.needle);
}

class OriginalCleanContains extends SearchMatcher {
  const OriginalCleanContains();
  @override
  bool matches(AppSearchContext ctx, SearchQuery query) =>
      query.needle.length >= 2 &&
      ctx.checkOriginal &&
      ctx.originalClean.contains(query.needle);
}

// --- Priority-ordered matcher pipeline ---

const _matchers = <SearchMatcher>[
  DisplayStartsWith(),
  OriginalStartsWith(),
  DisplayCleanStartsWith(),
  OriginalCleanStartsWith(),
  DisplayContains(),
  DisplayCleanContains(),
  OriginalContains(),
  OriginalCleanContains(),
];

// --- Public entry point ---

List<AppInfo> searchApps(
  Iterable<AppInfo> source,
  String query, {
  bool matchOriginal = true,
  bool allowProfileFilter = true,
  String Function(AppInfo) displayLabel = _defaultDisplayLabel,
}) {
  if (query.isEmpty) return source.toList();

  final parsed = SearchQuery.parse(
    query,
    allowProfileFilter: allowProfileFilter,
  );

  final filtered = !allowProfileFilter || parsed.requireWorkApp == null
      ? source
      : source.where((a) => a.isWorkApp == parsed.requireWorkApp);

  final results = <AppInfo>[];
  for (final app in filtered) {
    final ctx = AppSearchContext(app, matchOriginal, displayLabel);
    if (_matchers.any((m) => m.matches(ctx, parsed))) {
      results.add(app);
    }
  }
  return results;
}

String _defaultDisplayLabel(AppInfo app) => app.label;
