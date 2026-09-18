import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/modules/launch_app_module.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/features/modules/tasks_module.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/models.dart';

enum ModuleSide { left, right }

/// The launcher state a module can see outside its own panel: in the hints
/// on home and on its settings page.
class ModuleDeps {
  const ModuleDeps({required this.settingsState, required this.appListState});

  final SettingsState settingsState;
  final AppListState appListState;
}

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

  /// Shown next to the module's row in settings.
  IconData get icon => Icons.extension_outlined;

  /// In-sentence form used inside hint strings, as seen from [side];
  /// depending on the language this may be lowercase ("tasks") or the same
  /// as displayName.
  String hintName(BuildContext context, ModuleSide side, ModuleDeps deps);

  /// Build the panel widget. The shell passes layout/lifecycle props.
  Widget build(BuildContext context, LauncherModuleProps props);

  /// Keys this module keeps its own data under (not its settings, which
  /// live with the rest). Backups list them per module, so the data can be
  /// left out of a backup or a restore. Default: none.
  List<String> get storageKeys => const [];

  /// Whether the module can sit on both sides of home at once. Not for a
  /// module whose panel keeps state of its own, which would then exist twice.
  /// Default: no.
  bool get allowsBothSides => false;

  /// Called when a swipe comes to rest on this module's [side]. Returns
  /// whether to stay there: a module that acts rather than shows something
  /// returns false and the launcher goes straight back to home. [launch]
  /// opens an app. Default: stay.
  bool arrive(ModuleSide side, ModuleDeps deps, ValueChanged<AppInfo> launch) =>
      true;

  /// This module's own settings page. Default: none.
  Widget? settingsPage(ModuleDeps deps) => null;

  /// Hook for back-gesture / lifecycle reset paths. Return true if the
  /// module consumed the action and the shell should not continue
  /// dismissing (e.g. closing drawer, snapping to home). Default: false.
  bool dismissActions() => false;
}

/// Props the shell passes to [LauncherModule.build]. Module-specific deps
/// are accessed through the relevant state object.
class LauncherModuleProps {
  const LauncherModuleProps({
    required this.deps,
    required this.taskState,
    required this.side,
    required this.isVisible,
    required this.scrollLocked,
    required this.onReorderStart,
    required this.onReorderEnd,
  });

  final ModuleDeps deps;
  final TaskState taskState;
  final ModuleSide side;
  final bool isVisible;
  final bool scrollLocked;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;

  SettingsState get settingsState => deps.settingsState;

  /// The panel on the left is reached by swiping right, and vice versa.
  bool get swipeRight => side == ModuleSide.left;
}

/// Single source of truth for the list of selectable modules. Order here is
/// the order shown in the settings picker.
final List<LauncherModule> launcherModules = <LauncherModule>[
  const NoneModule(),
  TasksModule(),
  const LaunchAppModule(),
];

/// Resolve a persisted id to a module, falling back to [NoneModule].
LauncherModule moduleById(String? id) {
  for (final m in launcherModules) {
    if (m.id == id) return m;
  }
  return const NoneModule();
}
