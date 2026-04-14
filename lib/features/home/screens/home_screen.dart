import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.homeState,
    required this.appListState,
    required this.settingsState,
    required this.onLaunch,
    required this.onReorderStart,
    required this.onReorderEnd,
    this.isActive = true,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;
  final SettingsState settingsState;
  final void Function(String packageName) onLaunch;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;
  final bool isActive;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _activeAppPackage;

  bool dismissActions() {
    if (_activeAppPackage == null) return false;
    setState(() => _activeAppPackage = null);
    return true;
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && oldWidget.isActive) {
      _activeAppPackage = null;
    }
  }

  List<ActionItem> _appActions(BuildContext context, PinnedApp app) {
    final l10n = AppLocalizations.of(context)!;
    return [
      ActionItem(
        icon: Icons.edit,
        label: l10n.actionRename,
        onTap: () async {
          final newLabel = await showRenameDialog(
            context: context,
            currentLabel: widget.appListState.displayLabelFor(
              app.packageName,
              app.label,
            ),
            originalLabel: app.label,
          );
          if (newLabel != null) {
            widget.appListState.setCustomLabel(app.packageName, newLabel);
          }
        },
      ),
      ActionItem(
        icon: Icons.remove_circle_outline,
        label: l10n.actionUnpin,
        onTap: () => widget.homeState.removeApp(app.packageName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.homeState.updateMaxApps(constraints.maxHeight);
          });
          return Align(
            alignment: Alignment.centerLeft,
            child: ListenableBuilder(
              listenable: Listenable.merge([
                widget.homeState,
                widget.appListState,
                widget.settingsState,
              ]),
              builder: (context, _) {
                final apps = widget.homeState.pinnedApps;
                if (apps.isEmpty && widget.settingsState.showHints) {
                  final l10n = AppLocalizations.of(context)!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${l10n.hintSwipeUp}\n'
                      '${widget.settingsState.tasksEnabled ? '${l10n.hintSwipeRight}\n' : ''}'
                      '${l10n.hintLongPress}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        letterSpacing: 1.5,
                        shadows: [],
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(140),
                      ),
                    ),
                  );
                }
                return ReorderableListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  buildDefaultDragHandles: false,
                  proxyDecorator: dragProxyDecorator,
                  onReorderStart: (_) => widget.onReorderStart(),
                  onReorderEnd: (_) => widget.onReorderEnd(),
                  onReorder: widget.homeState.reorderApps,
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    if (_activeAppPackage == app.packageName) {
                      return ActionRow(
                        key: ValueKey(app.packageName),
                        label: widget.appListState.displayLabelFor(
                          app.packageName,
                          app.label,
                        ),
                        actions: _appActions(context, app),
                        onClose: () => setState(() => _activeAppPackage = null),
                      );
                    }
                    return AppLabel(
                      key: ValueKey(app.packageName),
                      label: widget.appListState.displayLabelFor(
                        app.packageName,
                        app.label,
                      ),
                      onTap: () => widget.onLaunch(app.packageName),
                      onLongPress: () => setState(
                        () => _activeAppPackage =
                            _activeAppPackage == app.packageName
                            ? null
                            : app.packageName,
                      ),
                      trailing: ReorderableDelayedDragStartListener(
                        index: index,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 20),
                            child: const SizedBox(width: 24),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
