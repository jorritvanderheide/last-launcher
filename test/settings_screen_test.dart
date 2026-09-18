import 'dart:convert';

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
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  _FakeAppChannel({required this.isDefault, required this.workProfile});

  final bool isDefault;
  final bool workProfile;

  /// What the file picker hands back when opening a backup.
  String? backupToOpen;

  /// What was last written through the file picker.
  String? savedBackup;

  @override
  Future<bool> saveBackup(String fileName, String content) async {
    savedBackup = content;
    return true;
  }

  @override
  Future<String?> openBackup() async => backupToOpen;

  @override
  Future<bool> isDefaultLauncher() async => isDefault;

  @override
  Future<List<AppInfo>> getInstalledApps() async => const [];

  @override
  Future<bool> hasWorkProfile() async => workProfile;
}

final l10n = AppLocalizationsEn();

late _FakeAppChannel _channel;

Future<SettingsState> _pumpSettings(
  WidgetTester tester, {
  Map<String, Object> stored = const {},
  bool isDefault = true,
  bool workProfile = false,
  bool accentAvailable = false,
}) async {
  // Tall enough that every row of the longest page is built.
  await tester.binding.setSurfaceSize(const Size(800, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  final channel = _channel = _FakeAppChannel(
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
      builder: (context, child) => AppearanceScope(
        labelFontSize: 28,
        accentAvailable: accentAvailable,
        terminalPrompt: false,
        animate: true,
        child: child!,
      ),
      home: SettingsScreen(
        settingsState: settings,
        appListState: appList,
        homeState: HomeState(prefs),
        appChannel: channel,
        onRestored: settings.reload,
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

  testWidgets('drawer mode decides which search rows apply', (tester) async {
    final settings = await _pumpSettings(tester);
    settings.extraChar.value = true;
    await tester.tap(find.text(l10n.sectionAppDrawer));
    await tester.pumpAndSettle();
    expect(find.text(l10n.drawerModeList), findsOneWidget);
    expect(_switch(tester, l10n.extraChar).value, isTrue);

    await tester.tap(find.text(l10n.drawerMode));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.searchOnlyMode).last);
    await tester.pumpAndSettle();

    // Search-only takes over these, so they're gone, not greyed out.
    expect(settings.searchOnly.value, isTrue);
    expect(find.text(l10n.autoShowKeyboard), findsNothing);
    expect(find.text(l10n.autoLaunchOnMatch), findsNothing);
    expect(find.text(l10n.quickLaunchHints), findsNothing);
    // Extra character still applies, and can still be changed.
    final extraChar = _switch(tester, l10n.extraChar);
    expect(extraChar.value, isTrue);
    expect(extraChar.onChanged, isNotNull);
    expect(find.text(l10n.includeHiddenInSearch), findsOneWidget);

    await tester.tap(find.text(l10n.drawerMode));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.drawerModeList).last);
    await tester.pumpAndSettle();

    expect(settings.searchOnly.value, isFalse);
    expect(find.text(l10n.quickLaunchHints), findsOneWidget);
    expect(_switch(tester, l10n.extraChar).value, isTrue);
  });

  testWidgets('quick-launch options wait for auto-launch', (tester) async {
    final settings = await _pumpSettings(tester);
    settings.extraChar.value = true;
    await tester.tap(find.text(l10n.sectionAppDrawer));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.autoLaunchOnMatch));
    await tester.pumpAndSettle();

    final extraChar = _switch(tester, l10n.extraChar);
    expect(extraChar.onChanged, isNull);
    expect(extraChar.value, isFalse);
    expect(settings.extraChar.value, isTrue);
  });

  testWidgets('appearance presets and custom looks', (tester) async {
    final settings = await _pumpSettings(tester);
    await tester.tap(find.text(l10n.sectionAppearance));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.themeStyleTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.themeExtra).last);
    await tester.pumpAndSettle();
    expect(settings.preset, ThemePreset.extra);
    expect(settings.themeMode.value, ThemeMode.dark);

    await tester.tap(find.text(l10n.glow));
    await tester.pumpAndSettle();
    expect(settings.glow.value, isFalse);
    expect(find.text(l10n.themeStyleCustom), findsOneWidget);
  });

  testWidgets('text size slider stores the size when let go', (tester) async {
    final settings = await _pumpSettings(tester);
    await tester.tap(find.text(l10n.sectionAppearance));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Slider), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(settings.textSize.value, SettingsState.textSizeMin);
    expect(find.text('18'), findsOneWidget);
  });

  testWidgets('accent row only where the system has an accent', (tester) async {
    await _pumpSettings(tester);
    await tester.tap(find.text(l10n.sectionAppearance));
    await tester.pumpAndSettle();
    expect(find.text(l10n.accentColor), findsNothing);
  });

  testWidgets('accent row toggles the setting', (tester) async {
    final settings = await _pumpSettings(tester, accentAvailable: true);
    await tester.tap(find.text(l10n.sectionAppearance));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.accentColor));
    await tester.pumpAndSettle();
    expect(settings.accentColor.value, isTrue);
  });

  group('backup', () {
    Future<void> openBackupPage(WidgetTester tester) async {
      await tester.tap(find.text(l10n.backupTitle));
      await tester.pumpAndSettle();
    }

    testWidgets('restore replaces settings without a restart', (tester) async {
      final settings = await _pumpSettings(tester);
      _channel.backupToOpen = jsonEncode({
        'format': 'last-launcher-backup',
        'version': 1,
        'modules': [],
        'prefs': {
          'locked': {'type': 'bool', 'value': true},
        },
      });
      await openBackupPage(tester);

      await tester.tap(find.text(l10n.backupRestore));
      await tester.pumpAndSettle();
      expect(find.text(l10n.backupRestoreConfirm), findsOneWidget);
      await tester.tap(find.text(l10n.backupRestoreAction));
      await tester.pumpAndSettle();

      expect(settings.locked.value, isTrue);
      expect(find.text(l10n.backupRestored), findsOneWidget);
    });

    testWidgets('restore refuses a file that is not a backup', (tester) async {
      final settings = await _pumpSettings(tester);
      _channel.backupToOpen = '{"hello": "world"}';
      await openBackupPage(tester);

      await tester.tap(find.text(l10n.backupRestore));
      await tester.pumpAndSettle();
      expect(find.text(l10n.backupInvalid), findsOneWidget);
      expect(settings.locked.value, isFalse);
    });

    testWidgets('export can leave the tasks out', (tester) async {
      await _pumpSettings(tester, stored: {'locked': true, 'tasks': '[]'});
      await openBackupPage(tester);

      await tester.tap(find.text(l10n.backupExport));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(CheckboxListTile, l10n.sectionTasks),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.backupExportAction));
      await tester.pumpAndSettle();

      final saved = jsonDecode(_channel.savedBackup!) as Map<String, Object?>;
      final prefs = saved['prefs']! as Map<String, Object?>;
      expect(prefs.containsKey('locked'), isTrue);
      expect(prefs.containsKey('tasks'), isFalse);
      expect(find.text(l10n.backupSaved), findsOneWidget);
    });
  });

  testWidgets('first row of a page sits below the top fade', (tester) async {
    await _pumpSettings(tester);
    await tester.tap(find.text(l10n.sectionHome));
    await tester.pumpAndSettle();

    final list = tester.getTopLeft(find.byType(ListView)).dy;
    final firstRow = tester.getTopLeft(
      find.widgetWithText(SwitchListTile, l10n.lockLayout),
    );
    expect(firstRow.dy - list, greaterThanOrEqualTo(FadeOverflow.defaultSize));
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
