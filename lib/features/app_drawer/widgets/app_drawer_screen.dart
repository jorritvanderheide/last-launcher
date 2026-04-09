import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_list_tile.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_search_field.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppDrawerScreen extends StatefulWidget {
  const AppDrawerScreen({
    required this.appListState,
    required this.homeState,
    required this.onLaunch,
    required this.onCloseDrawer,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final void Function(String packageName) onLaunch;
  final VoidCallback onCloseDrawer;

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Autofocus after the route transition completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.appListState.clearFilter();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (widget.appListState.hasSingleResult) {
      widget.onLaunch(widget.appListState.filteredApps.first.packageName);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      final offset = notification.metrics.pixels;

      if (delta > 0 && offset > 0 && _focusNode.hasFocus) {
        _focusNode.unfocus();
      } else if (offset == 0 && !_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    }

    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0) {
        widget.onCloseDrawer();
      }
    }

    return false;
  }

  void _onLongPress(BuildContext context, AppInfo app) {
    showAppOptionsDialog(
      context: context,
      app: app,
      appListState: widget.appListState,
      homeState: widget.homeState,
      onCloseDrawer: widget.onCloseDrawer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppSearchField(
              focusNode: _focusNode,
              onChanged: widget.appListState.filter,
              onSubmit: _onSubmit,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.appListState,
                builder: (context, _) {
                  final apps = widget.appListState.filteredApps;
                  return NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        return AppListTile(
                          label: widget.appListState.displayLabel(app),
                          onTap: () => widget.onLaunch(app.packageName),
                          onLongPress: () => _onLongPress(context, app),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
