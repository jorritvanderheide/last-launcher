import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.homeState,
    required this.appListState,
    required this.settingsState,
    required this.onLaunch,
    required this.onReorderStart,
    required this.onReorderEnd,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;
  final SettingsState settingsState;
  final void Function(String packageName) onLaunch;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;

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
                listenable: Listenable.merge([homeState, appListState, settingsState]),
                builder: (context, _) {
                  final apps = homeState.pinnedApps;
                  if (apps.isEmpty && settingsState.showHints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Swipe up to search apps\n'
                        '${settingsState.tasksEnabled ? 'Swipe right for tasks\n' : ''}'
                        'Long press for settings',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  return ReorderableListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, _, _) =>
                        Material(color: Colors.transparent, child: child),
                    onReorderStart: (_) => onReorderStart(),
                    onReorderEnd: (_) => onReorderEnd(),
                    onReorder: homeState.reorderApps,
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return AppLabel(
                        key: ValueKey(app.packageName),
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
                        trailing: ReorderableDelayedDragStartListener(
                          index: index,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 20,
                              ),
                              child: Icon(
                                Icons.drag_handle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(60),
                              ),
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
      ),
    );
  }
}
