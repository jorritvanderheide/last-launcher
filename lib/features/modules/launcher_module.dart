import 'package:flutter/widgets.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/features/modules/tasks_module.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';

/// A side panel that the user can pick for the left or right slot of home.
///
/// Adding a new panel: implement this interface, add an instance to
/// [launcherModules], and add the relevant `panelXxx` strings in app_en.arb.
/// No other site needs to be updated, settings included: a module with a
/// [settingsPage] gets its own row there while it's on either side of home.
abstract class LauncherModule {
  const LauncherModule();

  /// Stable, persisted identifier (do not localize). Stored in
  /// SharedPreferences as the panel-slot value.
  String get id;

  /// Title-case name shown in pickers and section headers.
  String displayName(BuildContext context);

  /// In-sentence form used inside hint strings; depending on the language
  /// this may be lowercase ("tasks") or the same as displayName.
  String hintName(BuildContext context);

  /// Build the panel widget. The shell passes layout/lifecycle props.
  Widget build(BuildContext context, LauncherModuleProps props);

  /// Keys this module keeps its own data under (not its settings, which
  /// live with the rest). Backups list them per module, so the data can be
  /// left out of a backup or a restore. Default: none.
  List<String> get storageKeys => const [];

  /// This module's own settings page. Default: none.
  Widget? settingsPage(SettingsState settings) => null;

  /// Hook for back-gesture / lifecycle reset paths. Return true if the
  /// module consumed the action and the shell should not continue
  /// dismissing (e.g. closing drawer, snapping to home). Default: false.
  bool dismissActions() => false;
}

/// Props the shell passes to [LauncherModule.build]. Module-specific deps
/// are accessed through the relevant state object.
class LauncherModuleProps {
  const LauncherModuleProps({
    required this.taskState,
    required this.settingsState,
    required this.isVisible,
    required this.scrollLocked,
    required this.swipeRight,
    required this.onReorderStart,
    required this.onReorderEnd,
  });

  final TaskState taskState;
  final SettingsState settingsState;
  final bool isVisible;
  final bool scrollLocked;
  final bool swipeRight;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;
}

/// Single source of truth for the list of selectable modules. Order here is
/// the order shown in the settings picker.
final List<LauncherModule> launcherModules = <LauncherModule>[
  const NoneModule(),
  TasksModule(),
];

/// Resolve a persisted id to a module, falling back to [NoneModule].
LauncherModule moduleById(String? id) {
  for (final m in launcherModules) {
    if (m.id == id) return m;
  }
  return const NoneModule();
}
