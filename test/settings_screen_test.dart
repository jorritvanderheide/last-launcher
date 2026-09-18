import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/modules/tasks_module.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/screens/task_settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/l10n/app_localizations_en.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  _FakeAppChannel({required this.isDefault, required this.workProfile});

  final bool isDefault;
  final bool workProfile;

  @override
  Future<bool> isDefaultLauncher() async => isDefault;

  @override
  Future<List<AppInfo>> getInstalledApps() async => const [];

  @override
  Future<bool> hasWorkProfile() async => workProfile;
}

final l10n = AppLocalizationsEn();

Future<SettingsState> _pumpSettings(
  WidgetTester tester, {
  bool isDefault = true,
  bool workProfile = false,
}) async {
  // Tall enough that every row of the longest page is built.
  await tester.binding.setSurfaceSize(const Size(800, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final channel = _FakeAppChannel(
    isDefault: isDefault,
    workProfile: workProfile,
  );
  final settings = SettingsState(prefs);
  final appList = AppListState(channel, prefs);
  await appList.loadApps();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsScreen(
        settingsState: settings,
        appListState: appList,
        homeState: HomeState(prefs),
        appChannel: channel,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return settings;
}

SwitchListTile _switch(WidgetTester tester, String title) =>
    tester.widget(find.widgetWithText(SwitchListTile, title));

void main() {
  testWidgets('root lists the categories that apply', (tester) async {
    await _pumpSettings(tester);

    expect(find.text(l10n.sectionAppearance), findsOneWidget);
    expect(find.text(l10n.sectionHome), findsOneWidget);
    expect(find.text(l10n.sectionAppDrawer), findsOneWidget);
    expect(find.text(l10n.setAsDefault), findsNothing);
    expect(find.text(l10n.sectionWork), findsNothing);
    expect(find.text(l10n.sectionTasks), findsNothing);
  });

  testWidgets('root offers to become the default launcher', (tester) async {
    await _pumpSettings(tester, isDefault: false);
    expect(find.text(l10n.setAsDefault), findsOneWidget);
  });

  testWidgets('root shows work settings only with a work profile', (
    tester,
  ) async {
    await _pumpSettings(tester, workProfile: true);
    expect(find.text(l10n.sectionWork), findsOneWidget);
  });

  testWidgets('a module on either side gets its settings row', (tester) async {
    final settings = await _pumpSettings(tester);
    settings.setRightPanel(TasksModule());
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.sectionTasks));
    await tester.pumpAndSettle();
    expect(find.byType(TaskSettingsScreen), findsOneWidget);
  });

  testWidgets('drawer page follows the rules between settings', (tester) async {
    final settings = await _pumpSettings(tester);
    settings.extraChar.value = true;
    await tester.tap(find.text(l10n.sectionAppDrawer));
    await tester.pumpAndSettle();

    var extraChar = _switch(tester, l10n.extraChar);
    expect(extraChar.onChanged, isNotNull);
    expect(extraChar.value, isTrue);

    await tester.tap(find.text(l10n.searchOnlyMode));
    await tester.pumpAndSettle();
    expect(settings.searchOnly.value, isTrue);

    // Search-only takes over: the row is locked off, the choice is kept.
    extraChar = _switch(tester, l10n.extraChar);
    expect(extraChar.onChanged, isNull);
    expect(extraChar.value, isFalse);
    expect(settings.extraChar.value, isTrue);

    final autoKeyboard = _switch(tester, l10n.autoShowKeyboard);
    expect(autoKeyboard.onChanged, isNull);
    expect(autoKeyboard.value, isTrue);
  });

  testWidgets('home page picks a module by id', (tester) async {
    final settings = await _pumpSettings(tester);
    await tester.tap(find.text(l10n.sectionHome));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.leftOfHome));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.sectionTasks).last);
    await tester.pumpAndSettle();

    expect(settings.leftPanel.value, isA<TasksModule>());
  });
}
