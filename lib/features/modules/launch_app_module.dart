import 'package:flutter/material.dart';
import 'package:last_launcher/features/modules/launch_app/launch_app_settings_screen.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';

/// Opens a chosen app when swiped to, instead of showing a panel. Can sit on
/// both sides, with an app of its own for each.
class LaunchAppModule extends LauncherModule {
  const LaunchAppModule();

  static const moduleId = 'launch_app';

  @override
  String get id => moduleId;

  @override
  bool get allowsBothSides => true;

  @override
  IconData get icon => Icons.launch;

  @override
  String displayName(BuildContext context) =>
      AppLocalizations.of(context)!.panelLaunchApp;

  /// The chosen app's name ("Swipe right for Spotify"), or a generic one
  /// while none is chosen.
  @override
  String hintName(BuildContext context, ModuleSide side, ModuleDeps deps) {
    final app = appFor(side, deps);
    return app == null
        ? AppLocalizations.of(context)!.panelLaunchAppHint
        : deps.appListState.displayLabel(app);
  }

  /// The entry chosen for [side], if it's still around: an uninstalled app,
  /// or one in a paused work profile, counts as none.
  static AppInfo? appFor(ModuleSide side, ModuleDeps deps) {
    final key = deps.settingsState.launchApp(side).value;
    if (key == null) return null;
    for (final app in deps.appListState.allApps) {
      if (app.key == key) return app;
    }
    return null;
  }

  /// Launches the chosen app and goes back home; with none chosen, stays to
  /// offer choosing one.
  @override
  bool arrive(ModuleSide side, ModuleDeps deps, ValueChanged<AppInfo> launch) {
    final app = appFor(side, deps);
    if (app == null) return true;
    launch(app);
    return false;
  }

  @override
  Widget build(BuildContext context, LauncherModuleProps props) =>
      _LaunchAppPanel(module: this, props: props);

  @override
  Widget settingsPage(ModuleDeps deps) => LaunchAppSettingsScreen(deps: deps);
}

/// Blank while an app is chosen (the swipe launches it before this is ever
/// settled on); otherwise an invitation to choose one.
class _LaunchAppPanel extends StatelessWidget {
  const _LaunchAppPanel({required this.module, required this.props});

  final LaunchAppModule module;
  final LauncherModuleProps props;

  @override
  Widget build(BuildContext context) {
    final deps = props.deps;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListenableBuilder(
        listenable: Listenable.merge([deps.settingsState, deps.appListState]),
        builder: (context, _) {
          if (LaunchAppModule.appFor(props.side, deps) != null) {
            return const SizedBox.expand();
          }
          final appearance = AppearanceScope.of(context);
          return Align(
            alignment: Alignment(appearance.labelAlignX, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => pushSettingsPage(context, module.settingsPage(deps)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: AppLabel.verticalPadding,
                ),
                child: Text(
                  AppLocalizations.of(context)!.launchAppChoose,
                  textAlign: appearance.labelAlign,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppLabel.fontSizeOf(context),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(130),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
