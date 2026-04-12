import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

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
              onTap: () async {
                Navigator.pop(context);
                await renameApp(
                  context: context,
                  packageName: app.packageName,
                  currentLabel: appListState.displayLabel(app),
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
