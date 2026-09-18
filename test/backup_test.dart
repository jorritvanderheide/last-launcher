import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/settings/backup.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

Backup _capture(SharedPreferences prefs, {Set<String> include = const {}}) =>
    Backup.capture(prefs, modules: launcherModules, includeModules: include);

Future<void> _restore(
  SharedPreferences prefs,
  Backup backup, {
  Set<String> modules = const {'tasks'},
}) => backup.restore(prefs, modules: launcherModules, restoreModules: modules);

void main() {
  group('capture', () {
    test('includes settings and launcher data, not legacy keys', () async {
      final prefs = await _prefs({
        'locked': true,
        'custom_labels': '{"a|false":"A"}',
        'pinned_apps': '[]',
        'tasks_enabled': true,
      });
      final backup = _capture(prefs);
      expect(backup.entries.keys, containsAll(['locked', 'custom_labels']));
      expect(backup.entries.containsKey('tasks_enabled'), isFalse);
    });

    test('leaves out module data unless asked', () async {
      final prefs = await _prefs({'locked': true, 'tasks': '[]'});
      expect(_capture(prefs).entries.containsKey('tasks'), isFalse);
      final withTasks = _capture(prefs, include: {'tasks'});
      expect(withTasks.entries['tasks'], '[]');
      expect(withTasks.modules, {'tasks'});
    });

    test('finds modules that keep data', () async {
      final empty = await _prefs({'locked': true});
      expect(Backup.modulesWithData(empty, launcherModules), isEmpty);
      final prefs = await _prefs({'tasks': '[]'});
      expect(Backup.modulesWithData(prefs, launcherModules).map((m) => m.id), [
        'tasks',
      ]);
    });
  });

  group('file format', () {
    test('round-trips every stored type', () async {
      final prefs = await _prefs({
        'b': true,
        'i': 3,
        'd': 1.0,
        's': 'text',
        'l': <String>['x', 'y'],
      });
      final decoded = Backup.decode(_capture(prefs).encode());
      expect(decoded.entries['b'], true);
      expect(decoded.entries['i'], 3);
      expect(decoded.entries['d'], isA<double>());
      expect(decoded.entries['s'], 'text');
      expect(decoded.entries['l'], ['x', 'y']);
    });

    test('rejects files that are not backups', () {
      expect(() => Backup.decode('not json'), throwsFormatException);
      expect(() => Backup.decode('{"a": 1}'), throwsFormatException);
      expect(
        () => Backup.decode(
          jsonEncode({
            'format': 'last-launcher-backup',
            'version': 1,
            'modules': [],
            'prefs': {
              'x': {'type': 'int', 'value': 'nope'},
            },
          }),
        ),
        throwsFormatException,
      );
    });

    test('recognises a backup from a newer version', () {
      expect(
        () => Backup.decode(
          jsonEncode({
            'format': 'last-launcher-backup',
            'version': 99,
            'modules': [],
            'prefs': {},
          }),
        ),
        throwsA(isA<BackupTooNewException>()),
      );
    });
  });

  group('restore', () {
    test('replaces settings wholesale', () async {
      final source = await _prefs({'locked': true});
      final backup = Backup.decode(_capture(source).encode());

      final target = await _prefs({'locked': false, 'glow': true});
      await _restore(target, backup);
      expect(target.getBool('locked'), true);
      // Not in the backup, so back to its default.
      expect(target.containsKey('glow'), isFalse);
    });

    test('leaves module data alone when the backup has none', () async {
      final backup = _capture(await _prefs({'locked': true}));
      final target = await _prefs({'tasks': '[{"mine":1}]'});
      await _restore(target, backup);
      expect(target.getString('tasks'), '[{"mine":1}]');
    });

    test('replaces module data only when chosen', () async {
      final backup = _capture(
        await _prefs({'tasks': '[]'}),
        include: {'tasks'},
      );

      final kept = await _prefs({'tasks': '[{"mine":1}]'});
      await _restore(kept, backup, modules: {});
      expect(kept.getString('tasks'), '[{"mine":1}]');

      final replaced = await _prefs({'tasks': '[{"mine":1}]'});
      await _restore(replaced, backup);
      expect(replaced.getString('tasks'), '[]');
    });

    test('settings pick up a restore without a restart', () async {
      final prefs = await _prefs({});
      final settings = SettingsState(prefs);
      expect(settings.locked.value, isFalse);

      final backup = _capture(await _prefs({'locked': true}));
      await _restore(prefs, backup);
      settings.reload();
      expect(settings.locked.value, isTrue);
    });
  });
}
