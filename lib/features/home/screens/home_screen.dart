import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.homeState,
    required this.appListState,
    required this.settingsState,
    required this.moduleDeps,
    required this.onLaunch,
    required this.onReorderStart,
    required this.onReorderEnd,
    this.isActive = true,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;
  final SettingsState settingsState;

  /// For the modules' hints ("Swipe right for Spotify").
  final ModuleDeps moduleDeps;
  final void Function(String packageName, {bool isWorkApp, String? shortcutId})
  onLaunch;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;
  final bool isActive;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _activeAppPackage;
  late final Listenable _mergedState = Listenable.merge([
    widget.homeState,
    widget.appListState,
    widget.settingsState,
  ]);

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
              app.key,
              app.label,
            ),
            originalLabel: app.label,
          );
          if (newLabel != null) {
            widget.appListState.setCustomLabel(app.key, newLabel);
          }
        },
      ),
      ActionItem(
        icon: Icons.remove_circle_outline,
        label: l10n.actionUnpin,
        onTap: () => widget.homeState.removeApp(app.key),
      ),
    ];
  }

  Widget _withWorkDot(Widget child, PinnedApp app) {
    final onRight = AppearanceScope.of(context).markersOnRight;
    if (!app.isWorkApp || !widget.settingsState.workAppDotOnHomeActive) {
      return child;
    }
    final dotColor = Theme.of(
      context,
    ).textTheme.titleLarge?.color?.withAlpha((0.6 * 255).round());
    return Stack(
      key: child.key,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: onRight ? null : -5,
          right: onRight ? -5 : null,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Icon(Icons.circle, size: 10, color: dotColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // updateMaxApps is a pure setter (no notifyListeners), so calling
          // it inside build is safe and avoids the postFrameCallback queue.
          widget.homeState.updateMaxApps(
            constraints.maxHeight,
            itemHeight: AppLabel.itemHeightFor(AppLabel.fontSizeOf(context)),
          );
          return Align(
            alignment: Alignment(AppearanceScope.of(context).labelAlignX, 0),
            child: ListenableBuilder(
              listenable: _mergedState,
              builder: (context, _) {
                final workPackages = widget.appListState.workPackages;
                final apps = widget.homeState.pinnedApps
                    .where(
                      (app) =>
                          !app.isWorkApp ||
                          workPackages.contains(app.packageName),
                    )
                    .toList();
                if (widget.settingsState.hidePersonalWhenWorkActive.value &&
                    workPackages.isNotEmpty) {
                  apps.removeWhere((app) => !app.isWorkApp);
                }
                if (apps.isEmpty && widget.settingsState.showHints.value) {
                  final l10n = AppLocalizations.of(context)!;
                  final left = widget.settingsState.leftPanel.value;
                  final right = widget.settingsState.rightPanel.value;
                  final style = Theme.of(context).textTheme.titleLarge
                      ?.copyWith(
                        fontSize: AppLabel.fontSizeOf(context),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(130),
                      );
                  final children = <Widget>[];
                  void addHint(String text, {VoidCallback? onTap}) {
                    final padded = Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: AppLabel.verticalPadding,
                      ),
                      child: Text(
                        text,
                        style: style,
                        textAlign: AppearanceScope.of(context).labelAlign,
                      ),
                    );
                    children.add(
                      onTap != null
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onTap,
                              child: padded,
                            )
                          : padded,
                    );
                  }

                  addHint(l10n.hintSwipeUp);
                  final deps = widget.moduleDeps;
                  if (left is! NoneModule) {
                    addHint(
                      l10n.hintSwipeRightFor(
                        left.hintName(context, ModuleSide.left, deps),
                      ),
                    );
                  }
                  if (right is! NoneModule) {
                    addHint(
                      l10n.hintSwipeLeftFor(
                        right.hintName(context, ModuleSide.right, deps),
                      ),
                    );
                  }
                  addHint(l10n.hintLongPress);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: AppearanceScope.of(
                      context,
                    ).labelCrossAxis,
                    children: children,
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
                    final showHandles = _activeAppPackage != null;
                    final handle = showHandles
                        ? dragHandle(context, index)
                        : null;
                    final appKey = app.key;
                    if (_activeAppPackage == appKey) {
                      return _withWorkDot(
                        ActionRow(
                          key: ValueKey(appKey),
                          label: widget.appListState.displayLabelFor(
                            app.key,
                            app.label,
                          ),
                          actions: _appActions(context, app),
                          onClose: () =>
                              setState(() => _activeAppPackage = null),
                          leading: handle,
                        ),
                        app,
                      );
                    }
                    return _withWorkDot(
                      AppLabel(
                        key: ValueKey(appKey),
                        label: widget.appListState.displayLabelFor(
                          app.key,
                          app.label,
                        ),
                        onTap: () => widget.onLaunch(
                          app.packageName,
                          isWorkApp: app.isWorkApp,
                          shortcutId: app.shortcutId,
                        ),
                        onLongPress: widget.settingsState.locked.value
                            ? () {}
                            : () => setState(
                                () => _activeAppPackage =
                                    _activeAppPackage == appKey ? null : appKey,
                              ),
                        leading: handle,
                      ),
                      app,
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
