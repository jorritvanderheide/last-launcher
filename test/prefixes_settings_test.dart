import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/features/settings/screens/prefixes_settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/l10n/app_localizations_en.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  @override
  Future<List<AppInfo>> getInstalledApps() async => const [
    AppInfo(packageName: 'com.music', label: 'Music'),
  ];

  @override
  Future<bool> hasWorkProfile() async => true;

  @override
  Future<List<AppChoice>> appsWithSearch() async => const [
    (packageName: 'com.music', label: 'Music'),
  ];

  @override
  Future<List<AppChoice>> appsForLink(String uri) async => const [
    (packageName: 'org.browser', label: 'Browser'),
  ];
}

final l10n = AppLocalizationsEn();

Future<SettingsState> _pump(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final settings = SettingsState(prefs);
  final channel = _FakeAppChannel();
  final apps = AppListState(channel, prefs);
  await apps.loadApps();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PrefixesSettingsScreen(
        settingsState: settings,
        appListState: apps,
        appChannel: channel,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return settings;
}

Finder _field(String label) => find.widgetWithText(TextField, label);

Future<void> _save(WidgetTester tester) async {
  await tester.tap(find.text(l10n.renameDialogSave));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the defaults with their triggers visible', (tester) async {
    await _pump(tester);
    expect(find.text('.'), findsOneWidget);
    expect(find.text('␣'), findsOneWidget);
    expect(find.text(l10n.prefixTypeWork), findsWidgets);
    expect(find.text(l10n.prefixRestoreDefaults), findsNothing);
  });

  testWidgets('adds a link prefix from a template', (tester) async {
    final settings = await _pump(tester);
    await tester.tap(find.text(l10n.prefixAdd));
    await tester.pumpAndSettle();

    await tester.enterText(_field(l10n.prefixTrigger), 'd ');
    await tester.tap(find.text(l10n.prefixTemplates));
    await tester.pumpAndSettle();
    await tester.tap(find.text('DuckDuckGo'));
    await tester.pumpAndSettle();
    await _save(tester);

    final added = settings.searchPrefixes.value.last;
    expect(added.trigger, 'd ');
    expect(added.name, 'DuckDuckGo');
    expect((added.action as OpenLink).template, 'https://duckduckgo.com/?q=%s');
    expect(find.text('d␣'), findsOneWidget);
  });

  testWidgets('refuses an empty or taken trigger, or a link without %s', (
    tester,
  ) async {
    final settings = await _pump(tester);
    await tester.tap(find.text(l10n.prefixAdd));
    await tester.pumpAndSettle();

    await _save(tester);
    expect(find.text(l10n.prefixErrorEmpty), findsOneWidget);
    expect(find.text(l10n.prefixErrorNoPlaceholder), findsOneWidget);

    await tester.enterText(_field(l10n.prefixTrigger), '.');
    await tester.enterText(_field(l10n.prefixLink), 'https://example.org');
    await _save(tester);
    expect(find.text(l10n.prefixErrorTaken), findsOneWidget);
    expect(settings.searchPrefixes.value, hasLength(2));
  });

  testWidgets('warns when a trigger would hide apps', (tester) async {
    await _pump(tester);
    await tester.tap(find.text(l10n.prefixAdd));
    await tester.pumpAndSettle();

    await tester.enterText(_field(l10n.prefixTrigger), 'g');
    await tester.pump();
    expect(find.text(l10n.prefixShadowWarning), findsOneWidget);

    await tester.enterText(_field(l10n.prefixTrigger), 'g ');
    await tester.pump();
    expect(find.text(l10n.prefixShadowWarning), findsNothing);
  });

  testWidgets('searches in an app offering search', (tester) async {
    final settings = await _pump(tester);
    await tester.tap(find.text(l10n.prefixAdd));
    await tester.pumpAndSettle();

    await tester.enterText(_field(l10n.prefixTrigger), 'm ');
    await tester.tap(find.text(l10n.prefixType));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.prefixTypeSearchInApp).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.prefixApp));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Music'));
    await tester.pumpAndSettle();
    await _save(tester);

    final added = settings.searchPrefixes.value.last;
    expect((added.action as SearchInApp).package, 'com.music');
  });

  testWidgets('defaults can be deleted and restored', (tester) async {
    final settings = await _pump(tester);
    await tester.tap(find.text('.'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.actionRemove));
    await tester.pumpAndSettle();
    expect(settings.searchPrefixes.value.map((p) => p.trigger), [' ']);

    await tester.tap(find.text(l10n.prefixRestoreDefaults));
    await tester.pumpAndSettle();
    expect(
      settings.searchPrefixes.value.map((p) => p.trigger),
      containsAll(['.', ' ']),
    );
  });

  testWidgets('a prefix can be switched off', (tester) async {
    final settings = await _pump(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(settings.searchPrefixes.value.first.enabled, isFalse);
  });
}
