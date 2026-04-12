import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_list_tile.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_search_field.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppDrawerScreen extends StatefulWidget {
  const AppDrawerScreen({
    required this.appListState,
    required this.homeState,
    required this.settingsState,
    required this.onLaunch,
    required this.onCloseDrawer,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final SettingsState settingsState;
  final void Function(String packageName) onLaunch;
  final VoidCallback onCloseDrawer;

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  bool _wasAtTop = true;

  bool get _searchOnly => widget.settingsState.searchOnly;
  bool get _autoKeyboard => _searchOnly || widget.settingsState.autoKeyboard;
  bool get _autoLaunch => _searchOnly || widget.settingsState.autoLaunch;

  @override
  void initState() {
    super.initState();
    if (_autoKeyboard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
    if (_autoLaunch) {
      widget.appListState.addListener(_onFilterChanged);
    }
  }

  @override
  void dispose() {
    if (_autoLaunch) {
      widget.appListState.removeListener(_onFilterChanged);
    }
    widget.appListState.clearFilter();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    final state = widget.appListState;
    if (state.lastChangeWasFilter &&
        state.query.isNotEmpty &&
        state.hasSingleResult) {
      widget.onLaunch(state.filteredApps.first.packageName);
    }
  }

  void _onSubmit() {
    if (widget.appListState.hasSingleResult) {
      widget.onLaunch(widget.appListState.filteredApps.first.packageName);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _wasAtTop = notification.metrics.pixels == 0;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      final offset = notification.metrics.pixels;

      if (delta > 0 && offset > 0 && _focusNode.hasFocus) {
        _focusNode.unfocus();
      } else if (offset == 0 && !_focusNode.hasFocus && _autoKeyboard) {
        _focusNode.requestFocus();
      }
    }

    if (notification is OverscrollNotification) {
      if (notification.overscroll < -10 && _wasAtTop) {
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
            const SizedBox(height: 24),
            if (_searchOnly)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy > 100) {
                      widget.onCloseDrawer();
                    }
                  },
                ),
              )
            else
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
