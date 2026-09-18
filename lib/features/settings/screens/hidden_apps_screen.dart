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
  final void Function(String packageName, {bool isWorkApp}) onLaunch;
  final void Function(String packageName) onOpenAppInfo;

  @override
  State<HiddenAppsScreen> createState() => _HiddenAppsScreenState();
}

class _HiddenAppsScreenState extends State<HiddenAppsScreen> {
  String? _activeAppKey;
  String _appKey(AppInfo app) => '${app.packageName}|${app.isWorkApp}';

  Widget _withWorkDot(Widget child, AppInfo app) {
    if (!app.isWorkApp || !widget.settingsState.workAppDotActive) return child;
    final dotColor = Theme.of(
      context,
    ).textTheme.titleLarge?.color?.withAlpha((0.6 * 255).round());
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: -5,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Icon(Icons.circle, size: 10, color: dotColor),
          ),
        ),
      ],
    );
  }

  late final Listenable _mergedState = Listenable.merge([
    widget.appListState,
    widget.settingsState,
    widget.homeState,
  ]);

  List<AppInfo> _hiddenListItems() {
    final hidden = widget.appListState.hiddenApps;
    List<AppInfo> result;
    if (!widget.settingsState.hidePinnedFromDrawer.value) {
      result = hidden;
    } else {
      final hiddenKeys = hidden.map(_appKey).toSet();
      result = widget.appListState.allApps.where((app) {
        if (hiddenKeys.contains(_appKey(app))) return true;
        if (widget.homeState.isPinned(
          app.packageName,
          isWorkApp: app.isWorkApp,
        )) {
          return true;
        }
        return false;
      }).toList();
    }
    if (widget.settingsState.hidePersonalWhenWorkActive.value &&
        widget.appListState.allApps.any((a) => a.isWorkApp)) {
      result = result.where((app) => app.isWorkApp).toList();
    }
    return result;
  }

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;
    final isHidden = widget.appListState.isHidden(
      app.packageName,
      isWorkApp: app.isWorkApp,
    );
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
            widget.appListState.setCustomLabel(
              app.packageName,
              newLabel,
              isWorkApp: app.isWorkApp,
            );
          }
        },
      ),
      if (isHidden)
        ActionItem(
          icon: Icons.visibility,
          label: l10n.actionUnhide,
          onTap: () => widget.appListState.unhideApp(
            app.packageName,
            isWorkApp: app.isWorkApp,
          ),
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
        listenable: _mergedState,
        builder: (context, _) {
          final apps = _hiddenListItems();
          if (apps.isEmpty) {
            if (!widget.settingsState.showHints.value) {
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
                  fontSize: AppLabel.fontSizeOf(context),
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(130),
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
                final key = _appKey(app);
                if (_activeAppKey == key) {
                  return _withWorkDot(
                    ActionRow(
                      label: widget.appListState.displayLabel(app),
                      actions: _appActions(context, app),
                      onClose: () => setState(() => _activeAppKey = null),
                    ),
                    app,
                  );
                }
                return _withWorkDot(
                  AppLabel(
                    key: ValueKey(key),
                    label: widget.appListState.displayLabel(app),
                    onTap: () => widget.onLaunch(
                      app.packageName,
                      isWorkApp: app.isWorkApp,
                    ),
                    onLongPress: () => setState(
                      () => _activeAppKey = _activeAppKey == key ? null : key,
                    ),
                  ),
                  app,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
