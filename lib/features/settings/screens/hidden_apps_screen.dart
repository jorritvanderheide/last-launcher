import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class HiddenAppsScreen extends StatefulWidget {
  const HiddenAppsScreen({
    required this.appListState,
    required this.homeState,
    required this.settingsState,
    required this.onLaunch,
    required this.onOpenAppInfo,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final SettingsState settingsState;
  final void Function(String packageName) onLaunch;
  final void Function(String packageName) onOpenAppInfo;

  @override
  State<HiddenAppsScreen> createState() => _HiddenAppsScreenState();
}

class _HiddenAppsScreenState extends State<HiddenAppsScreen> {
  String? _activeAppPackage;

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;
    return [
      ActionItem(
        icon: Icons.edit,
        label: l10n.actionRename,
        onTap: () async {
          final newLabel = await showRenameDialog(
            context: context,
            currentLabel: widget.appListState.displayLabel(app),
            originalLabel: app.label,
          );
          if (newLabel != null) {
            widget.appListState.setCustomLabel(app.packageName, newLabel);
          }
        },
      ),
      ActionItem(
        icon: Icons.visibility,
        label: l10n.actionUnhide,
        onTap: () => widget.appListState.unhideApp(app.packageName),
      ),
      ActionItem(
        icon: Icons.info_outline,
        label: l10n.actionAppInfo,
        onTap: () => widget.onOpenAppInfo(app.packageName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.hiddenApps)),
      body: ListenableBuilder(
        listenable: Listenable.merge([widget.appListState, widget.settingsState]),
        builder: (context, _) {
          final apps = widget.appListState.hiddenApps;
          if (apps.isEmpty) {
            if (!widget.settingsState.showHints) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 8 + AppLabel.verticalPadding,
              ),
              child: Text(
                AppLocalizations.of(context)!.noHiddenApps,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppLabel.fontSize,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
                ),
              ),
            );
          }
          return FadeOverflow(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                if (_activeAppPackage == app.packageName) {
                  return ActionRow(
                    label: widget.appListState.displayLabel(app),
                    actions: _appActions(context, app),
                    onClose: () => setState(() => _activeAppPackage = null),
                  );
                }
                return AppLabel(
                  label: widget.appListState.displayLabel(app),
                  onTap: () => widget.onLaunch(app.packageName),
                  onLongPress: () => setState(
                    () =>
                        _activeAppPackage = _activeAppPackage == app.packageName
                        ? null
                        : app.packageName,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
