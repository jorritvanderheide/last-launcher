import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

class WorkSettingsScreen extends StatelessWidget {
  const WorkSettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionWork,
      listenable: s,
      children: (context) => [
        SettingSwitch(
          setting: s.hidePersonalWhenWorkActive,
          title: l10n.hidePersonalWhenWorkActive,
          subtitle: l10n.hidePersonalWhenWorkActiveSubtitle,
        ),
        SettingSwitch(
          setting: s.showWorkAppDot,
          title: l10n.showWorkAppDot,
          subtitle: l10n.showWorkAppDotSubtitle,
          enabled: s.workAppDotAvailable,
          effective: s.workAppDotActive,
        ),
        SettingSwitch(
          setting: s.showWorkAppDotOnHome,
          title: l10n.showWorkAppDotOnHome,
          subtitle: l10n.showWorkAppDotOnHomeSubtitle,
          enabled: s.workAppDotActive,
          effective: s.workAppDotOnHomeActive,
          indent: true,
        ),
      ],
    );
  }
}
