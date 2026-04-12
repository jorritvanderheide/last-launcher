import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';

class ReorderScreen extends StatelessWidget {
  const ReorderScreen({
    required this.homeState,
    required this.appListState,
    super.key,
  });

  final HomeState homeState;
  final AppListState appListState;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontSize: AppLabel.fontSize);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ListenableBuilder(
                listenable: Listenable.merge([homeState, appListState]),
                builder: (context, _) {
                  final apps = homeState.pinnedApps;
                  return ReorderableListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, _, _) => child,
                    onReorder: homeState.reorderApps,
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return ReorderableDragStartListener(
                        key: ValueKey(app.packageName),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: AppLabel.verticalPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appListState.displayLabelFor(
                                    app.packageName,
                                    app.label,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle,
                                ),
                              ),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              left: 4,
              child: BackButton(onPressed: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }
}
