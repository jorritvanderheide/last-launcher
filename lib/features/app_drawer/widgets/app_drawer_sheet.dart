import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/search.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/fold_for_search.dart';
import 'package:last_launcher/shared/data/hints.dart';
import 'package:last_launcher/shared/data/models.dart';

class _SortEntry {
  final AppInfo app;
  final String folded;
  final bool startsWith;
  final bool contains;
  final SubstringHint? hint;

  _SortEntry({
    required this.app,
    required this.folded,
    required this.startsWith,
    required this.contains,
    required this.hint,
  });
}

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
  final void Function(String packageName, {bool isWorkApp}) onLaunch;
  final void Function(String packageName) onOpenAppInfo;
  final VoidCallback onCloseDrawer;
  final ValueNotifier<bool> isAtTop;

  @override
  State<AppDrawerSheet> createState() => _AppDrawerSheetState();
}

class _AppDrawerSheetState extends State<AppDrawerSheet>
    with WidgetsBindingObserver {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  String? _activeAppKey;
  String? _prevMatchKey;
  SubstringHint? _stableHint;
  String _appKey(AppInfo app) => '${app.packageName}|${app.isWorkApp}';

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
    WidgetsBinding.instance.addObserver(this);
    if (widget.isOpen) _handleOpened();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!widget.isOpen || !_autoKeyboard) return;
    // A fast swipe-up after returning to the launcher can process the drag
    // before Android marks the window as resumed, causing the IME to ignore
    // the focus request. Retry once we're resumed.
    _requestKeyboardReliably();
  }

  @override
  void didUpdateWidget(AppDrawerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _handleOpened();
    } else if (!widget.isOpen && oldWidget.isOpen) {
      _focusNode.unfocus();
      _textController.clear();
      _activeAppKey = null;
      _prevMatchKey = null;
      _stableHint = null;
    }
  }

  void _handleOpened() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    widget.isAtTop.value = true;
    if (_autoKeyboard) {
      _requestKeyboardReliably();
    }
  }

  void _requestKeyboardReliably() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      // After app switch or device unlock the platform sometimes grants focus
      // but suppresses the keyboard. Ask for it again rather than bouncing
      // focus: this is a no-op when the IME is already up or animating in, so
      // a keyboard that was on its way never gets torn down and re-shown.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || !widget.isOpen || !_focusNode.hasFocus) return;
        SystemChannels.textInput.invokeMethod('TextInput.show');
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _withWorkDot(Widget child, AppInfo app, double opacity) {
    if (!app.isWorkApp || !widget.settingsState.showWorkAppDot) return child;
    final dotColor = Theme.of(
      context,
    ).textTheme.titleLarge?.color?.withAlpha((0.6 * 255).round());
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: -5,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Icon(Icons.circle, size: 10, color: dotColor),
            ),
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_activeAppKey != null) setState(() => _activeAppKey = null);
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
    final base = widget.appListState.search(
      query,
      includeHidden: expandSearch,
      matchOriginal: widget.settingsState.matchOriginalName,
    );
    if (expandSearch || !widget.settingsState.hidePinnedFromDrawer) {
      return base;
    }
    return base
        .where(
          (a) =>
              !widget.homeState.isPinned(a.packageName, isWorkApp: a.isWorkApp),
        )
        .toList();
  }

  SubstringHint? _queryMatchHint(AppInfo app, String query) {
    final searchTerm = SearchQuery.parse(
      query,
      allowProfileFilter: widget.appListState.profilePrefixEnabled,
    ).searchTerm;
    if (searchTerm.isEmpty) return null;
    final foldedTerm = foldForSearch(searchTerm);
    final label = widget.appListState.displayLabelForSearch(app, query);
    final foldedLabel = foldForSearch(label);
    final start =
        (!foldedLabel.startsWith(foldedTerm) &&
            foldedLabel.contains(foldedTerm))
        ? foldedLabel.indexOf(foldedTerm)
        : 0;
    return SubstringHint(start: start, length: foldedTerm.length);
  }

  void _onSearchChanged(String query) {
    widget.appListState.filter(query);
    final visible = _visibleApps;
    if (_autoLaunch && query.isNotEmpty && visible.length == 1) {
      if (!widget.settingsState.extraChar) {
        widget.onLaunch(
          visible.first.packageName,
          isWorkApp: visible.first.isWorkApp,
        );
      } else if (_prevMatchKey == _appKey(visible.first)) {
        widget.onLaunch(
          visible.first.packageName,
          isWorkApp: visible.first.isWorkApp,
        );
      } else {
        _prevMatchKey = _appKey(visible.first);
        _stableHint = _queryMatchHint(visible.first, query);
      }
    } else {
      _prevMatchKey = null;
      _stableHint = null;
    }
  }

  void _onSubmit() {
    if (widget.appListState.query.isEmpty) return;
    final visible = _visibleApps;
    if (visible.isNotEmpty) {
      final query = widget.appListState.query;
      final searchTerm = SearchQuery.parse(
        query,
        allowProfileFilter: widget.appListState.profilePrefixEnabled,
      ).searchTerm;
      final sortByHint =
          searchTerm.isNotEmpty && widget.settingsState.quickLaunchHints;
      final sorted = _sortedApps(
        visible,
        query,
        searchTerm,
        widget.appListState.hints,
        sortByHint,
      );
      widget.onLaunch(
        sorted.first.packageName,
        isWorkApp: sorted.first.isWorkApp,
      );
    } else {
      widget.onCloseDrawer();
    }
  }

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;
    final isPinned = widget.homeState.isPinned(
      app.packageName,
      isWorkApp: app.isWorkApp,
    );
    final isHidden = widget.appListState.isHidden(
      app.packageName,
      isWorkApp: app.isWorkApp,
    );
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
            widget.appListState.setCustomLabel(
              app.packageName,
              newLabel,
              isWorkApp: app.isWorkApp,
            );
          }
        },
      ),
      if (!isPinned && !widget.settingsState.locked)
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
                    PinnedApp(
                      packageName: app.packageName,
                      label: app.label,
                      isWorkApp: app.isWorkApp,
                    ),
                  );
                  widget.onCloseDrawer();
                },
        ),
      if (!isHidden)
        ActionItem(
          icon: Icons.visibility_off,
          label: l10n.actionHide,
          onTap: () => widget.appListState.hideApp(
            app.packageName,
            isWorkApp: app.isWorkApp,
          ),
        ),
      ActionItem(
        icon: Icons.info_outline,
        label: l10n.actionAppInfo,
        onTap: () => widget.onOpenAppInfo(app.packageName),
      ),
    ];
  }

  List<AppInfo> _sortedApps(
    List<AppInfo> apps,
    String query,
    String searchTerm,
    Map<String, SubstringHint?> hints,
    bool sortByHint,
  ) {
    if (apps.isEmpty) return apps;
    final needle = searchTerm.isNotEmpty ? foldForSearch(searchTerm) : '';
    final entries = apps.map((app) {
      final label = widget.appListState.displayLabelForSearch(app, query);
      final folded = foldForSearch(label);
      bool startsWith = false;
      bool contains = false;
      if (searchTerm.isNotEmpty) {
        startsWith = folded.startsWith(needle);
        contains = !startsWith && folded.contains(needle);
      }
      return _SortEntry(
        app: app,
        folded: folded,
        startsWith: startsWith,
        contains: contains,
        hint: hints[_appKey(app)],
      );
    }).toList();

    entries.sort((a, b) {
      if (sortByHint) {
        if (a.hint == null && b.hint != null) return 1;
        if (a.hint != null && b.hint == null) return -1;
        if (a.hint != null && a.hint!.length != b.hint!.length) {
          return a.hint!.length.compareTo(b.hint!.length);
        }
      }
      if (searchTerm.isNotEmpty) {
        if (a.startsWith != b.startsWith) return a.startsWith ? -1 : 1;
        if (!sortByHint) {
          if (a.contains != b.contains) return a.contains ? -1 : 1;
        }
      }
      return a.folded.compareTo(b.folded);
    });

    return entries.map((e) => e.app).toList();
  }

  SubstringHint? _displayHint({
    required AppInfo app,
    required String searchLabel,
    required SubstringHint? hint,
  }) {
    if (_stableHint != null &&
        _prevMatchKey == _appKey(app) &&
        widget.settingsState.extraChar) {
      return SubstringHint(
        start: _stableHint!.start,
        length:
            (_stableHint!.start + _stableHint!.length + 1).clamp(
              0,
              searchLabel.length,
            ) -
            _stableHint!.start,
      );
    }
    if (hint != null && widget.settingsState.extraChar) {
      return SubstringHint(
        start: hint.start,
        length:
            (hint.start + hint.length + 1).clamp(0, searchLabel.length) -
            hint.start,
      );
    }
    return hint;
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
                        final query = widget.appListState.query;
                        final searchTerm = SearchQuery.parse(
                          query,
                          allowProfileFilter:
                              widget.appListState.profilePrefixEnabled,
                        ).searchTerm;
                        final sortByHint =
                            query.isNotEmpty &&
                            searchTerm.isNotEmpty &&
                            widget.settingsState.quickLaunchHints;
                        final sorted = _sortedApps(
                          apps,
                          query,
                          searchTerm,
                          widget.appListState.hints,
                          sortByHint,
                        );
                        if (sorted.isEmpty &&
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
                          itemCount: sorted.length,
                          itemBuilder: (context, index) {
                            final app = sorted[index];
                            final dimmed =
                                widget.appListState.isHidden(
                                  app.packageName,
                                  isWorkApp: app.isWorkApp,
                                ) ||
                                (widget.settingsState.hidePinnedFromDrawer &&
                                    widget.homeState.isPinned(
                                      app.packageName,
                                      isWorkApp: app.isWorkApp,
                                    ));
                            final showHint =
                                widget.settingsState.quickLaunchHints;
                            final searchLabel = widget.appListState
                                .displayLabelForSearch(app, query);
                            final hint = showHint
                                ? widget.appListState.hints[_appKey(app)]
                                : null;
                            final displayHint = _displayHint(
                              app: app,
                              searchLabel: searchLabel,
                              hint: hint,
                            );
                            final opacity = showHint && (dimmed || hint == null)
                                ? 0.6
                                : 1.0;
                            final key = _appKey(app);
                            if (_activeAppKey == key) {
                              return _withWorkDot(
                                ActionRow(
                                  key: ValueKey(key),
                                  label: searchLabel,
                                  actions: _appActions(context, app),
                                  onClose: () =>
                                      setState(() => _activeAppKey = null),
                                  opacity: opacity,
                                ),
                                app,
                                opacity,
                              );
                            }
                            return _withWorkDot(
                              AppLabel(
                                key: ValueKey(key),
                                label: searchLabel,
                                hint: displayHint,
                                hintAlphaOnly: !RegExp(
                                  r'[^a-zA-Z]',
                                ).hasMatch(query),
                                onTap: () => widget.onLaunch(
                                  app.packageName,
                                  isWorkApp: app.isWorkApp,
                                ),
                                onLongPress: () => setState(
                                  () => _activeAppKey = _activeAppKey == key
                                      ? null
                                      : key,
                                ),
                                opacity: opacity,
                              ),
                              app,
                              opacity,
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
