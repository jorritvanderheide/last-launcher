import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  _FakeAppChannel(this.apps, {bool hasWorkProfile = false})
    : _hasWorkProfile = hasWorkProfile;

  List<AppInfo> apps;
  final bool _hasWorkProfile;

  @override
  Future<List<AppInfo>> getInstalledApps() async => apps;

  @override
  Future<bool> hasWorkProfile() async => _hasWorkProfile;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppListState._pruneOrphanedState', () {
    test('drops orphaned custom labels and hidden apps', () async {
      SharedPreferences.setMockInitialValues({
        'custom_labels': jsonEncode({
          'com.kept': 'Kept Label',
          'com.gone': 'Gone Label',
        }),
        'hidden_apps': jsonEncode(['com.kept', 'com.gone']),
      });
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'com.kept', label: 'Kept'),
      ]);
      final state = AppListState(channel, prefs);

      await state.loadApps();

      expect(
        state.displayLabelFor(AppInfo.keyFor('com.kept'), 'fallback'),
        'Kept Label',
      );
      expect(
        state.displayLabelFor(AppInfo.keyFor('com.gone'), 'fallback'),
        'fallback',
      );
      expect(state.isHidden(AppInfo.keyFor('com.kept')), true);
      expect(state.isHidden(AppInfo.keyFor('com.gone')), false);
    });

    test('preserves state when channel returns empty list', () async {
      SharedPreferences.setMockInitialValues({
        'custom_labels': jsonEncode({'com.kept': 'Kept Label'}),
        'hidden_apps': jsonEncode(['com.kept']),
      });
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([]);
      final state = AppListState(channel, prefs);

      await state.loadApps();

      expect(state.allApps, isEmpty);
      expect(
        state.displayLabelFor(AppInfo.keyFor('com.kept'), 'fallback'),
        'Kept Label',
      );
      expect(state.isHidden(AppInfo.keyFor('com.kept')), true);
    });

    test('empty-list load does not persist a wipe', () async {
      SharedPreferences.setMockInitialValues({
        'custom_labels': jsonEncode({'com.kept': 'Kept Label'}),
        'hidden_apps': jsonEncode(['com.kept']),
      });
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([]);
      final state = AppListState(channel, prefs);

      await state.loadApps();

      final restored = AppListState(channel, prefs);
      expect(
        restored.displayLabelFor(AppInfo.keyFor('com.kept'), 'fallback'),
        'Kept Label',
      );
      expect(restored.isHidden(AppInfo.keyFor('com.kept')), true);
    });

    test(
      'preserves work-app hidden entries when work profile is paused',
      () async {
        SharedPreferences.setMockInitialValues({
          'hidden_apps': jsonEncode(['com.work|true', 'com.gone|false']),
        });
        final prefs = await SharedPreferences.getInstance();
        // Only personal apps returned — simulates paused work profile
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'com.other', label: 'Other'),
        ]);
        final state = AppListState(channel, prefs);

        await state.loadApps();

        expect(
          state.isHidden(AppInfo.keyFor('com.work', isWorkApp: true)),
          true,
        );
        expect(state.isHidden(AppInfo.keyFor('com.gone')), false);
      },
    );

    test(
      'preserves custom labels for work apps when work profile is paused',
      () async {
        SharedPreferences.setMockInitialValues({
          'custom_labels': jsonEncode({
            'com.workapp': 'Work Label',
            'com.personal': 'Personal Label',
          }),
          'hidden_apps': jsonEncode(['com.workapp|true']),
        });
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'com.personal', label: 'Personal'),
        ]);
        final state = AppListState(channel, prefs);

        await state.loadApps();

        expect(
          state.displayLabelFor(AppInfo.keyFor('com.workapp'), 'fallback'),
          'Work Label',
        );
        expect(
          state.displayLabelFor(AppInfo.keyFor('com.personal'), 'fallback'),
          'Personal Label',
        );
      },
    );

    test('prunes personal hidden entries but keeps work entries', () async {
      SharedPreferences.setMockInitialValues({
        'hidden_apps': jsonEncode(['com.work|true', 'com.gone|false']),
      });
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'com.work', label: 'Work', isWorkApp: true),
      ]);
      final state = AppListState(channel, prefs);

      await state.loadApps();

      expect(state.isHidden(AppInfo.keyFor('com.work', isWorkApp: true)), true);
      expect(state.isHidden(AppInfo.keyFor('com.gone')), false);
    });
  });

  group('AppListState hints exclude hidden apps', () {
    test('hiding a duplicate-name app unblocks the hint', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'cam.a', label: 'Camera'),
        const AppInfo(packageName: 'cam.b', label: 'Camera'),
        const AppInfo(packageName: 'other', label: 'Other'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // Both visible — identical labels, no hint (collision).
      expect(state.hints['cam.a|false'], isNull);

      // Hide one Camera app.
      state.hideApp(AppInfo.keyFor('cam.b'));
      expect(state.hints['cam.a|false'], isNotNull);

      // Unhide it — hint is lost again.
      state.unhideApp(AppInfo.keyFor('cam.b'));
      expect(state.hints['cam.a|false'], isNull);
    });
  });

  group('AppListState hints recompute on rename', () {
    test(
      'hint is still accessible after rename (compound key is stable)',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'app.a', label: 'Alpha'),
          const AppInfo(packageName: 'app.b', label: 'Beta'),
          const AppInfo(packageName: 'app.c', label: 'Gamma'),
        ]);
        final state = AppListState(channel, prefs);
        await state.loadApps();

        state.setCustomLabel(AppInfo.keyFor('app.b'), 'Bee');

        // Compound key is stable — doesn't change when the display label changes.
        expect(state.hints.containsKey('app.b|false'), true);
        expect(state.hints['app.b|false'], isNotNull);
      },
    );

    test(
      'renaming an app with no original-name collision updates its hint',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'app.a', label: 'Alpha'),
          const AppInfo(packageName: 'app.b', label: 'Beta'),
          const AppInfo(packageName: 'app.c', label: 'Gamma'),
        ]);
        final state = AppListState(channel, prefs);
        await state.loadApps();

        expect(state.hints['app.b|false'], isNotNull);
        expect(state.hints['app.b|false']!.start, 0);
        expect(state.hints['app.b|false']!.length, 1);

        state.setCustomLabel(AppInfo.keyFor('app.b'), 'Zeta');

        expect(state.hints['app.b|false'], isNotNull);
        expect(state.hints['app.b|false']!.start, 0);
        expect(state.hints['app.b|false']!.length, 1);
      },
    );
  });

  group('AppListState.search special chars', () {
    test('finds app when query omits punctuation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'org.fdroid', label: 'F-Droid'),
        const AppInfo(packageName: 'com.other', label: 'Other'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('fdr');
      expect(result.length, 1);
      expect(result.first.packageName, 'org.fdroid');
    });

    test('finds app when query includes punctuation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'org.fdroid', label: 'F-Droid'),
        const AppInfo(packageName: 'com.other', label: 'Other'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('f-d');
      expect(result.length, 1);
      expect(result.first.packageName, 'org.fdroid');
    });

    test('finds app with dots when query omits them', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'c.c', label: 'C.C'),
        const AppInfo(packageName: 'd.d', label: 'D.D'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('cc');
      expect(result.length, 1);
      expect(result.first.packageName, 'c.c');
    });

    test(
      'search finds clean-startsWith before display-contains match',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'a.a', label: 'A-A'),
          const AppInfo(packageName: 'a.b', label: 'baa'),
        ]);
        final state = AppListState(channel, prefs);
        await state.loadApps();

        final result = state.search('aa');
        expect(result.length, 2);
        expect(result.first.packageName, 'a.a');
        expect(result.last.packageName, 'a.b');
      },
    );

    test('finds app when query skips spaces', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Albert Heijn'),
        const AppInfo(packageName: 'a.b', label: 'Other'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('albertheijn');
      expect(result.length, 1);
      expect(result.first.packageName, 'a.a');
    });

    test('query with space does not match app without that space', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Albert Heijn'),
        const AppInfo(packageName: 'a.b', label: 'Lithium'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // "t h" (with space) matches "Albert Heijn" because the name has
      // "t h" in it. It should NOT match "Lithium" which has no space.
      final result = state.search('t h');
      expect(result.length, 1);
      expect(result.first.packageName, 'a.a');
    });
  });

  group('AppListState.search profile prefix', () {
    test('dot prefix finds only work apps', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Alpha', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Alpha', isWorkApp: true),
        const AppInfo(packageName: 'a.c', label: 'Beta', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('.alpha');
      expect(result.length, 1);
      expect(result.first.packageName, 'a.b');
    });

    test('space prefix finds only personal apps', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Alpha', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Alpha', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search(' alpha');
      expect(result.length, 1);
      expect(result.first.packageName, 'a.a');
    });

    test('dot prefix with search term filters work apps', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'A', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'A', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('.a');
      expect(result.length, 1);
      expect(result.first.isWorkApp, true);
    });

    test('dot prefix alone shows all work apps', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Alpha', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Alpha', isWorkApp: true),
        const AppInfo(packageName: 'a.c', label: 'Beta', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('.');
      expect(result.length, 2);
      expect(result.every((a) => a.isWorkApp), true);
    });

    test('space prefix alone shows all personal apps', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Alpha', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Alpha', isWorkApp: true),
        const AppInfo(packageName: 'a.c', label: 'Beta', isWorkApp: false),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search(' ');
      expect(result.length, 2);
      expect(result.every((a) => !a.isWorkApp), true);
    });

    test('no prefix returns apps from both profiles', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Alpha', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Alpha', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      final result = state.search('alpha');
      expect(result.length, 2);
    });
  });

  group('AppListState._computeHints strips profile prefix', () {
    test('dot prefix passes search term without dot to hints', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(
          packageName: 'a.a',
          label: 'Proton Drive',
          isWorkApp: false,
        ),
        const AppInfo(
          packageName: 'a.b',
          label: 'Proton Mail',
          isWorkApp: true,
        ),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // Hints before query: no prefix matching (default computeHints).
      final baseline = state.hints['a.a|false'];
      expect(baseline, isNotNull);

      // Filter with dot prefix. _computeHints strips the '.' and passes
      // 'proton' to computeHintsWithQuery, so hints should be query-aware
      // prefix completions. Only work apps match the dot prefix.
      state.filter('.proton');
      // "Proton Mail" (work) is the single match, gets prefix completion.
      final hint = state.hints['a.b|true']!;
      final ch = 'Proton Mail'.substring(hint.start, hint.start + hint.length);
      expect(ch, 'Proton M');
      // "Proton Drive" (personal) is not in hints with dot prefix.
      expect(state.hints.containsKey('a.a|false'), false);
    });

    test('space prefix passes search term without space to hints', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(
          packageName: 'a.a',
          label: 'Proton Drive',
          isWorkApp: false,
        ),
        const AppInfo(
          packageName: 'a.b',
          label: 'Proton Mail',
          isWorkApp: true,
        ),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      state.filter(' proton');
      final hint = state.hints['a.a|false']!;
      final ch = 'Proton Drive'.substring(hint.start, hint.start + hint.length);
      expect(ch, 'Proton D');
    });

    test('dot prefix alone gives default hints (empty search term)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Foo', isWorkApp: false),
        const AppInfo(packageName: 'a.b', label: 'Bar', isWorkApp: true),
      ], hasWorkProfile: true);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      state.filter('.');
      // searchTerm is '' → computeHintsWithQuery falls back to computeHints.
      // Only work apps are in the matching set.
      expect(state.hints.containsKey('a.a|false'), false);
      expect(state.hints['a.b|true']!.start, 0);
      expect(state.hints['a.b|true']!.length, 1);
    });
  });

  group('AppListState search without work profile', () {
    test('dot prefix is literal without work profile', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'x.a', label: 'Alpha'),
        const AppInfo(packageName: 'x.b', label: 'Beta'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // No work profile: '.' is not a profile prefix, so '.alpha' is a
      // literal search with no app name matching it.
      final result = state.search('.alpha');
      expect(result.length, 0);
    });

    test('space prefix is literal without work profile', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'x.a', label: 'Alpha'),
        const AppInfo(packageName: 'x.b', label: 'Beta'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // No work profile: space is not a profile prefix, so it's a literal
      // search character. No app starts with ' alpha'.
      final result = state.search(' alpha');
      expect(result.length, 0);
    });

    test('dot prefix alone finds nothing without work profile', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'x.a', label: 'Alpha'),
        const AppInfo(packageName: 'x.b', label: 'Beta'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      // No work profile: dot is not a profile prefix, so '.' is a literal
      // character. No app is named '.'.
      final result = state.search('.');
      expect(result.length, 0);
    });
  });

  group('AppListState.search hidden apps', () {
    test('hidden apps are included when includeHidden is true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'vis.a', label: 'System Info'),
        const AppInfo(packageName: 'hid.b', label: 'Item List'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      state.hideApp(AppInfo.keyFor('hid.b'));

      var result = state.search('tem');
      expect(result.length, 1);
      expect(result.first.packageName, 'vis.a');

      result = state.search('tem', includeHidden: true);
      expect(result.length, 2);
    });

    test(
      'includeHidden returns hidden and visible apps for matching queries',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'vis.c', label: 'Coating'),
          const AppInfo(packageName: 'hid.a', label: 'Toast'),
          const AppInfo(packageName: 'vis.b', label: 'Road App'),
        ]);
        final state = AppListState(channel, prefs);
        await state.loadApps();

        state.hideApp(AppInfo.keyFor('hid.a'));
        state.setCustomLabel(AppInfo.keyFor('vis.b'), 'Xyz');

        final result = state.search('oa', includeHidden: true);
        expect(result.length, 3);
      },
    );
  });

  group('AppListState.search original name contains', () {
    test('original name contains returns renamed app', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final channel = _FakeAppChannel([
        const AppInfo(packageName: 'a.a', label: 'Complex Utilities'),
      ]);
      final state = AppListState(channel, prefs);
      await state.loadApps();

      state.setCustomLabel(AppInfo.keyFor('a.a'), 'Tools');

      // "Tools" doesn't match "util", but original "Complex Utilities"
      // contains "util", so the renamed app is still found.
      final result = state.search('util');
      expect(result.length, 1);
      expect(result.first.packageName, 'a.a');
    });
  });

  group('AppListState.search hidden apps', () {
    test(
      'hidden apps matching via display starts are included when includeHidden is true',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final channel = _FakeAppChannel([
          const AppInfo(packageName: 'vis.b', label: 'Alpha'),
          const AppInfo(packageName: 'hid.a', label: 'Alpine'),
        ]);
        final state = AppListState(channel, prefs);
        await state.loadApps();

        state.hideApp(AppInfo.keyFor('hid.a'));

        final result = state.search('alp', includeHidden: true);
        expect(result.length, 2);
      },
    );
  });
}
