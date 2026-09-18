import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/tasks/screens/task_screen.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _names = ['Alpha', 'Bravo', 'Charlie'];

class _FakeAppChannel extends AppChannel {
  @override
  Future<List<AppInfo>> getInstalledApps() async => [
    for (final name in _names) AppInfo(packageName: name, label: name),
  ];

  @override
  Future<bool> hasWorkProfile() async => false;
}

Widget _app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

/// Presses [text], holds it long enough to lift it, optionally moves it,
/// and lets go.
Future<void> _hold(
  WidgetTester tester,
  String text, {
  Offset move = Offset.zero,
}) async {
  final gesture = await tester.startGesture(tester.getCenter(find.text(text)));
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
  if (move != Offset.zero) {
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(move / 10);
      await tester.pump(const Duration(milliseconds: 16));
    }
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  group('home', () {
    late HomeState home;
    late SettingsState settings;
    var settingsOpened = false;
    var reorders = 0;

    Future<void> pump(WidgetTester tester, {bool locked = false}) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      settings = SettingsState(prefs)..locked.value = locked;
      final apps = AppListState(_FakeAppChannel(), prefs);
      await apps.loadApps();
      home = HomeState(prefs);
      for (final name in _names) {
        await home.addApp(PinnedApp(packageName: name, label: name));
      }
      settingsOpened = false;
      reorders = 0;
      await tester.pumpWidget(
        _app(
          // Stands in for the shell, where a long press on home opens
          // settings.
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPress: () => settingsOpened = true,
            child: HomeScreen(
              homeState: home,
              appListState: apps,
              settingsState: settings,
              moduleDeps: ModuleDeps(
                settingsState: settings,
                appListState: apps,
                taskState: TaskState(prefs),
              ),
              onLaunch: (_, {isWorkApp = false, shortcutId}) {},
              onReorderStart: () => reorders++,
              onReorderEnd: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('holding a row and letting go opens its actions', (
      tester,
    ) async {
      await pump(tester);
      await _hold(tester, 'Alpha');
      expect(find.byType(ActionRow), findsOneWidget);
      expect(settingsOpened, isFalse);
      expect(home.pinnedApps.map((a) => a.label), _names);
    });

    testWidgets('holding a row and dragging moves it', (tester) async {
      await pump(tester);
      await _hold(tester, 'Alpha', move: const Offset(0, 150));
      expect(reorders, 1);
      expect(home.pinnedApps.first.label, isNot('Alpha'));
      expect(find.byType(ActionRow), findsNothing);
      expect(settingsOpened, isFalse);
    });

    testWidgets('a drag that ends where it started opens no actions', (
      tester,
    ) async {
      await pump(tester);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Alpha')),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      for (final step in [const Offset(0, 15), const Offset(0, -15)]) {
        for (var i = 0; i < 10; i++) {
          await gesture.moveBy(step);
          await tester.pump(const Duration(milliseconds: 16));
        }
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(ActionRow), findsNothing);
      expect(home.pinnedApps.map((a) => a.label), _names);
    });

    testWidgets('a locked layout neither moves nor opens rows', (tester) async {
      await pump(tester, locked: true);
      await _hold(tester, 'Alpha', move: const Offset(0, 150));
      expect(reorders, 0);
      expect(find.byType(ActionRow), findsNothing);
      expect(home.pinnedApps.map((a) => a.label), _names);
      expect(settingsOpened, isFalse);
    });
  });

  group('tasks', () {
    late TaskState tasks;

    Future<void> pump(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tasks = TaskState(prefs);
      // Added newest first, so they end up in this order.
      for (final name in _names.reversed) {
        await tasks.addTask(name);
      }
      final settings = SettingsState(prefs)..autoKeyboardTasks.value = false;
      await tester.pumpWidget(
        _app(
          TaskScreen(
            taskState: tasks,
            settingsState: settings,
            isVisible: true,
            onReorderStart: () {},
            onReorderEnd: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('holding a task and letting go opens its actions', (
      tester,
    ) async {
      await pump(tester);
      await _hold(tester, 'Alpha');
      expect(find.byType(ActionRow), findsOneWidget);
      expect(tasks.tasks.map((t) => t.title), _names);
    });

    testWidgets('holding a task and dragging moves it', (tester) async {
      await pump(tester);
      await _hold(tester, 'Alpha', move: const Offset(0, 150));
      expect(tasks.tasks.first.title, isNot('Alpha'));
      expect(tasks.tasks, hasLength(3));
      expect(find.byType(ActionRow), findsNothing);
    });
  });
}
