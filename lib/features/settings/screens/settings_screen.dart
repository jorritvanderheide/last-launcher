import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/reorder_screen.dart';
import 'package:last_launcher/features/settings/screens/hidden_apps_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.settingsState,
    required this.appListState,
    required this.homeState,
    super.key,
  });

  final SettingsState settingsState;
  final AppListState appListState;
  final HomeState homeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: settingsState,
        builder: (context, _) {
          final searchOnly = settingsState.searchOnly;

          return ListView(
            children: [
              const _SectionHeader(title: 'Appearance'),
              _ThemeListTile(
                themeMode: settingsState.themeMode,
                onChanged: settingsState.setThemeMode,
              ),
              SwitchListTile(
                title: const Text('AMOLED black'),
                subtitle: const Text('True black background in dark mode'),
                value: settingsState.amoled,
                onChanged: settingsState.themeMode == ThemeMode.light
                    ? null
                    : settingsState.setAmoled,
              ),
              const _SectionHeader(title: 'Apps'),
              ListenableBuilder(
                listenable: homeState,
                builder: (context, _) {
                  if (homeState.pinnedApps.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                    leading: const Icon(Icons.swap_vert),
                    title: const Text('Reorder apps'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<void>(
                          pageBuilder: (_, _, _) => ReorderScreen(
                            homeState: homeState,
                            appListState: appListState,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  );
                },
              ),
              ListenableBuilder(
                listenable: appListState,
                builder: (context, _) {
                  final count = appListState.hiddenApps.length;
                  return ListTile(
                    leading: const Icon(Icons.visibility_off),
                    title: const Text('Hidden apps'),
                    subtitle: Text(count == 0 ? 'None' : '$count hidden'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<void>(
                          pageBuilder: (_, _, _) => HiddenAppsScreen(
                            appListState: appListState,
                            homeState: homeState,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  );
                },
              ),
              const _SectionHeader(title: 'Search'),
              SwitchListTile(
                title: const Text('Search-only mode'),
                subtitle: const Text('Hide app list — type to launch'),
                value: searchOnly,
                onChanged: settingsState.setSearchOnly,
              ),
              SwitchListTile(
                title: const Text('Auto-show keyboard'),
                subtitle: const Text('Open keyboard when app drawer appears'),
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
            ],
          );
        },
      ),
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  const _ThemeListTile({required this.themeMode, required this.onChanged});

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  static String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(_label(themeMode)),
      onTap: () async {
        final result = await showDialog<ThemeMode>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Theme'),
            children: [
              RadioGroup<ThemeMode>(
                groupValue: themeMode,
                onChanged: (value) => Navigator.pop(context, value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final mode in ThemeMode.values)
                      RadioListTile<ThemeMode>(
                        value: mode,
                        title: Text(_label(mode)),
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
