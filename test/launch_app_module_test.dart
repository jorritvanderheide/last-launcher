import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/modules/launch_app/launch_app_settings_screen.dart';
import 'package:last_launcher/features/modules/launch_app_module.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/l10n/app_localizations_en.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  @override
  Future<List<AppInfo>> getInstalledApps() async => const [_music, _webApp];

  @override
  Future<bool> hasWorkProfile() async => false;
}

const _music = AppInfo(packageName: 'com.music', label: 'Music');
const _webApp = AppInfo(
  packageName: 'org.browser',
  label: 'News',
  shortcutId: 'web-news',
);
const _module = LaunchAppModule();
final l10n = AppLocalizationsEn();

Future<ModuleDeps> _deps() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final apps = AppListState(_FakeAppChannel(), prefs);
  await apps.loadApps();
  return ModuleDeps(settingsState: SettingsState(prefs), appListState: apps);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('arriving', () {
    test('launches the chosen app and goes home', () async {
      final deps = await _deps();
      deps.settingsState.launchAppRight.value = _webApp.key;
      final launched = <AppInfo>[];
      final stay = _module.arrive(ModuleSide.right, deps, launched.add);
      expect(stay, isFalse);
      expect(launched.single.shortcutId, 'web-news');
    });

    test('stays to offer a choice when none is chosen', () async {
      final deps = await _deps();
      final launched = <AppInfo>[];
      expect(_module.arrive(ModuleSide.left, deps, launched.add), isTrue);
      expect(launched, isEmpty);
    });

    test('treats an app that is gone as not chosen', () async {
      final deps = await _deps();
      deps.settingsState.launchAppLeft.value = 'com.gone|false';
      final launched = <AppInfo>[];
      expect(_module.arrive(ModuleSide.left, deps, launched.add), isTrue);
      expect(launched, isEmpty);
    });

    test('each side opens its own app', () async {
      final deps = await _deps();
      deps.settingsState.launchAppLeft.value = _music.key;
      deps.settingsState.launchAppRight.value = _webApp.key;
      expect(LaunchAppModule.appFor(ModuleSide.left, deps)?.label, 'Music');
      expect(LaunchAppModule.appFor(ModuleSide.right, deps)?.label, 'News');
    });
  });

  test('sits on both sides, and stays there after a restart', () async {
    final deps = await _deps();
    final settings = deps.settingsState;
    settings.setLeftPanel(_module);
    settings.setRightPanel(_module);
    expect(settings.leftPanel.value, isA<LaunchAppModule>());
    expect(settings.rightPanel.value, isA<LaunchAppModule>());

    final restored = SettingsState(await SharedPreferences.getInstance());
    expect(restored.leftPanel.value, isA<LaunchAppModule>());
    expect(restored.rightPanel.value, isA<LaunchAppModule>());
  });

  group('settings page', () {
    Future<ModuleDeps> pumpPage(WidgetTester tester) async {
      final deps = await _deps();
      deps.settingsState.setLeftPanel(_module);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LaunchAppSettingsScreen(deps: deps),
        ),
      );
      await tester.pumpAndSettle();
      return deps;
    }

    ListTile row(WidgetTester tester, String title) =>
        tester.widget(find.widgetWithText(ListTile, title));

    testWidgets('only the side the module is on can be set', (tester) async {
      await pumpPage(tester);
      expect(row(tester, l10n.launchAppLeft).enabled, isTrue);
      expect(row(tester, l10n.launchAppRight).enabled, isFalse);
      expect(find.text(l10n.launchAppOnlyRight), findsOneWidget);
    });

    testWidgets('picks an app, and none again', (tester) async {
      final deps = await pumpPage(tester);
      await tester.tap(find.text(l10n.launchAppLeft));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Music'));
      await tester.pumpAndSettle();
      expect(deps.settingsState.launchAppLeft.value, _music.key);
      expect(find.text('Music'), findsOneWidget);

      await tester.tap(find.text(l10n.launchAppLeft));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.panelNone));
      await tester.pumpAndSettle();
      expect(deps.settingsState.launchAppLeft.value, isNull);
    });

    testWidgets('the picker searches', (tester) async {
      await pumpPage(tester);
      await tester.tap(find.text(l10n.launchAppLeft));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'new');
      await tester.pumpAndSettle();
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Music'), findsNothing);
    });
  });

  testWidgets('home hints name the chosen app', (tester) async {
    final deps = await _deps();
    deps.settingsState.launchAppLeft.value = _music.key;
    late String left;
    late String right;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            left = _module.hintName(context, ModuleSide.left, deps);
            right = _module.hintName(context, ModuleSide.right, deps);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(left, 'Music');
    expect(right, l10n.panelLaunchAppHint);
    expect(l10n.hintSwipeRightFor(left), 'Swipe right for Music');
  });

  testWidgets('with no app chosen the panel leads to the settings', (
    tester,
  ) async {
    final deps = await _deps();
    deps.settingsState.setLeftPanel(_module);
    SharedPreferences.setMockInitialValues({});
    final tasks = TaskState(await SharedPreferences.getInstance());
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => _module.build(
            context,
            LauncherModuleProps(
              deps: deps,
              taskState: tasks,
              side: ModuleSide.left,
              isVisible: true,
              scrollLocked: false,
              onReorderStart: () {},
              onReorderEnd: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.launchAppChoose));
    await tester.pumpAndSettle();
    expect(find.byType(LaunchAppSettingsScreen), findsOneWidget);
  });
}
