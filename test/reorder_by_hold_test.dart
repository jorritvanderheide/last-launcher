import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/tasks/screens/task_screen.dart';
import 'package:last_launcher/features/modules/tasks/subtasks.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/l10n/app_localizations_en.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

final l10n = AppLocalizationsEn();

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

    Future<void> pump(
      WidgetTester tester, {
      bool locked = false,
      TextAlign align = TextAlign.left,
    }) async {
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
          AppearanceScope(
            labelFontSize: 28,
            labelAlign: align,
            accentAvailable: false,
            terminalPrompt: false,
            animate: false,
            child: GestureDetector(
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

    testWidgets('a lifted row keeps home'
        's alignment', (tester) async {
      await pump(tester, align: TextAlign.right);
      final screen = tester.getTopRight(find.byType(Scaffold).first).dx;
      final before = tester.getTopRight(find.text('Alpha')).dx;
      expect(screen - before, lessThanOrEqualTo(20));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Alpha')),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump(const Duration(milliseconds: 16));
      final lifted = tester.getTopRight(find.text('Alpha').last).dx;
      expect(lifted, closeTo(before, 1));
      await gesture.up();
      await tester.pumpAndSettle();
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

    /// Shows the task list with [titles], a leading `- ` making a subtask.
    Future<void> pump(
      WidgetTester tester, {
      List<String> titles = _names,
    }) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tasks = TaskState(prefs);
      // Added newest first, so they end up in this order.
      for (final title in titles.reversed) {
        await tasks.addTask(title.replaceFirst('- ', ''));
      }
      for (var i = 1; i < titles.length; i++) {
        if (!titles[i].startsWith('- ')) continue;
        final rows = tasks.tasks;
        await tasks.moveTask(rows[i].id, after: rows[i - 1].id, indent: true);
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

    List<String> sketch() => [
      for (final t in tasks.tasks) '${t.indented ? '- ' : ''}${t.title}',
    ];

    testWidgets('dragging a task right makes it a subtask', (tester) async {
      await pump(tester);
      await _hold(tester, 'Bravo', move: const Offset(60, 0));
      expect(sketch(), ['Alpha', '- Bravo', 'Charlie']);
      expect(find.byType(ActionRow), findsNothing);

      final alpha = tester.getTopLeft(find.text('Alpha')).dx;
      final bravo = tester.getTopLeft(find.text('Bravo')).dx;
      expect(bravo - alpha, subtaskIndent);
    });

    testWidgets('a short sideways drag leaves the indent alone', (
      tester,
    ) async {
      await pump(tester);
      await _hold(tester, 'Bravo', move: const Offset(15, 0));
      expect(sketch(), ['Alpha', 'Bravo', 'Charlie']);
    });

    testWidgets('dragging a subtask left makes it a task again', (
      tester,
    ) async {
      await pump(tester);
      await _hold(tester, 'Bravo', move: const Offset(60, 0));
      await _hold(tester, 'Bravo', move: const Offset(-60, 0));
      expect(sketch(), ['Alpha', 'Bravo', 'Charlie']);
    });

    testWidgets('a task takes its subtasks along when dragged', (tester) async {
      await pump(tester);
      await _hold(tester, 'Bravo', move: const Offset(60, 0));
      await _hold(tester, 'Alpha', move: const Offset(0, 150));
      expect(sketch(), ['Charlie', 'Alpha', '- Bravo']);
    });

    testWidgets('a drop just below where it was lifted moves it once', (
      tester,
    ) async {
      await pump(tester, titles: ['A', '- a1', '- a2', 'B']);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('a1')),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      for (final step in [const Offset(-60, 30), const Offset(0, -15)]) {
        for (var i = 0; i < 10; i++) {
          await gesture.moveBy(step / 10);
          await tester.pump(const Duration(milliseconds: 16));
        }
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(sketch(), ['A', '- a2', 'a1', 'B']);
    });

    group('while searching', () {
      /// Holds [title], drags it down and back, and lets go where it was.
      Future<void> wiggle(WidgetTester tester, String title) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.text(title)),
        );
        await tester.pump(
          kLongPressTimeout + const Duration(milliseconds: 100),
        );
        for (final step in [const Offset(0, 30), const Offset(0, -30)]) {
          for (var i = 0; i < 10; i++) {
            await gesture.moveBy(step / 10);
            await tester.pump(const Duration(milliseconds: 16));
          }
        }
        await gesture.up();
        await tester.pumpAndSettle();
      }

      testWidgets('a task held and let go where it was stays there', (
        tester,
      ) async {
        await pump(tester, titles: ['Xfoo', 'Y', 'Z', 'Wfoo']);
        await tester.enterText(find.byType(TextField), 'foo');
        await tester.pumpAndSettle();
        await wiggle(tester, 'Wfoo');
        expect(sketch(), ['Xfoo', 'Y', 'Z', 'Wfoo']);
      });

      testWidgets('a subtask held and let go where it was stays one', (
        tester,
      ) async {
        await pump(tester, titles: ['A', '- afoo', 'B']);
        await tester.enterText(find.byType(TextField), 'foo');
        await tester.pumpAndSettle();
        await wiggle(tester, 'afoo');
        expect(sketch(), ['A', '- afoo', 'B']);
      });

      testWidgets(
        'dragged sideways, a task is indented under the one above it',
        (tester) async {
          await pump(tester, titles: ['Afoo', 'B', 'Cfoo']);
          await tester.enterText(find.byType(TextField), 'foo');
          await tester.pumpAndSettle();
          await _hold(tester, 'Cfoo', move: const Offset(60, 0));
          expect(sketch(), ['Afoo', 'B', '- Cfoo']);
        },
      );
    });

    testWidgets("a task's actions make it a subtask and back, without a drag", (
      tester,
    ) async {
      await pump(tester);
      await _hold(tester, 'Alpha');
      expect(find.bySemanticsLabel(l10n.actionMakeSubtask), findsNothing);
      await tester.longPress(find.text('Alpha'));
      await tester.pumpAndSettle();

      await _hold(tester, 'Bravo');
      await tester.tap(find.bySemanticsLabel(l10n.actionMakeSubtask));
      await tester.pumpAndSettle();
      expect(sketch(), ['Alpha', '- Bravo', 'Charlie']);

      await _hold(tester, 'Bravo');
      await tester.tap(find.bySemanticsLabel(l10n.actionMakeMainTask));
      await tester.pumpAndSettle();
      expect(sketch(), ['Alpha', 'Bravo', 'Charlie']);
    });

    testWidgets('ticking off a task ticks off its subtasks', (tester) async {
      await pump(tester);
      await _hold(tester, 'Bravo', move: const Offset(60, 0));
      await tester.tap(find.byIcon(Icons.check_box_outline_blank).first);
      await tester.pumpAndSettle();
      expect(tasks.tasks.where((t) => t.done).map((t) => t.title), [
        'Alpha',
        'Bravo',
      ]);
    });
  });
}
