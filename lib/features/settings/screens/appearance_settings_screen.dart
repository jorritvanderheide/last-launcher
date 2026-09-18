import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

/// Label for a stored theme value.
String themeLabel(BuildContext context, String value) {
  final l10n = AppLocalizations.of(context)!;
  return switch (value) {
    'light' => l10n.themeLight,
    'dark' => l10n.themeDark,
    'extra' => l10n.themeExtra,
    _ => l10n.themeSystem,
  };
}

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionAppearance,
      listenable: s,
      children: (context) => [
        ChoiceTile<String>(
          leading: const Icon(Icons.palette_outlined),
          title: l10n.themeTitle,
          value: s.theme.value,
          options: const ['system', 'light', 'dark', 'extra'],
          label: themeLabel,
          onChanged: (value) => s.theme.value = value,
        ),
        SettingSwitch(
          setting: s.hideStatusBar,
          title: l10n.hideStatusBar,
          subtitle: l10n.hideStatusBarSubtitle,
        ),
        SettingSwitch(
          setting: s.showHints,
          title: l10n.showHints,
          subtitle: l10n.showHintsSubtitle,
        ),
      ],
    );
  }
}
