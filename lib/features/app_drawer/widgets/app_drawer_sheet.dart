import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';
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
    required this.onOpenAppInfo,
    required this.onCloseDrawer,
    required this.isAtTop,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final SettingsState settingsState;
  final bool isOpen;
  final void Function(String packageName) onLaunch;
  final void Function(String packageName) onOpenAppInfo;
  final VoidCallback onCloseDrawer;
  final ValueNotifier<bool> isAtTop;

  @override
  State<AppDrawerSheet> createState() => _AppDrawerSheetState();
}

class _AppDrawerSheetState extends State<AppDrawerSheet> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  String? _activeAppPackage;

  late final Listenable _mergedState = Listenable.merge([
    widget.appListState,
    widget.settingsState,
    widget.homeState,
  ]);

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
      // Drawer just opened (post-snap, not during drag).
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      widget.isAtTop.value = true;
      if (_autoKeyboard) {
        _requestKeyboardReliably();
      }
    } else if (!widget.isOpen && oldWidget.isOpen) {
      // Drawer just closed.
      _focusNode.unfocus();
      _textController.clear();
      _activeAppPackage = null;
    }
  }

  void _requestKeyboardReliably() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      // After app switch or device unlock the platform sometimes grants
      // focus but suppresses the keyboard. Detect that and bounce focus.
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted || !_focusNode.hasFocus) return;
        final insets = MediaQuery.viewInsetsOf(context);
        if (insets.bottom == 0) {
          _focusNode.unfocus();
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) _focusNode.requestFocus();
          });
        }
      });
    });
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
    if (_activeAppPackage != null) setState(() => _activeAppPackage = null);
    widget.isAtTop.value = _scrollController.offset <= 0;
    if (_scrollController.offset > 20 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (_scrollController.offset <= 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onOverscroll(OverscrollNotification notification) {
    // Only hide keyboard on downward overscroll (scrolling past bottom).
    if (notification.overscroll > 0 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  List<AppInfo> get _visibleApps {
    final query = widget.appListState.query;
    final searching = query.isNotEmpty;
    final expandSearch =
        searching && widget.settingsState.includeHiddenInSearch;
    final base = expandSearch
        ? widget.appListState.search(query, includeHidden: true)
        : widget.appListState.filteredApps;
    if (expandSearch || !widget.settingsState.hidePinnedFromDrawer) {
      return base;
    }
    return base
        .where((a) => !widget.homeState.isPinned(a.packageName))
        .toList();
  }

  void _onSearchChanged(String query) {
    widget.appListState.filter(query);
    final visible = _visibleApps;
    if (_autoLaunch && query.isNotEmpty && visible.length == 1) {
      widget.onLaunch(visible.first.packageName);
    }
  }

  void _onSubmit() {
    final visible = _visibleApps;
    if (visible.length == 1) {
      widget.onLaunch(visible.first.packageName);
    } else if (visible.isEmpty && widget.appListState.query.isNotEmpty) {
      widget.onCloseDrawer();
    }
  }

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;
    final isPinned = widget.homeState.isPinned(app.packageName);
    final isHidden = widget.appListState.isHidden(app.packageName);
    return [
      ActionItem(
        icon: Icons.edit,
        label: l10n.actionRename,
        onTap: () async {
          final newLabel = await showRenameDialog(
            context: context,
            currentLabel: widget.appListState.displayLabel(app),
            originalLabel: app.label,
          );
          if (newLabel != null) {
            widget.appListState.setCustomLabel(app.packageName, newLabel);
          }
        },
      ),
      if (!isPinned)
        ActionItem(
          icon: Icons.add_circle_outline,
          label: widget.homeState.isFull ? l10n.actionPinFull : l10n.actionPin,
          onTap: widget.homeState.isFull
              ? () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.homeScreenFull)));
                }
              : () {
                  widget.homeState.addApp(
                    PinnedApp(packageName: app.packageName, label: app.label),
                  );
                  widget.onCloseDrawer();
                },
        ),
      if (!isHidden)
        ActionItem(
          icon: Icons.visibility_off,
          label: l10n.actionHide,
          onTap: () => widget.appListState.hideApp(app.packageName),
        ),
      ActionItem(
        icon: Icons.info_outline,
        label: l10n.actionAppInfo,
        onTap: () => widget.onOpenAppInfo(app.packageName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Material(
        color: colorScheme.surface,
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
                      listenable: _mergedState,
                      builder: (context, _) {
                        final apps = _visibleApps;
                        if (apps.isEmpty &&
                            widget.appListState.query.isNotEmpty) {
                          if (!widget.settingsState.showHints) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8 + AppLabel.verticalPadding,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.noResults,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: AppLabel.fontSize,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(130),
                                  ),
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            final app = apps[index];
                            final opacity =
                                widget.appListState.isHidden(app.packageName)
                                ? 0.6
                                : 1.0;
                            if (_activeAppPackage == app.packageName) {
                              return ActionRow(
                                key: ValueKey(app.packageName),
                                label: widget.appListState.displayLabel(app),
                                actions: _appActions(context, app),
                                onClose: () =>
                                    setState(() => _activeAppPackage = null),
                                opacity: opacity,
                              );
                            }
                            return AppLabel(
                              key: ValueKey(app.packageName),
                              label: widget.appListState.displayLabel(app),
                              onTap: () => widget.onLaunch(app.packageName),
                              onLongPress: () => setState(
                                () => _activeAppPackage =
                                    _activeAppPackage == app.packageName
                                    ? null
                                    : app.packageName,
                              ),
                              opacity: opacity,
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
    );
  }
}
