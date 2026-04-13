import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/screens/hidden_apps_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: settingsState,
        builder: (context, _) {
          final searchOnly = settingsState.searchOnly;

          return FadeOverflow(
            child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const _SectionHeader(title: 'Appearance'),
              _ThemeListTile(
                themeValue: settingsState.themeValue,
                onChanged: settingsState.setTheme,
              ),
              SwitchListTile(
                title: const Text('Hide status bar'),
                subtitle: const Text('Full screen mode'),
                value: settingsState.hideStatusBar,
                onChanged: settingsState.setHideStatusBar,
              ),
              SwitchListTile(
                title: const Text('Home screen hints'),
                subtitle: const Text('Show usage tips when no apps are pinned'),
                value: settingsState.showHints,
                onChanged: settingsState.setShowHints,
              ),
              const _SectionHeader(title: 'Apps'),
              ListenableBuilder(
                listenable: appListState,
                builder: (context, _) {
                  final count = appListState.hiddenApps.length;
                  return ListTile(
                    title: const Text('Hidden apps'),
                    subtitle: Text(count == 0 ? 'None' : '$count hidden'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<void>(
                          pageBuilder: (_, _, _) => HiddenAppsScreen(
                            appListState: appListState,
                            homeState: homeState,
                            onLaunch: appChannel.launchApp,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  );
                },
              ),
              const _SectionHeader(title: 'Behavior'),
              SwitchListTile(
                title: const Text('Search-only mode'),
                subtitle: const Text('Hide app list — type to launch'),
                value: searchOnly,
                onChanged: settingsState.setSearchOnly,
              ),
              SwitchListTile(
                title: const Text('Auto-show keyboard'),
                subtitle: const Text(
                  'Show keyboard when opening app drawer',
                ),
                value: searchOnly || settingsState.autoKeyboard,
                onChanged: searchOnly ? null : settingsState.setAutoKeyboard,
              ),
              SwitchListTile(
                title: const Text('Auto-launch on match'),
                subtitle: const Text(
                  'Launch automatically when one app matches',
                ),
                value: searchOnly || settingsState.autoLaunch,
                onChanged: searchOnly ? null : settingsState.setAutoLaunch,
              ),
              const _SectionHeader(title: 'Tasks'),
              SwitchListTile(
                title: const Text('Task screen'),
                subtitle: const Text('Swipe right from home to view tasks'),
                value: settingsState.tasksEnabled,
                onChanged: settingsState.setTasksEnabled,
              ),
              SwitchListTile(
                title: const Text('Auto-show keyboard'),
                subtitle: const Text(
                  'Show keyboard when opening task screen',
                ),
                value: settingsState.autoKeyboardTasks,
                onChanged: settingsState.tasksEnabled
                    ? settingsState.setAutoKeyboardTasks
                    : null,
              ),
              SwitchListTile(
                title: const Text('Remove on complete'),
                subtitle: const Text(
                  'Remove tasks when marked as done',
                ),
                value: settingsState.removeOnComplete,
                onChanged: settingsState.tasksEnabled
                    ? settingsState.setRemoveOnComplete
                    : null,
              ),
              if (_store == 'fdroid') ...[
                const _SectionHeader(title: 'Support'),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text('Donate'),
                  subtitle: const Text('Support development on Liberapay'),
                  onTap: () => launchUrl(
                    Uri.parse('https://liberapay.com/BW20'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
              const _SectionHeader(title: 'About'),
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              const ListTile(
                title: Text('License'),
                subtitle: Text('EUPL-1.2'),
              ),
              ListTile(
                title: const Text('Open source licenses'),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Last Launcher',
                  applicationVersion: '1.0.0',
                ),
              ),
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

  static String _label(String value) => switch (value) {
    'system' => 'System',
    'light' => 'Light',
    'dark' => 'Dark',
    'extra' => 'Extra',
    _ => 'System',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(_label(themeValue)),
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Theme'),
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
                        title: Text(_label(option)),
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
