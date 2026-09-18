import 'dart:convert';

import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A backup names a newer format version than this build can read.
class BackupTooNewException implements Exception {
  const BackupTooNewException();
}

/// Everything the launcher stores, as a file the user can keep and restore.
///
/// A backup holds every stored key except [_neverBackedUp], so a setting added
/// later is included without anyone having to remember it. Data a module
/// keeps for itself (tasks, say) belongs to that module: it can be left out
/// of a backup, and left alone by a restore.
class Backup {
  Backup._(this.entries, this.modules);

  static const _format = 'last-launcher-backup';
  static const _version = 1;

  /// Keys that only matter to the install they're on: migrated-away
  /// leftovers from older versions.
  static const _neverBackedUp = {'tasks_enabled'};

  /// Stored key to value: a bool, int, double, String or `List<String>`.
  final Map<String, Object> entries;

  /// Ids of the modules whose data this backup includes.
  final Set<String> modules;

  /// The modules that keep data of their own, whether or not they're on a
  /// side of home right now.
  static List<LauncherModule> modulesWithData(
    SharedPreferences prefs,
    Iterable<LauncherModule> modules,
  ) => [
    for (final module in modules)
      if (module.storageKeys.any(prefs.containsKey)) module,
  ];

  factory Backup.capture(
    SharedPreferences prefs, {
    required Iterable<LauncherModule> modules,
    required Set<String> includeModules,
  }) {
    final entries = <String, Object>{};
    for (final key in prefs.getKeys()) {
      if (_neverBackedUp.contains(key)) continue;
      final owner = _ownerOf(key, modules);
      if (owner != null && !includeModules.contains(owner)) continue;
      final value = prefs.get(key);
      if (value == null) continue;
      // String lists can come back typed as List<Object?>.
      entries[key] = value is List ? value.cast<String>().toList() : value;
    }
    return Backup._(entries, includeModules);
  }

  /// Throws [FormatException] for anything that isn't a backup, and
  /// [BackupTooNewException] for one written by a newer version.
  factory Backup.decode(String text) {
    final Object? json;
    try {
      json = jsonDecode(text);
    } on FormatException {
      throw const FormatException('Not JSON');
    }
    if (json is! Map<String, Object?> || json['format'] != _format) {
      throw const FormatException('Not a Last Launcher backup');
    }
    final version = json['version'];
    if (version is! int) throw const FormatException('No version');
    if (version > _version) throw const BackupTooNewException();

    final modules = json['modules'];
    final prefs = json['prefs'];
    if (modules is! List ||
        modules.any((id) => id is! String) ||
        prefs is! Map<String, Object?>) {
      throw const FormatException('Missing sections');
    }
    return Backup._({
      for (final MapEntry(:key, :value) in prefs.entries)
        key: _decodeValue(value),
    }, modules.cast<String>().toSet());
  }

  String encode() => const JsonEncoder.withIndent('  ').convert({
    'format': _format,
    'version': _version,
    'modules': modules.toList()..sort(),
    'prefs': {
      for (final MapEntry(:key, :value) in entries.entries)
        key: _encodeValue(value),
    },
  });

  /// Replaces what's stored with this backup. The launcher's own settings
  /// and data are replaced as a whole: anything not in the backup goes back
  /// to its default. A module's data is only touched when it is in the
  /// backup and in [restoreModules].
  Future<void> restore(
    SharedPreferences prefs, {
    required Iterable<LauncherModule> modules,
    required Set<String> restoreModules,
  }) async {
    final replacing = restoreModules.intersection(this.modules);
    bool replaces(String key) {
      if (_neverBackedUp.contains(key)) return false;
      final owner = _ownerOf(key, modules);
      return owner == null || replacing.contains(owner);
    }

    for (final key in prefs.getKeys().toList()) {
      if (replaces(key)) await prefs.remove(key);
    }
    for (final MapEntry(:key, :value) in entries.entries) {
      if (!replaces(key)) continue;
      switch (value) {
        case final bool v:
          await prefs.setBool(key, v);
        case final int v:
          await prefs.setInt(key, v);
        case final double v:
          await prefs.setDouble(key, v);
        case final String v:
          await prefs.setString(key, v);
        case final List<String> v:
          await prefs.setStringList(key, v);
      }
    }
  }

  static String? _ownerOf(String key, Iterable<LauncherModule> modules) {
    for (final module in modules) {
      if (module.storageKeys.contains(key)) return module.id;
    }
    return null;
  }

  // Values carry their type: JSON alone can't tell 1 from 1.0, and every
  // SharedPreferences getter insists on its own type.
  static Map<String, Object> _encodeValue(Object value) => switch (value) {
    bool() => {'type': 'bool', 'value': value},
    int() => {'type': 'int', 'value': value},
    double() => {'type': 'double', 'value': value},
    String() => {'type': 'string', 'value': value},
    List<String>() => {'type': 'strings', 'value': value},
    _ => throw ArgumentError.value(value, 'value', 'Unsupported type'),
  };

  static Object _decodeValue(Object? json) {
    if (json is! Map<String, Object?>) {
      throw const FormatException('Bad entry');
    }
    final value = json['value'];
    return switch ((json['type'], value)) {
      ('bool', final bool v) => v,
      ('int', final int v) => v,
      ('double', final num v) => v.toDouble(),
      ('string', final String v) => v,
      ('strings', final List<Object?> v) when v.every((e) => e is String) =>
        v.cast<String>().toList(),
      _ => throw const FormatException('Bad entry'),
    };
  }
}
