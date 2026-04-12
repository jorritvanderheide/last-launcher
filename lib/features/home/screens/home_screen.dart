import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/reorder_screen.dart';
import 'package:last_launcher/features/home/widgets/pinned_app_label.dart';
import 'package:last_launcher/shared/data/models.dart';

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
                    MaterialPageRoute<void>(
                      builder: (_) => ReorderScreen(homeState: homeState),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(context, app);
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

  void _showRenameDialog(BuildContext context, PinnedApp app) {
    final controller = TextEditingController(text: app.displayLabel);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'App name'),
            onSubmitted: (_) {
              final newLabel = controller.text.trim();
              homeState.renameApp(app.packageName, newLabel);
              appListState.setCustomLabel(app.packageName, newLabel);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newLabel = controller.text.trim();
                homeState.renameApp(app.packageName, newLabel);
                appListState.setCustomLabel(app.packageName, newLabel);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            homeState.updateMaxApps(constraints.maxHeight);
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
