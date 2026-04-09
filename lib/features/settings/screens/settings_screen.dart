import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/theme_setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: settingsState,
        builder: (context, _) {
          return ListView(
            children: [
              ThemeSettingTile(
                themeMode: settingsState.themeMode,
                onChanged: settingsState.setThemeMode,
              ),
            ],
          );
        },
      ),
    );
  }
}
