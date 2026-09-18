import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/ranking.dart';
import 'package:last_launcher/features/app_drawer/search.dart';
import 'package:last_launcher/shared/search_focus_controller.dart';
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

/// Opacity of rows the user can't quick-launch: hidden apps, pinned apps when
/// they're kept out of the drawer, and apps without a hint.
const _dimmedOpacity = 0.6;

/// Opacity of the work-profile dot relative to the row's own opacity.
const _workDotOpacity = 0.6;

/// Alpha of the "no results" / empty-state text.
const _emptyTextAlpha = 130;

class AppDrawerSheet extends StatefulWidget {
  const AppDrawerSheet({
    required this.appListState,
    required this.homeState,
    required this.settingsState,
    required this.isOpen,
    required this.onLaunch,
    required this.onOpenAppInfo,
    required this.onRemoveShortcut,
    required this.onCloseDrawer,
    required this.isAtTop,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final SettingsState settingsState;
  final bool isOpen;
  final void Function(String packageName, {bool isWorkApp, String? shortcutId})
  onLaunch;
  final void Function(String packageName) onOpenAppInfo;
  final void Function(AppInfo shortcut) onRemoveShortcut;
  final VoidCallback onCloseDrawer;
  final ValueNotifier<bool> isAtTop;

  @override
  State<AppDrawerSheet> createState() => _AppDrawerSheetState();
}

class _AppDrawerSheetState extends State<AppDrawerSheet>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  late final _focus = SearchFocusController(autoKeyboard: () => _autoKeyboard);

  String? _activeAppKey;
  String? _prevMatchKey;
  SubstringHint? _stableHint;

  /// Ranked results for the current query, rebuilt lazily whenever any of the
  /// states feeding them notifies. See [_results].
  DrawerResults? _cachedResults;

  late final Listenable _mergedState = Listenable.merge([
    widget.appListState,
    widget.settingsState,
    widget.homeState,
  ]);

  bool get _searchOnly => widget.settingsState.searchOnly.value;
  bool get _autoKeyboard => widget.settingsState.autoKeyboardActive;
  bool get _autoLaunch => widget.settingsState.autoLaunchActive;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _mergedState.addListener(_invalidateResults);
    WidgetsBinding.instance.addObserver(this);
    if (widget.isOpen) _handleOpened();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _focus.appResumed();
  }

  @override
  void didUpdateWidget(AppDrawerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _handleOpened();
    } else if (!widget.isOpen && oldWidget.isOpen) {
      _focus.panelClosed();
      _textController.clear();
      _activeAppKey = null;
      _prevMatchKey = null;
      _stableHint = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mergedState.removeListener(_invalidateResults);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _handleOpened() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    widget.isAtTop.value = true;
    _focus.panelOpened();
  }

  // ------------------------------------------------------------------
  // Results
  // ------------------------------------------------------------------

  /// The one list everything reads: what's drawn, what auto-launch fires on
  /// and what submitting launches. Recomputed at most once per change to the
  /// app list, the settings or the pinned apps.
  DrawerResults get _results => _cachedResults ??= _buildResults();

  void _invalidateResults() => _cachedResults = null;

  DrawerResults _buildResults() {
    final appList = widget.appListState;
    final settings = widget.settingsState;
    final query = appList.query;
    final expandSearch =
        query.isNotEmpty && settings.includeHiddenInSearch.value;
    var matches = appList.search(
      query,
      includeHidden: expandSearch,
      matchOriginal: settings.matchOriginalName.value,
    );
    if (!expandSearch && settings.hidePinnedFromDrawer.value) {
      matches = matches
          .where((a) => !widget.homeState.isPinned(a.key))
          .toList();
    }
    final searchTerm = SearchQuery.parse(
      query,
      allowProfileFilter: appList.profilePrefixEnabled,
    ).searchTerm;
    return DrawerResults(
      apps: rankApps(
        apps: matches,
        searchTerm: searchTerm,
        hints: appList.hints,
        sortByHint: searchTerm.isNotEmpty && settings.quickLaunchHintsActive,
        searchLabel: (app) => appList.displayLabelForSearch(app, query),
      ),
      query: query,
      searchTerm: searchTerm,
    );
  }

  // ------------------------------------------------------------------
  // Input
  // ------------------------------------------------------------------

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_activeAppKey != null) setState(() => _activeAppKey = null);
    widget.isAtTop.value = _scrollController.offset <= 0;
    _focus.scrolled(_scrollController.offset);
  }

  void _onSearchChanged(String query) {
    widget.appListState.filter(query);
    final only = _autoLaunch ? _results.onlyMatch : null;
    if (only == null) {
      _prevMatchKey = null;
      _stableHint = null;
      return;
    }
    // With extraChar on, the single match has to survive one more keystroke
    // before it launches, so a match that appears mid-word can't run away.
    if (!widget.settingsState.extraCharActive || _prevMatchKey == only.key) {
      widget.onLaunch(
        only.packageName,
        isWorkApp: only.isWorkApp,
        shortcutId: only.shortcutId,
      );
      return;
    }
    _prevMatchKey = only.key;
    _stableHint = _queryMatchHint(only, query);
  }

  void _onSubmit() {
    final results = _results;
    if (!results.isSearching) return;
    final best = results.best;
    if (best == null) {
      widget.onCloseDrawer();
      return;
    }
    widget.onLaunch(
      best.packageName,
      isWorkApp: best.isWorkApp,
      shortcutId: best.shortcutId,
    );
  }

  // ------------------------------------------------------------------
  // Hints
  // ------------------------------------------------------------------

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

  /// The hint to underline on [app]'s row. With extraChar on it covers one
  /// character more than was matched, showing which key launches the app.
  SubstringHint? _displayHint({
    required AppInfo app,
    required String searchLabel,
    required SubstringHint? hint,
  }) {
    if (!widget.settingsState.extraCharActive) return hint;
    if (_stableHint != null && _prevMatchKey == app.key) {
      return _stableHint!.extendedBy(1, searchLabel.length);
    }
    return hint?.extendedBy(1, searchLabel.length);
  }

  // ------------------------------------------------------------------
  // Rows
  // ------------------------------------------------------------------

  Widget _withWorkDot(Widget child, AppInfo app, double opacity) {
    if (!app.isWorkApp || !widget.settingsState.workAppDotActive) return child;
    final dotColor = Theme.of(
      context,
    ).textTheme.titleLarge?.color?.withAlpha((_workDotOpacity * 255).round());
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

  List<ActionItem> _appActions(BuildContext context, AppInfo app) {
    final l10n = AppLocalizations.of(context)!;
    final isPinned = widget.homeState.isPinned(app.key);
    final isHidden = widget.appListState.isHidden(app.key);
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
            widget.appListState.setCustomLabel(app.key, newLabel);
          }
        },
      ),
      if (!isPinned && !widget.settingsState.locked.value)
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
                      shortcutId: app.shortcutId,
                    ),
                  );
                  widget.onCloseDrawer();
                },
        ),
      if (!isHidden)
        ActionItem(
          icon: Icons.visibility_off,
          label: l10n.actionHide,
          onTap: () => widget.appListState.hideApp(app.key),
        ),
      if (app.isShortcut)
        ActionItem(
          icon: Icons.delete_outline,
          label: l10n.actionRemove,
          onTap: () => widget.onRemoveShortcut(app),
        ),
      ActionItem(
        icon: Icons.info_outline,
        label: l10n.actionAppInfo,
        onTap: () => widget.onOpenAppInfo(app.packageName),
      ),
    ];
  }

  Widget _buildRow(BuildContext context, AppInfo app, DrawerResults results) {
    final dimmed =
        widget.appListState.isHidden(app.key) ||
        (widget.settingsState.hidePinnedFromDrawer.value &&
            widget.homeState.isPinned(app.key));
    final showHint = widget.settingsState.quickLaunchHintsActive;
    final searchLabel = widget.appListState.displayLabelForSearch(
      app,
      results.query,
    );
    final hint = showHint ? widget.appListState.hints[app.key] : null;
    final opacity = showHint && (dimmed || hint == null) ? _dimmedOpacity : 1.0;

    if (_activeAppKey == app.key) {
      return _withWorkDot(
        ActionRow(
          key: ValueKey(app.key),
          label: searchLabel,
          actions: _appActions(context, app),
          onClose: () => setState(() => _activeAppKey = null),
          opacity: opacity,
        ),
        app,
        opacity,
      );
    }
    return _withWorkDot(
      AppLabel(
        key: ValueKey(app.key),
        label: searchLabel,
        hint: _displayHint(app: app, searchLabel: searchLabel, hint: hint),
        hintAlphaOnly: !RegExp(r'[^a-zA-Z]').hasMatch(results.query),
        onTap: () => widget.onLaunch(
          app.packageName,
          isWorkApp: app.isWorkApp,
          shortcutId: app.shortcutId,
        ),
        onLongPress: () => setState(
          () => _activeAppKey = _activeAppKey == app.key ? null : app.key,
        ),
        opacity: opacity,
      ),
      app,
      opacity,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (!widget.settingsState.showHints.value) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        top: 8 + AppLabel.verticalPadding,
      ),
      child: Text(
        AppLocalizations.of(context)!.noResults,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: AppLabel.fontSizeOf(context),
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(_emptyTextAlpha),
        ),
      ),
    );
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
                focusNode: _focus.node,
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
                    _focus.overscrolled(notification.overscroll);
                    return false;
                  },
                  child: FadeOverflow(
                    child: ListenableBuilder(
                      listenable: _mergedState,
                      builder: (context, _) {
                        final results = _results;
                        if (results.isEmpty && results.isSearching) {
                          return _buildEmptyState(context);
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          itemCount: results.apps.length,
                          itemBuilder: (context, index) =>
                              _buildRow(context, results.apps[index], results),
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
