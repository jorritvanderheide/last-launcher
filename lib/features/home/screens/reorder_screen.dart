import 'package:flutter/material.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/widgets/pinned_app_label.dart';

class ReorderScreen extends StatelessWidget {
  const ReorderScreen({required this.homeState, super.key});

  final HomeState homeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder apps')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListenableBuilder(
            listenable: homeState,
            builder: (context, _) {
              final apps = homeState.pinnedApps;
              return ReorderableListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                onReorder: homeState.reorderApps,
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return Padding(
                    key: ValueKey(app.packageName),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: PinnedAppLabel.verticalPadding,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            app.displayLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontSize: PinnedAppLabel.fontSize),
                          ),
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
