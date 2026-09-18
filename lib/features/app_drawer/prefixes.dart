import 'dart:convert';

/// What typing a prefix does.
sealed class PrefixAction {
  const PrefixAction();

  Map<String, Object?> toJson();

  /// Null for anything unrecognised, e.g. an action type added by a newer
  /// version: that prefix is skipped rather than breaking the rest.
  static PrefixAction? fromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    return switch (json) {
      {'type': 'filter', 'work': final bool work} => FilterApps(work: work),
      {'type': 'link', 'template': final String template} => OpenLink(
        template,
        openWith: json['openWith'] as String?,
      ),
      {'type': 'appSearch', 'package': final String package} => SearchInApp(
        package,
      ),
      _ => null,
    };
  }
}

/// Narrows the app search to work or personal apps. Unlike the others, the
/// rest of the query still searches apps.
class FilterApps extends PrefixAction {
  const FilterApps({required this.work});

  final bool work;

  @override
  Map<String, Object?> toJson() => {'type': 'filter', 'work': work};
}

/// Opens a link built from [template], with the query in place of
/// [placeholder]: a web search, a map (geo:), a store (market:)...
class OpenLink extends PrefixAction {
  const OpenLink(this.template, {this.openWith});

  static const placeholder = '%s';

  final String template;

  /// Package to open it in; null lets Android choose, as for any link.
  final String? openWith;

  String linkFor(String query) =>
      template.replaceAll(placeholder, Uri.encodeComponent(query.trim()));

  @override
  Map<String, Object?> toJson() => {
    'type': 'link',
    'template': template,
    'openWith': ?openWith,
  };
}

/// Hands the query to an app's own search (Android's ACTION_SEARCH).
class SearchInApp extends PrefixAction {
  const SearchInApp(this.package);

  final String package;

  @override
  Map<String, Object?> toJson() => {'type': 'appSearch', 'package': package};
}

/// A trigger typed at the start of a search, and what it does. An empty
/// [name] means the default description of [action] is shown instead.
class SearchPrefix {
  const SearchPrefix({
    required this.trigger,
    required this.action,
    this.name = '',
    this.enabled = true,
  });

  final String trigger;
  final PrefixAction action;
  final String name;
  final bool enabled;

  SearchPrefix copyWith({
    String? trigger,
    PrefixAction? action,
    String? name,
    bool? enabled,
  }) => SearchPrefix(
    trigger: trigger ?? this.trigger,
    action: action ?? this.action,
    name: name ?? this.name,
    enabled: enabled ?? this.enabled,
  );

  Map<String, Object?> toJson() => {
    'trigger': trigger,
    'name': name,
    'enabled': enabled,
    'action': action.toJson(),
  };

  static SearchPrefix? fromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    final trigger = json['trigger'];
    final action = PrefixAction.fromJson(json['action']);
    if (trigger is! String || trigger.isEmpty || action == null) return null;
    return SearchPrefix(
      trigger: trigger,
      action: action,
      name: json['name'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  static String encodeList(List<SearchPrefix> prefixes) =>
      jsonEncode([for (final prefix in prefixes) prefix.toJson()]);

  /// Null when [json] isn't a list at all, so the caller can fall back to
  /// the defaults; unreadable entries inside a list are skipped.
  static List<SearchPrefix>? decodeList(String? json) {
    if (json == null) return null;
    final Object? list;
    try {
      list = jsonDecode(json);
    } on FormatException {
      return null;
    }
    if (list is! List) return null;
    return [for (final entry in list) ?SearchPrefix.fromJson(entry)];
  }
}

/// The prefixes every install starts with: "." for work apps and a space
/// for personal ones, which only apply while there's a work profile.
const defaultPrefixes = [
  SearchPrefix(trigger: '.', action: FilterApps(work: true)),
  SearchPrefix(trigger: ' ', action: FilterApps(work: false)),
];

/// Whether [query] is the start of a longer enabled trigger: "g" on the
/// way to "g ". Auto-launch waits then, or it would launch the only app
/// starting with "g" before the prefix is finished.
bool mayBecomePrefix(String query, List<SearchPrefix> prefixes) {
  if (query.isEmpty) return false;
  final lower = query.toLowerCase();
  return prefixes.any(
    (prefix) =>
        prefix.enabled &&
        prefix.trigger.length > query.length &&
        prefix.trigger.toLowerCase().startsWith(lower),
  );
}

/// A prefix found at the start of a query, with the text after it.
class PrefixMatch {
  const PrefixMatch(this.prefix, this.argument);

  final SearchPrefix prefix;
  final String argument;
}

/// The enabled prefix [query] starts with, if any. The longest trigger
/// wins, so "g" and "gm" can coexist, and case is ignored because the
/// keyboard capitalises the first letter. Profile filters only count when
/// [allowProfileFilter] is set, i.e. there's a work profile to filter by.
PrefixMatch? matchPrefix(
  String query,
  List<SearchPrefix> prefixes, {
  required bool allowProfileFilter,
}) {
  SearchPrefix? best;
  for (final prefix in prefixes) {
    if (!prefix.enabled) continue;
    if (prefix.action is FilterApps && !allowProfileFilter) continue;
    final length = prefix.trigger.length;
    // Compared on the query's own leading characters, so the argument is
    // cut at the right place even where lowercasing changes a length.
    if (query.length < length ||
        query.substring(0, length).toLowerCase() !=
            prefix.trigger.toLowerCase()) {
      continue;
    }
    if (best == null || prefix.trigger.length > best.trigger.length) {
      best = prefix;
    }
  }
  if (best == null) return null;
  return PrefixMatch(best, query.substring(best.trigger.length));
}
