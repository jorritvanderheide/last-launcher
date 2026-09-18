import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';

String themeModeLabel(BuildContext context, ThemeMode mode) {
  final l10n = AppLocalizations.of(context)!;
  return switch (mode) {
    ThemeMode.system => l10n.themeSystem,
    ThemeMode.light => l10n.themeLight,
    ThemeMode.dark => l10n.themeDark,
  };
}

String themePresetLabel(BuildContext context, ThemePreset preset) {
  final l10n = AppLocalizations.of(context)!;
  return switch (preset) {
    ThemePreset.standard => l10n.themeStyleStandard,
    ThemePreset.extra => l10n.themeExtra,
    ThemePreset.custom => l10n.themeStyleCustom,
  };
}

String _fontLabel(BuildContext context, FontChoice font) {
  final l10n = AppLocalizations.of(context)!;
  return switch (font) {
    FontChoice.standard => l10n.fontStandard,
    FontChoice.mono => l10n.fontMono,
  };
}

String _alignmentLabel(BuildContext context, LabelAlignment alignment) {
  final l10n = AppLocalizations.of(context)!;
  return switch (alignment) {
    LabelAlignment.left => l10n.alignLeft,
    LabelAlignment.center => l10n.alignCenter,
    LabelAlignment.right => l10n.alignRight,
  };
}

String _scanlineLabel(BuildContext context, ScanlineLevel level) {
  final l10n = AppLocalizations.of(context)!;
  return switch (level) {
    ScanlineLevel.off => l10n.scanlinesOff,
    ScanlineLevel.light => l10n.scanlinesLight,
    ScanlineLevel.medium => l10n.scanlinesMedium,
    ScanlineLevel.strong => l10n.scanlinesStrong,
  };
}

/// One-line description of the current look, for the row leading here.
String appearanceSummary(BuildContext context, SettingsState settings) =>
    '${themePresetLabel(context, settings.preset)} · '
    '${themeModeLabel(context, settings.themeMode.value)}';

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
        // Custom is what the options add up to, never something to pick.
        ChoiceTile<ThemePreset>(
          leading: const Icon(Icons.palette_outlined),
          title: l10n.themeStyleTitle,
          value: s.preset,
          options: const [ThemePreset.standard, ThemePreset.extra],
          label: themePresetLabel,
          onChanged: s.applyPreset,
        ),
        ChoiceTile<ThemeMode>(
          leading: const Icon(Icons.brightness_6_outlined),
          title: l10n.themeTitle,
          value: s.themeMode.value,
          options: ThemeMode.values,
          label: themeModeLabel,
          onChanged: (mode) => s.themeMode.value = mode,
        ),
        ChoiceTile<FontChoice>(
          leading: const Icon(Icons.text_fields),
          title: l10n.fontTitle,
          value: s.font.value,
          options: FontChoice.values,
          label: _fontLabel,
          onChanged: (font) => s.font.value = font,
        ),
        SettingSlider(
          leading: const Icon(Icons.format_size),
          setting: s.textSize,
          title: l10n.textSizeTitle,
          min: SettingsState.textSizeMin,
          max: SettingsState.textSizeMax,
          step: SettingsState.textSizeStep,
        ),
        ChoiceTile<LabelAlignment>(
          leading: const Icon(Icons.format_align_left),
          title: l10n.textAlignTitle,
          value: s.labelAlignment.value,
          options: LabelAlignment.values,
          label: _alignmentLabel,
          onChanged: (alignment) => s.labelAlignment.value = alignment,
        ),
        if (AppearanceScope.of(context).accentAvailable)
          SettingSwitch(
            setting: s.accentColor,
            title: l10n.accentColor,
            subtitle: l10n.accentColorSubtitle,
          ),
        SettingSwitch(
          setting: s.terminalPrompt,
          title: l10n.terminalPrompt,
          subtitle: l10n.terminalPromptSubtitle,
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
        SettingsSectionHeader(title: l10n.sectionEffects),
        SettingSwitch(
          setting: s.glow,
          title: l10n.glow,
          subtitle: l10n.effectsDarkOnly,
        ),
        ChoiceTile<ScanlineLevel>(
          title: l10n.scanlines,
          value: s.scanlines.value,
          options: ScanlineLevel.values,
          label: _scanlineLabel,
          subtitle:
              '${_scanlineLabel(context, s.scanlines.value)} · '
              '${l10n.effectsDarkOnly}',
          onChanged: (level) => s.scanlines.value = level,
        ),
        SettingSwitch(
          setting: s.animations,
          title: l10n.animations,
          subtitle: l10n.animationsSubtitle,
        ),
      ],
    );
  }
}
