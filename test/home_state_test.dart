import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      expect(state.isPinned('com.test'), false);
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );
      expect(state.isPinned('com.test'), true);
    });

    test('removes app', () async {
      await state.addApp(
        const PinnedApp(packageName: 'com.test', label: 'Test'),
      );
      await state.removeApp('com.test');
      expect(state.pinnedApps, isEmpty);
    });

    test('isFull respects max', () async {
      state.updateMaxApps(100);
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

    test('updateMaxApps clamps to range', () {
      state.updateMaxApps(10);
      expect(state.maxPinnedApps, 1);
      state.updateMaxApps(10000);
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
  });
}
