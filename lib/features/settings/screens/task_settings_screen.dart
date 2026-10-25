import 'package:flutter/material.dart';
import 'package:last_launcher/features/modules/tasks/synced_tasks.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

class TaskSettingsScreen extends StatelessWidget {
  const TaskSettingsScreen({
    required this.settingsState,
    required this.taskState,
    super.key,
  });

  final SettingsState settingsState;
  final TaskState taskState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionTasks,
      listenable: s,
      children: (context) {
        final source = parseTaskSource(s.taskSource.value);
        return [
          _TaskSourceTile(settingsState: s, taskState: taskState),
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
          if (source != null)
            SettingSwitch(
              setting: s.deleteSyncedDone,
              title: l10n.deleteSyncedDone,
              subtitle: l10n.deleteSyncedDoneSubtitle(
                taskAppNames[source.authority]!,
              ),
            ),
        ];
      },
    );
  }
}

/// Where the tasks come from: this phone, or a list in a tasks app. Choosing
/// a list asks for the tasks app's permission first.
class _TaskSourceTile extends StatelessWidget {
  const _TaskSourceTile({required this.settingsState, required this.taskState});

  final SettingsState settingsState;
  final TaskState taskState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final source = parseTaskSource(settingsState.taskSource.value);
    return ListTile(
      title: Text(l10n.taskSourceTitle),
      subtitle: source == null
          ? Text(l10n.taskSourcePhone)
          : FutureBuilder(
              future: taskState.sourceListName(),
              builder: (context, name) {
                final app = taskAppNames[source.authority]!;
                final list = name.data;
                return Text(
                  list == null ? app : l10n.taskSourceList(list, app),
                );
              },
            ),
      onTap: () => _choose(context),
    );
  }

  /// Prefixes a choice that first asks for a tasks app's permission.
  static const _allow = 'allow:';

  Future<void> _choose(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final apps = await taskState.taskApps();
    final options = <(String, String)>[('', l10n.taskSourcePhone)];
    final notes = <String>[if (apps.isEmpty) l10n.taskSourceNoApp];
    for (final app in apps) {
      // Only an app you pick is asked for its permission, and then its
      // lists are offered.
      if (!app.granted) {
        options.add(('$_allow${app.authority}', l10n.taskSourceApp(app.label)));
        continue;
      }
      final lists = await taskState.taskLists(app);
      if (lists.isEmpty) notes.add(l10n.taskSourceNoLists(app.label));
      for (final list in lists) {
        options.add((
          storeTaskSource((authority: app.authority, listId: list.id)),
          l10n.taskSourceList(list.name, app.label),
        ));
      }
    }
    if (!context.mounted) return;
    final picked = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.taskSourceTitle),
        children: [
          RadioGroup<String>(
            groupValue: settingsState.taskSource.value ?? '',
            onChanged: (option) => Navigator.pop(context, option),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (value, label) in options)
                  RadioListTile<String>(value: value, title: Text(label)),
              ],
            ),
          ),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Text(note),
            ),
        ],
      ),
    );
    if (picked == null) return;
    if (picked.startsWith(_allow)) {
      final allowed = await taskState.askPermission(
        picked.substring(_allow.length),
      );
      if (allowed && context.mounted) await _choose(context);
      return;
    }
    settingsState.taskSource.value = picked.isEmpty ? null : picked;
    // The same list again, perhaps just allowed: read it anew.
    await taskState.refresh();
  }
}
