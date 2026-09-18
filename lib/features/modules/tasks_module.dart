import 'package:flutter/widgets.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/tasks/screens/task_screen.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/screens/task_settings_screen.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

/// Task list panel. Owns its own [GlobalKey] so the shell can reach into
/// [TaskScreenState] to dismiss action rows on back-gesture / lifecycle
/// reset paths.
class TasksModule extends LauncherModule {
  TasksModule();

  final GlobalKey<TaskScreenState> _key = GlobalKey<TaskScreenState>();

  @override
  String get id => 'tasks';

  @override
  String displayName(BuildContext context) =>
      AppLocalizations.of(context)!.sectionTasks;

  @override
  String hintName(BuildContext context, ModuleSide side, ModuleDeps deps) =>
      AppLocalizations.of(context)!.panelTasks;

  @override
  Widget build(BuildContext context, LauncherModuleProps props) {
    return TaskScreen(
      key: _key,
      taskState: props.taskState,
      settingsState: props.settingsState,
      isVisible: props.isVisible,
      onReorderStart: props.onReorderStart,
      onReorderEnd: props.onReorderEnd,
      scrollLocked: props.scrollLocked,
      swipeRight: props.swipeRight,
    );
  }

  @override
  List<String> get storageKeys => TaskState.storageKeys;

  @override
  Widget settingsPage(ModuleDeps deps) =>
      TaskSettingsScreen(settingsState: deps.settingsState);

  @override
  bool dismissActions() => _key.currentState?.dismissActions() ?? false;
}
