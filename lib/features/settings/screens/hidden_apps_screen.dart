import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class HiddenAppsScreen extends StatefulWidget {
  const HiddenAppsScreen({
    required this.appListState,
    required this.homeState,
    required this.onLaunch,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final void Function(String packageName) onLaunch;

  @override
  State<HiddenAppsScreen> createState() => _HiddenAppsScreenState();
}

class _HiddenAppsScreenState extends State<HiddenAppsScreen> {
  String? _activeAppPackage;

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    return [
      ActionItem(
        icon: Icons.edit,
        label: 'Rename',
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
        label: 'Unhide',
        onTap: () => widget.appListState.unhideApp(app.packageName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden apps'),
      ),
      body: ListenableBuilder(
          listenable: widget.appListState,
          builder: (context, _) {
            final apps = widget.appListState.hiddenApps;
            if (apps.isEmpty) {
              return Center(
                child: Text(
                  'No hidden apps',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              );
            }
            return FadeOverflow(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: 32,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  if (_activeAppPackage == app.packageName) {
                    return ActionRow(
                      label: widget.appListState.displayLabel(app),
                      actions: _appActions(context, app),
                      onClose: () =>
                          setState(() => _activeAppPackage = null),
                    );
                  }
                  return AppLabel(
                    label: widget.appListState.displayLabel(app),
                    onTap: () => widget.onLaunch(app.packageName),
                    onLongPress: () => setState(() =>
                        _activeAppPackage =
                            _activeAppPackage == app.packageName
                                ? null
                                : app.packageName),
                  );
                },
              ),
            );
          },
        ),
    );
  }
}
