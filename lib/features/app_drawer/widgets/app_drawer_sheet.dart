import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';
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
  final _textController = TextEditingController();

  bool get _searchOnly => widget.settingsState.searchOnly;
  bool get _autoKeyboard => _searchOnly || widget.settingsState.autoKeyboard;
  bool get _autoLaunch => _searchOnly || widget.settingsState.autoLaunch;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AppDrawerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      // Drawer just opened.
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      widget.isAtTop.value = true;
      if (_autoKeyboard) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      }
    } else if (!widget.isOpen && oldWidget.isOpen) {
      // Drawer just closed.
      _focusNode.unfocus();
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    widget.isAtTop.value = _scrollController.offset <= 0;
    if (_scrollController.offset > 0 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (_scrollController.offset <= 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onOverscroll(OverscrollNotification notification) {
    if (notification.overscroll > 0 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (notification.overscroll < 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onSearchChanged(String query) {
    widget.appListState.filter(query);
    if (_autoLaunch &&
        widget.appListState.query.isNotEmpty &&
        widget.appListState.hasSingleResult) {
      widget.onLaunch(widget.appListState.filteredApps.first.packageName);
    }
  }

  void _onSubmit() {
    if (widget.appListState.hasSingleResult) {
      widget.onLaunch(widget.appListState.filteredApps.first.packageName);
    } else if (widget.appListState.filteredApps.isEmpty) {
      widget.onCloseDrawer();
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
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: _onSearchChanged,
                  onSubmit: _onSubmit,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
                  child: NotificationListener<OverscrollNotification>(
                    onNotification: (notification) {
                      _onOverscroll(notification);
                      return false;
                    },
                    child: FadeOverflow(
                      child: ListenableBuilder(
                        listenable: widget.appListState,
                        builder: (context, _) {
                          final apps = widget.appListState.filteredApps;
                          return ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 32,
                            ),
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            final app = apps[index];
                            return AppLabel(
                              label: widget.appListState.displayLabel(app),
                              onTap: () => widget.onLaunch(app.packageName),
                              onLongPress: () => _onLongPress(context, app),
                            );
                          },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
