import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';

class TaskSettingsScreen extends StatelessWidget {
  const TaskSettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sectionTasks)),
      body: ListenableBuilder(
        listenable: settingsState,
        builder: (context, _) {
          return FadeOverflow(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SwitchListTile(
                  title: Text(l10n.autoShowKeyboard),
                  subtitle: Text(l10n.autoShowKeyboardTasksSubtitle),
                  value: settingsState.autoKeyboardTasks,
                  onChanged: settingsState.setAutoKeyboardTasks,
                ),
                SwitchListTile(
                  title: Text(l10n.removeOnComplete),
                  subtitle: Text(l10n.removeOnCompleteSubtitle),
                  value: settingsState.removeOnComplete,
                  onChanged: settingsState.setRemoveOnComplete,
                ),
                SwitchListTile(
                  title: Text(l10n.clearCompletedDaily),
                  subtitle: Text(l10n.clearCompletedDailySubtitle),
                  value: settingsState.clearCompletedDaily,
                  onChanged: settingsState.setClearCompletedDaily,
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
