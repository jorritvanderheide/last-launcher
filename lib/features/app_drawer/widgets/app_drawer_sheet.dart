import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_list_tile.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_search_field.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppDrawerSheet extends StatefulWidget {
  const AppDrawerSheet({
    required this.appListState,
    required this.homeState,
    required this.settingsState,
    required this.isOpen,
    required this.onLaunch,
    required this.onCloseDrawer,
    required this.isAtTop,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final SettingsState settingsState;
  final bool isOpen;
  final void Function(String packageName) onLaunch;
  final VoidCallback onCloseDrawer;
  final ValueNotifier<bool> isAtTop;

  @override
  State<AppDrawerSheet> createState() => _AppDrawerSheetState();
}

class _AppDrawerSheetState extends State<AppDrawerSheet> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  bool _wasOpen = false;

  bool get _searchOnly => widget.settingsState.searchOnly;
  bool get _autoKeyboard => _searchOnly || widget.settingsState.autoKeyboard;
  bool get _autoLaunch => _searchOnly || widget.settingsState.autoLaunch;

  @override
  void initState() {
    super.initState();
    if (_autoLaunch) {
      widget.appListState.addListener(_onFilterChanged);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AppDrawerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !_wasOpen) {
      if (_autoKeyboard) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      }
    } else if (!widget.isOpen && _wasOpen) {
      _focusNode.unfocus();
    }
    _wasOpen = widget.isOpen;
  }

  @override
  void dispose() {
    if (_autoLaunch) {
      widget.appListState.removeListener(_onFilterChanged);
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    widget.isAtTop.value = _scrollController.offset <= 0;
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
    final colorScheme = Theme.of(context).colorScheme;

    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: AppSearchField(
                focusNode: _focusNode,
                onChanged: widget.appListState.filter,
                onSubmit: _onSubmit,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            if (_searchOnly)
              SliverFillRemaining(
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
              SliverFillRemaining(
                child: ListenableBuilder(
                  listenable: widget.appListState,
                  builder: (context, _) {
                    final apps = widget.appListState.filteredApps;
                    final keyboardHeight =
                        MediaQuery.viewInsetsOf(context).bottom;
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: keyboardHeight),
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        return AppListTile(
                          label: widget.appListState.displayLabel(app),
                          onTap: () => widget.onLaunch(app.packageName),
                          onLongPress: () => _onLongPress(context, app),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}
