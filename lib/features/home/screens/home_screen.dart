import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.homeState,
    required this.appListState,
    required this.onLaunch,
    required this.tasksEnabled,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;
  final void Function(String packageName) onLaunch;
  final bool tasksEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            homeState.updateMaxApps(constraints.maxHeight);
            return Align(
              alignment: Alignment.centerLeft,
              child: ListenableBuilder(
                listenable: Listenable.merge([homeState, appListState]),
                builder: (context, _) {
                  final apps = homeState.pinnedApps;
                  if (apps.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Swipe up to search apps\n'
                        '${tasksEnabled ? 'Swipe right for tasks\n' : ''}'
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
                          (app) => AppLabel(
                            label: appListState.displayLabelFor(
                              app.packageName,
                              app.label,
                            ),
                            onTap: () => onLaunch(app.packageName),
                            onLongPress: () => showAppOptionsDialog(
                              context: context,
                              app: AppInfo(
                                packageName: app.packageName,
                                label: app.label,
                              ),
                              appListState: appListState,
                              homeState: homeState,
                            ),
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
