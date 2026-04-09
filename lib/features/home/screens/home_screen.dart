import 'package:flutter/material.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/widgets/pinned_app_label.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.appChannel,
    required this.homeState,
    required this.settingsState,
    required this.onLaunch,
    super.key,
  });

  final AppChannel appChannel;
  final HomeState homeState;
  final SettingsState settingsState;
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
              homeState.renameApp(app.packageName, controller.text.trim());
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
                homeState.renameApp(app.packageName, controller.text.trim());
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SettingsScreen(settingsState: settingsState),
            ),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListenableBuilder(
                listenable: homeState,
                builder: (context, _) {
                  final apps = homeState.pinnedApps;
                  if (apps.isEmpty) {
                    return Text(
                      'Swipe up to search apps\nLong press for settings',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100),
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
        ),
      ),
    );
  }
}
