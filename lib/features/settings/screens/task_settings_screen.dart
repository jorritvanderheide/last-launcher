import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

class TaskSettingsScreen extends StatelessWidget {
  const TaskSettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionTasks,
      listenable: s,
      children: (context) => [
        SettingSwitch(
          setting: s.autoKeyboardTasks,
          title: l10n.autoShowKeyboard,
          subtitle: l10n.autoShowKeyboardTasksSubtitle,
        ),
        SettingSwitch(
          setting: s.removeOnComplete,
          title: l10n.removeOnComplete,
          subtitle: l10n.removeOnCompleteSubtitle,
        ),
        SettingSwitch(
          setting: s.clearCompletedDaily,
          title: l10n.clearCompletedDaily,
          subtitle: l10n.clearCompletedDailySubtitle,
        ),
      ],
    );
  }
}
