import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/screens/hidden_apps_screen.dart';
import 'package:last_launcher/features/settings/screens/prefixes_settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

/// How many apps the drawer leaves out, among the profiles it shows.
int hiddenAppCount(
  AppListState appListState,
  HomeState homeState,
  SettingsState settingsState,
) {
  final isWorkByKey = <String, bool>{
    for (final app in appListState.hiddenApps) app.key: app.isWorkApp,
    if (settingsState.hidePinnedFromDrawer.value)
      for (final app in homeState.pinnedApps) app.key: app.isWorkApp,
  };
  final hasWorkApps = appListState.workPackages.isNotEmpty;
  final hidePersonal =
      settingsState.hidePersonalWhenWorkActive.value && hasWorkApps;
  return isWorkByKey.values
      .where((isWork) => hidePersonal ? isWork : hasWorkApps || !isWork)
      .length;
}

/// Summary for a hidden-app count, as shown under the rows that lead here.
String hiddenAppSummary(BuildContext context, int count) {
  final l10n = AppLocalizations.of(context)!;
  return count == 0 ? l10n.hiddenAppsNone : l10n.hiddenAppsCount(count);
}

class DrawerSettingsScreen extends StatelessWidget {
  const DrawerSettingsScreen({
    required this.settingsState,
    required this.appListState,
    required this.homeState,
    required this.appChannel,
    super.key,
  });

  final SettingsState settingsState;
  final AppListState appListState;
  final HomeState homeState;
  final AppChannel appChannel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionAppDrawer,
      listenable: Listenable.merge([s, appListState, homeState]),
      reserveIconSpace: true,
      children: (context) => [
        // A mode rather than a switch: it decides what the drawer is, and
        // with it which of the rows below apply at all.
        ChoiceTile<bool>(
          title: l10n.drawerMode,
          value: s.searchOnly.value,
          options: const [false, true],
          label: (context, searchOnly) =>
              searchOnly ? l10n.searchOnlyMode : l10n.drawerModeList,
          onChanged: (searchOnly) => s.searchOnly.value = searchOnly,
        ),
        ListTile(
          leading: const Icon(Icons.visibility_off_outlined),
          title: Text(l10n.hiddenApps),
          subtitle: Text(
            hiddenAppSummary(
              context,
              hiddenAppCount(appListState, homeState, s),
            ),
          ),
          onTap: () => pushSettingsPage(
            context,
            HiddenAppsScreen(
              appListState: appListState,
              homeState: homeState,
              settingsState: s,
              onLaunch: appChannel.launchApp,
              onOpenAppInfo: appChannel.openAppInfo,
            ),
          ),
        ),
        SettingSwitch(
          setting: s.hidePinnedFromDrawer,
          title: l10n.hidePinnedApps,
          subtitle: l10n.hidePinnedAppsSubtitle,
        ),
        SettingsSectionHeader(title: l10n.sectionSearch),
        ListTile(
          leading: const Icon(Icons.manage_search),
          title: Text(l10n.searchPrefixes),
          subtitle: Text(l10n.searchPrefixesSubtitle),
          onTap: () => pushSettingsPage(
            context,
            PrefixesSettingsScreen(
              settingsState: s,
              appListState: appListState,
              appChannel: appChannel,
            ),
          ),
        ),
        SettingSwitch(
          setting: s.includeHiddenInSearch,
          title: l10n.includeHiddenInSearch,
          subtitle: l10n.includeHiddenInSearchSubtitle,
        ),
        SettingSwitch(
          setting: s.matchOriginalName,
          title: l10n.matchOriginalName,
          subtitle: l10n.matchOriginalNameSubtitle,
        ),
        // Search-only mode always shows the keyboard and launches the single
        // match, so those two only apply to the list, as do hints, which
        // underline letters in it.
        if (!s.searchOnly.value) ...[
          SettingSwitch(
            setting: s.autoKeyboard,
            title: l10n.autoShowKeyboard,
            subtitle: l10n.autoShowKeyboardAppsSubtitle,
          ),
          SettingSwitch(
            setting: s.autoLaunch,
            title: l10n.autoLaunchOnMatch,
            subtitle: l10n.autoLaunchOnMatchSubtitle,
          ),
        ],
        SettingSwitch(
          setting: s.extraChar,
          title: l10n.extraChar,
          subtitle: l10n.extraCharSubtitle,
          enabled: s.extraCharAvailable,
          effective: s.extraCharActive,
          // Refines auto-launch, which only has a row of its own in the list.
          indent: !s.searchOnly.value,
        ),
        if (!s.searchOnly.value)
          SettingSwitch(
            setting: s.quickLaunchHints,
            title: l10n.quickLaunchHints,
            subtitle: l10n.quickLaunchHintsSubtitle,
            enabled: s.quickLaunchHintsAvailable,
            effective: s.quickLaunchHintsActive,
            indent: true,
          ),
      ],
    );
  }
}
