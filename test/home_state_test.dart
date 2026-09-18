import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One label row at the default text size.
const _itemHeight = 28 * 1.2 + 2 * 9.0;

void main() {
  late HomeState state;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    state = HomeState(prefs);
  });

  group('HomeState', () {
    test('starts empty', () {
      expect(state.pinnedApps, isEmpty);
      expect(state.isFull, false);
    });

    test('adds app', () async {
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );
      expect(state.pinnedApps.length, 1);
      expect(state.pinnedApps.first.label, 'Test');
    });

    test('does not add duplicate', () async {
      const app = PinnedApp(packageName: 'com.test', label: 'Test');
      await state.addApp(app);
      await state.addApp(app);
      expect(state.pinnedApps.length, 1);
    });

    test('isPinned returns correct value', () async {
      expect(state.isPinned(AppInfo.keyFor('com.test')), false);
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );
      expect(state.isPinned(AppInfo.keyFor('com.test')), true);
    });

    test('removes app', () async {
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );
      await state.removeApp(AppInfo.keyFor('com.test'));
      expect(state.pinnedApps, isEmpty);
    });

    test('isFull respects max', () async {
      state.updateMaxApps(100, itemHeight: _itemHeight);
      final max = state.maxPinnedApps;
      for (var i = 0; i < max; i++) {
        await state.addApp(
          PinnedApp(packageName: 'com.test$i', label: 'App $i'),
        );
      }
      expect(state.isFull, true);
      await state.addApp(
        const PinnedApp(packageName: 'com.extra', label: 'Extra'),
      );
      expect(state.pinnedApps.length, max);
    });

    test('reorders apps', () async {
      await state.addApp(const PinnedApp(packageName: 'a', label: 'A'));
      await state.addApp(const PinnedApp(packageName: 'b', label: 'B'));
      await state.addApp(const PinnedApp(packageName: 'c', label: 'C'));

      await state.reorderApps(0, 2);
      expect(state.pinnedApps.map((a) => a.label).toList(), ['B', 'A', 'C']);
    });

    test('reorder same index does nothing', () async {
      await state.addApp(const PinnedApp(packageName: 'a', label: 'A'));
      await state.addApp(const PinnedApp(packageName: 'b', label: 'B'));
      await state.reorderApps(0, 0);
      expect(state.pinnedApps.map((a) => a.label).toList(), ['A', 'B']);
    });

    test('fewer apps fit with larger text', () {
      state.updateMaxApps(400, itemHeight: _itemHeight);
      final medium = state.maxPinnedApps;
      state.updateMaxApps(400, itemHeight: 34 * 1.2 + 2 * 9.0);
      expect(state.maxPinnedApps, lessThan(medium));
    });

    test('updateMaxApps clamps to range', () {
      state.updateMaxApps(10, itemHeight: _itemHeight);
      expect(state.maxPinnedApps, 1);
      state.updateMaxApps(10000, itemHeight: _itemHeight);
      expect(state.maxPinnedApps, 10);
    });

    test('persists and restores', () async {
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );

      final prefs = await SharedPreferences.getInstance();
      final restored = HomeState(prefs);
      expect(restored.pinnedApps.length, 1);
      expect(restored.pinnedApps.first.packageName, 'com.test');
    });

    Future<void> pin(PinnedApp app) => state.addApp(app);

    AppInfo app(String package, {bool work = false, String? shortcut}) =>
        AppInfo(
          packageName: package,
          label: package,
          isWorkApp: work,
          shortcutId: shortcut,
        );

    test('pruneMissing drops uninstalled pinned apps', () async {
      await pin(const PinnedApp(packageName: 'com.kept', label: 'Kept'));
      await pin(const PinnedApp(packageName: 'com.gone', label: 'Gone'));
      await state.pruneMissing([app('com.kept')], hasWorkProfile: false);
      expect(state.pinnedApps.single.packageName, 'com.kept');
    });

    test('pruneMissing with an empty list is a no-op', () async {
      await pin(const PinnedApp(packageName: 'com.test', label: 'Test'));
      await state.pruneMissing([], hasWorkProfile: false);
      expect(state.pinnedApps, hasLength(1));
    });

    test('keeps work pins while the work profile is paused', () async {
      await pin(
        const PinnedApp(packageName: 'com.work', label: 'W', isWorkApp: true),
      );
      // Paused: the profile exists, but none of its apps are listed.
      await state.pruneMissing([app('com.personal')], hasWorkProfile: true);
      expect(state.pinnedApps, hasLength(1));
    });

    test('drops work pins once the app or the profile is gone', () async {
      await pin(
        const PinnedApp(packageName: 'com.work', label: 'W', isWorkApp: true),
      );
      // Profile running, app uninstalled from it.
      await state.pruneMissing([
        app('com.personal'),
        app('com.other', work: true),
      ], hasWorkProfile: true);
      expect(state.pinnedApps, isEmpty);

      await pin(
        const PinnedApp(packageName: 'com.work', label: 'W', isWorkApp: true),
      );
      // Profile removed altogether.
      await state.pruneMissing([app('com.personal')], hasWorkProfile: false);
      expect(state.pinnedApps, isEmpty);
    });

    test('keeps old pins of work apps, which lack the work flag', () async {
      await pin(const PinnedApp(packageName: 'com.work', label: 'W'));
      await state.pruneMissing([
        app('com.work', work: true),
      ], hasWorkProfile: true);
      expect(state.pinnedApps, hasLength(1));
    });

    test(
      'drops a pinned shortcut that is gone, with its app still here',
      () async {
        await pin(
          const PinnedApp(
            packageName: 'org.browser',
            label: 'News',
            shortcutId: 'web-news',
          ),
        );
        await state.pruneMissing([app('org.browser')], hasWorkProfile: false);
        expect(state.pinnedApps, isEmpty);
      },
    );
  });
}
