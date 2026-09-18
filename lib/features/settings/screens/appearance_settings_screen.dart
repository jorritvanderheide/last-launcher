import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

String themeModeLabel(BuildContext context, ThemeMode mode) {
  final l10n = AppLocalizations.of(context)!;
  return switch (mode) {
    ThemeMode.system => l10n.themeSystem,
    ThemeMode.light => l10n.themeLight,
    ThemeMode.dark => l10n.themeDark,
  };
}

String themeStyleLabel(BuildContext context, ThemeStyle style) {
  final l10n = AppLocalizations.of(context)!;
  return switch (style) {
    ThemeStyle.standard => l10n.themeStyleStandard,
    ThemeStyle.extra => l10n.themeExtra,
  };
}

/// One-line description of the current look, for the row leading here.
String appearanceSummary(BuildContext context, SettingsState settings) =>
    settings.isExtra
    ? themeStyleLabel(context, ThemeStyle.extra)
    : themeModeLabel(context, settings.effectiveThemeMode);

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
        ChoiceTile<ThemeStyle>(
          leading: const Icon(Icons.palette_outlined),
          title: l10n.themeStyleTitle,
          value: s.themeStyle.value,
          options: ThemeStyle.values,
          label: themeStyleLabel,
          onChanged: (style) => s.themeStyle.value = style,
        ),
        ChoiceTile<ThemeMode>(
          leading: const Icon(Icons.brightness_6_outlined),
          title: l10n.themeTitle,
          value: s.effectiveThemeMode,
          options: ThemeMode.values,
          label: themeModeLabel,
          subtitle: s.themeModeAvailable ? null : l10n.themeExtraAlwaysDark,
          onChanged: s.themeModeAvailable
              ? (mode) => s.themeMode.value = mode
              : null,
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
