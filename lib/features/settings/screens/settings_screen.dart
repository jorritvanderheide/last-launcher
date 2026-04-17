import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/screens/about_screen.dart';
import 'package:last_launcher/features/settings/screens/hidden_apps_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:url_launcher/url_launcher.dart';

const _store = String.fromEnvironment('STORE', defaultValue: 'playstore');

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListenableBuilder(
        listenable: settingsState,
        builder: (context, _) {
          final searchOnly = settingsState.searchOnly;

          return FadeOverflow(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SectionHeader(title: l10n.sectionAppearance),
                _ThemeListTile(
                  themeValue: settingsState.themeValue,
                  onChanged: settingsState.setTheme,
                ),
                SwitchListTile(
                  title: Text(l10n.hideStatusBar),
                  subtitle: Text(l10n.hideStatusBarSubtitle),
                  value: settingsState.hideStatusBar,
                  onChanged: settingsState.setHideStatusBar,
                ),
                SwitchListTile(
                  title: Text(l10n.showHints),
                  subtitle: Text(l10n.showHintsSubtitle),
                  value: settingsState.showHints,
                  onChanged: settingsState.setShowHints,
                ),
                _SectionHeader(title: l10n.sectionApps),
                SwitchListTile(
                  title: Text(l10n.hidePinnedApps),
                  subtitle: Text(l10n.hidePinnedAppsSubtitle),
                  value: settingsState.hidePinnedFromDrawer,
                  onChanged: settingsState.setHidePinnedFromDrawer,
                ),
                ListenableBuilder(
                  listenable: appListState,
                  builder: (context, _) {
                    final count = appListState.hiddenApps.length;
                    return ListTile(
                      leading: const Icon(Icons.visibility_off_outlined),
                      title: Text(l10n.hiddenApps),
                      subtitle: Text(
                        count == 0
                            ? l10n.hiddenAppsNone
                            : l10n.hiddenAppsCount(count),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder<void>(
                            pageBuilder: (_, _, _) => HiddenAppsScreen(
                              appListState: appListState,
                              homeState: homeState,
                              onLaunch: appChannel.launchApp,
                              onOpenAppInfo: appChannel.openAppInfo,
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    );
                  },
                ),
                _SectionHeader(title: l10n.sectionBehavior),
                SwitchListTile(
                  title: Text(l10n.searchOnlyMode),
                  subtitle: Text(l10n.searchOnlyModeSubtitle),
                  value: searchOnly,
                  onChanged: settingsState.setSearchOnly,
                ),
                SwitchListTile(
                  title: Text(l10n.autoShowKeyboard),
                  subtitle: Text(l10n.autoShowKeyboardAppsSubtitle),
                  value: searchOnly || settingsState.autoKeyboard,
                  onChanged: searchOnly ? null : settingsState.setAutoKeyboard,
                ),
                SwitchListTile(
                  title: Text(l10n.autoLaunchOnMatch),
                  subtitle: Text(l10n.autoLaunchOnMatchSubtitle),
                  value: searchOnly || settingsState.autoLaunch,
                  onChanged: searchOnly ? null : settingsState.setAutoLaunch,
                ),
                _SectionHeader(title: l10n.sectionTasks),
                SwitchListTile(
                  title: Text(l10n.taskScreen),
                  subtitle: Text(l10n.taskScreenSubtitle),
                  value: settingsState.tasksEnabled,
                  onChanged: settingsState.setTasksEnabled,
                ),
                SwitchListTile(
                  title: Text(l10n.autoShowKeyboard),
                  subtitle: Text(l10n.autoShowKeyboardTasksSubtitle),
                  value: settingsState.autoKeyboardTasks,
                  onChanged: settingsState.tasksEnabled
                      ? settingsState.setAutoKeyboardTasks
                      : null,
                ),
                SwitchListTile(
                  title: Text(l10n.removeOnComplete),
                  subtitle: Text(l10n.removeOnCompleteSubtitle),
                  value: settingsState.removeOnComplete,
                  onChanged: settingsState.tasksEnabled
                      ? settingsState.setRemoveOnComplete
                      : null,
                ),
                if (_store == 'fdroid') ...[
                  _SectionHeader(title: l10n.sectionSupport),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline),
                    title: Text(l10n.donate),
                    subtitle: Text(l10n.donateSubtitle),
                    onTap: () => launchUrl(
                      Uri.parse('https://liberapay.com/BW20'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
                _SectionHeader(title: l10n.sectionAbout),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.sectionAbout),
                  subtitle: Text(l10n.aboutSubtitle),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        pageBuilder: (_, _, _) => const AboutScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  const _ThemeListTile({required this.themeValue, required this.onChanged});

  final String themeValue;
  final ValueChanged<String> onChanged;

  static const _options = ['system', 'light', 'dark', 'extra'];

  static String _label(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    return switch (value) {
      'system' => l10n.themeSystem,
      'light' => l10n.themeLight,
      'dark' => l10n.themeDark,
      'extra' => l10n.themeExtra,
      _ => l10n.themeSystem,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(AppLocalizations.of(context)!.themeTitle),
      subtitle: Text(_label(context, themeValue)),
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(AppLocalizations.of(context)!.themeTitle),
            children: [
              RadioGroup<String>(
                groupValue: themeValue,
                onChanged: (value) => Navigator.pop(context, value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final option in _options)
                      RadioListTile<String>(
                        value: option,
                        title: Text(_label(context, option)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
        if (result != null) onChanged(result);
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
