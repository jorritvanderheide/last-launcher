import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_sheet.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  @override
  Future<List<AppInfo>> getInstalledApps() async => const [
    AppInfo(packageName: 'com.gallery', label: 'Gallery'),
  ];

  @override
  Future<bool> hasWorkProfile() async => false;
}

const _web = SearchPrefix(
  trigger: 'g ',
  name: 'Web',
  action: OpenLink('https://duckduckgo.com/?q=%s'),
);

class _Drawer {
  final launched = <String>[];
  final ran = <PrefixMatch>[];
  late SettingsState settings;
}

Future<_Drawer> _pump(WidgetTester tester, {bool searchOnly = false}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final drawer = _Drawer();
  final settings = drawer.settings = SettingsState(prefs)
    ..searchPrefixes.value = [...defaultPrefixes, _web]
    ..searchOnly.value = searchOnly
    ..autoKeyboard.value = false;
  final apps = AppListState(_FakeAppChannel(), prefs)
    ..applyPrefs(settings.searchPrefs);
  await apps.loadApps();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AppDrawerSheet(
          appListState: apps,
          homeState: HomeState(prefs),
          settingsState: settings,
          isOpen: true,
          isAtTop: ValueNotifier(true),
          onLaunch: (package, {isWorkApp = false, shortcutId}) =>
              drawer.launched.add(package),
          onOpenAppInfo: (_) {},
          onRemoveShortcut: (_) {},
          onRunAction: drawer.ran.add,
          onCloseDrawer: () {},
        ),
      ),
    ),
  );
  // Let the keyboard request behind opening the drawer run out.
  await tester.pump(const Duration(milliseconds: 400));
  return drawer;
}

void main() {
  testWidgets('a prefix shows its action alone, and a tap runs it', (
    tester,
  ) async {
    final drawer = await _pump(tester);
    await tester.enterText(find.byType(TextField), 'g cats');
    await tester.pump();

    expect(find.text('Web: cats'), findsOneWidget);
    expect(find.text('Gallery'), findsNothing);
    expect(drawer.launched, isEmpty);

    await tester.tap(find.text('Web: cats'));
    expect(drawer.ran.single.argument, 'cats');
  });

  testWidgets('Enter runs the action too', (tester) async {
    final drawer = await _pump(tester);
    await tester.enterText(find.byType(TextField), 'G cats');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    expect(drawer.ran.single.prefix.name, 'Web');
  });

  testWidgets('nothing runs before something follows the prefix', (
    tester,
  ) async {
    final drawer = await _pump(tester);
    await tester.enterText(find.byType(TextField), 'g ');
    await tester.pump();
    expect(find.text('Web: …'), findsOneWidget);

    await tester.tap(find.text('Web: …'));
    await tester.testTextInput.receiveAction(TextInputAction.go);
    expect(drawer.ran, isEmpty);
  });

  testWidgets('auto-launch waits while a prefix is being typed', (
    tester,
  ) async {
    final drawer = await _pump(tester);
    // "g" is the only match for Gallery, but also on the way to "g ".
    await tester.enterText(find.byType(TextField), 'g');
    await tester.pump();
    expect(drawer.launched, isEmpty);

    await tester.enterText(find.byType(TextField), 'ga');
    await tester.pump();
    expect(drawer.launched, ['com.gallery']);
  });

  testWidgets('search-only mode shows the action row too', (tester) async {
    final drawer = await _pump(tester, searchOnly: true);
    await tester.enterText(find.byType(TextField), 'g cats');
    await tester.pump();

    await tester.tap(find.text('Web: cats'));
    expect(drawer.ran.single.argument, 'cats');
    expect(drawer.launched, isEmpty);
  });
}
