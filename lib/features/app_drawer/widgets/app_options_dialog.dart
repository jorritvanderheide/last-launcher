import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';

Future<void> showAppOptionsDialog({
  required BuildContext context,
  required AppInfo app,
  required AppListState appListState,
  required HomeState homeState,
  required VoidCallback onCloseDrawer,
}) {
  final isPinned = homeState.isPinned(app.packageName);

  return showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                appListState.displayLabel(app),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(
                  context: context,
                  app: app,
                  appListState: appListState,
                  homeState: homeState,
                );
              },
            ),
            if (isPinned)
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Remove from home'),
                onTap: () {
                  homeState.removeApp(app.packageName);
                  Navigator.pop(context);
                },
              )
            else
              ListTile(
                enabled: !homeState.isFull,
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Add to home'),
                onTap: homeState.isFull
                    ? null
                    : () {
                        homeState.addApp(
                          PinnedApp(
                            packageName: app.packageName,
                            label: app.label,
                            sortOrder: 0,
                          ),
                        );
                        Navigator.pop(context);
                        onCloseDrawer();
                      },
              ),
          ],
        ),
      );
    },
  );
}

Future<void> _showRenameDialog({
  required BuildContext context,
  required AppInfo app,
  required AppListState appListState,
  required HomeState homeState,
}) {
  final controller = TextEditingController(
    text: appListState.displayLabel(app),
  );

  return showDialog<void>(
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
            appListState.setCustomLabel(app.packageName, newLabel);
            homeState.renameApp(app.packageName, newLabel);
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
              appListState.setCustomLabel(app.packageName, newLabel);
              homeState.renameApp(app.packageName, newLabel);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
