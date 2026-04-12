import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/reorder_screen.dart';
import 'package:last_launcher/features/home/widgets/pinned_app_label.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.homeState,
    required this.appListState,
    required this.onLaunch,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;
  final void Function(String packageName) onLaunch;

  Future<void> _rename(BuildContext context, PinnedApp app) async {
    final newLabel = await showRenameDialog(
      context: context,
      currentLabel: app.displayLabel,
    );
    if (newLabel != null) {
      await homeState.renameApp(app.packageName, newLabel);
      appListState.setCustomLabel(app.packageName, newLabel);
    }
  }

  void _showPinnedAppOptions(BuildContext context, PinnedApp app) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  app.displayLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.swap_vert),
                title: const Text('Reorder apps'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      pageBuilder: (_, _, _) =>
                          ReorderScreen(homeState: homeState),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () async {
                  Navigator.pop(context);
                  await _rename(context, app);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Remove from home'),
                onTap: () {
                  homeState.removeApp(app.packageName);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              homeState.updateMaxApps(constraints.maxHeight);
            });
            return Align(
              alignment: Alignment.centerLeft,
              child: ListenableBuilder(
                listenable: homeState,
                builder: (context, _) {
                  final apps = homeState.pinnedApps;
                  if (apps.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Swipe up to search apps\n'
                        'Long press for settings',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: apps
                        .map(
                          (app) => PinnedAppLabel(
                            label: app.displayLabel,
                            onTap: () => onLaunch(app.packageName),
                            onLongPress: () =>
                                _showPinnedAppOptions(context, app),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
