import 'dart:convert';

/// An entry in the app drawer: an app, or a shortcut pinned to the launcher
/// (an installed web app, a website, a chat...), which opens through the app
/// in [packageName].
class AppInfo {
  const AppInfo({
    required this.packageName,
    required this.label,
    this.isWorkApp = false,
    this.shortcutId,
  });

  final String packageName;
  final String label;
  final bool isWorkApp;

  /// Set for pinned shortcuts; null for apps.
  final String? shortcutId;

  bool get isShortcut => shortcutId != null;

  /// Identifies this entry across state maps: the personal and work copies of
  /// a package are distinct entries everywhere, and so is each shortcut.
  String get key =>
      keyFor(packageName, isWorkApp: isWorkApp, shortcutId: shortcutId);

  /// The one definition of the key format, which is what hidden apps, custom
  /// labels and pins are stored under. Changing it orphans users' data.
  /// Shortcuts extend their app's key, so app keys never changed shape.
  static String keyFor(
    String packageName, {
    bool isWorkApp = false,
    String? shortcutId,
  }) => shortcutId == null
      ? '$packageName|$isWorkApp'
      : '$packageName|$isWorkApp|$shortcutId';

  /// Whether a stored key belongs to a work-profile entry.
  static bool isWorkKey(String key) {
    final parts = key.split('|');
    return parts.length > 1 && parts[1] == 'true';
  }

  static String packageOfKey(String key) => key.split('|').first;
}

class PinnedApp {
  const PinnedApp({
    required this.packageName,
    required this.label,
    this.isWorkApp = false,
    this.shortcutId,
  });

  factory PinnedApp.fromJson(Map<String, dynamic> json) =>
      tryFromJson(json) ?? (throw const FormatException('Not a pinned app'));

  /// Null for anything that isn't a pinned app with a package, such as one
  /// in a shape another version stored. Other values that aren't what they
  /// should be read as unset.
  static PinnedApp? tryFromJson(Object? json) {
    if (json is! Map) return null;
    final packageName = json['packageName'];
    if (packageName is! String) return null;
    final label = json['label'];
    final shortcutId = json['shortcutId'];
    return PinnedApp(
      packageName: packageName,
      label: label is String ? label : packageName,
      isWorkApp: json['isWorkApp'] == true,
      shortcutId: shortcutId is String ? shortcutId : null,
    );
  }

  final String packageName;
  final String label;
  final bool isWorkApp;

  /// Set when the pinned entry is a shortcut; see [AppInfo.shortcutId].
  final String? shortcutId;

  /// Same format as [AppInfo.key], so the two can be compared directly.
  String get key =>
      AppInfo.keyFor(packageName, isWorkApp: isWorkApp, shortcutId: shortcutId);

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'label': label,
      if (isWorkApp) 'isWorkApp': true,
      if (shortcutId != null) 'shortcutId': shortcutId,
    };
  }

  /// The pinned apps in [json], leaving out what isn't one. Throws
  /// [FormatException] when it isn't a list at all.
  static List<PinnedApp> decodeList(String json) {
    final list = jsonDecode(json);
    if (list is! List) throw const FormatException('Not a list');
    return [for (final entry in list) ?PinnedApp.tryFromJson(entry)];
  }

  static String encodeList(List<PinnedApp> apps) {
    return jsonEncode(apps.map((a) => a.toJson()).toList());
  }
}
