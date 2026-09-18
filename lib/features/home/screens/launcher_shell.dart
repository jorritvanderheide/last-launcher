import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_sheet.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

const _maxSheetFraction = 0.9;
const _dragStartThreshold = 20.0;
const _swipeVelocityThreshold = 300.0;
const _pageAnimDuration = Duration(milliseconds: 100);

/// Fraction a drag must cover to snap forward instead of back.
const _snapDeltaFraction = 0.05;

/// Sheet fractions within this of 0 or [_maxSheetFraction] count as settled.
const _sheetSettledEpsilon = 0.01;

/// How long after a tap a second tap still counts as a double tap.
const _doubleTapWindow = Duration(milliseconds: 300);

/// How far the second tap may land from the first.
const _doubleTapSlop = 40.0;

/// Which of the two drags a pointer has committed to, if any. A pointer can
/// only ever drive one of them, so this replaces a pair of booleans that could
/// otherwise both be set.
enum _DragMode { none, sheet, page }

class LauncherShell extends StatefulWidget {
  const LauncherShell({
    required this.appChannel,
    required this.homeState,
    required this.appListState,
    required this.settingsState,
    required this.taskState,
    super.key,
  });

  final AppChannel appChannel;
  final HomeState homeState;
  final AppListState appListState;
  final SettingsState settingsState;
  final TaskState taskState;

  @override
  State<LauncherShell> createState() => _LauncherShellState();
}

class _LauncherShellState extends State<LauncherShell>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _homeKey = GlobalKey<HomeScreenState>();

  // Sheet (vertical drawer).
  double _sheetFraction = 0;
  bool get _drawerOpen => _sheetFraction > _sheetSettledEpsilon;
  late final AnimationController _sheetAnim;
  double _sheetAnimFrom = 0;
  double _sheetAnimTo = 0;

  // Page (horizontal: -1 = left panel, 0 = home, +1 = right panel).
  double _pageFraction = 0;
  bool get _onHomePage => _pageFraction.abs() < 0.5;
  late final AnimationController _pageAnim;
  double _pageAnimFrom = 0;
  double _pageAnimTo = 0;

  // Pointer tracking.
  int? _activePointer;
  Offset? _pointerStart;
  VelocityTracker? _velocityTracker;
  _DragMode _dragMode = _DragMode.none;
  double _dragStartFraction = 0;
  bool _listWasAtTopOnDown = true;

  // Double-tap tracking (outside gesture arena, zero delay).
  DateTime? _lastTapTime;
  Offset? _lastTapPosition;

  // Whether the app list is scrolled to the top.
  final _listIsAtTop = ValueNotifier<bool>(true);

  // Whether a reorder drag or list scroll is in progress.
  bool _isReorderingTasks = false;
  bool _isReorderingHome = false;

  late final VoidCallback _onOpenSettingsHandler;
  late final VoidCallback _onGoHomeHandler;

  @override
  void initState() {
    super.initState();
    _onOpenSettingsHandler = _openSettings;
    _onGoHomeHandler = _goHome;
    WidgetsBinding.instance.addObserver(this);
    _sheetAnim = AnimationController(vsync: this, duration: Duration.zero)
      ..addListener(() {
        final t = Curves.easeOut.transform(_sheetAnim.value);
        setState(() {
          _sheetFraction = _sheetAnimFrom + (_sheetAnimTo - _sheetAnimFrom) * t;
        });
      });
    _pageAnim = AnimationController(vsync: this, duration: _pageAnimDuration)
      ..addListener(() {
        final t = Curves.easeOut.transform(_pageAnim.value);
        setState(() {
          _pageFraction = _pageAnimFrom + (_pageAnimTo - _pageAnimFrom) * t;
        });
      });
    widget.appChannel.onOpenSettings = _onOpenSettingsHandler;
    widget.appChannel.onGoHome = _onGoHomeHandler;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (await widget.appChannel.consumePendingOpenSettings()) {
        if (mounted) _openSettings();
      }
    });
  }

  void _openSettings() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => SettingsScreen(
          settingsState: widget.settingsState,
          appListState: widget.appListState,
          homeState: widget.homeState,
          appChannel: widget.appChannel,
          onRestored: _reloadAfterRestore,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  /// A restore replaced everything that's stored; have every state re-read
  /// it rather than asking the user to restart the launcher.
  void _reloadAfterRestore() {
    widget.settingsState.reload();
    widget.appListState.reload();
    widget.homeState.reload();
    widget.taskState.reload();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A file picker opened from settings pauses the launcher too, but the
    // user is coming straight back to where they were.
    if (widget.appChannel.awaitingResult) return;
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _resetToHome();
    }
  }

  /// The user pressed home. Unwind to the home page in one step, wherever
  /// they were: a pushed route, a side panel or the app drawer. Deliberately
  /// takes the same route as the back gesture rather than [_resetToHome],
  /// which snaps rather than animates because nothing is on screen to see it.
  void _goHome() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    }
    _dismissPanelActions();
    if (_drawerOpen) _closeDrawer();
    if (!_onHomePage) _animatePageTo(0);
  }

  /// Closes any open row action bar on the home grid and both side panels.
  void _dismissPanelActions() {
    _homeKey.currentState?.dismissActions();
    widget.settingsState.leftPanel.value.dismissActions();
    widget.settingsState.rightPanel.value.dismissActions();
  }

  void _resetToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    });
    _sheetAnim.stop();
    _pageAnim.stop();
    setState(() {
      _sheetFraction = 0;
      _sheetAnimTo = 0;
      _pageFraction = 0;
      _pageAnimTo = 0;
    });
    // Defensive: clear reorder flags in case onReorderEnd was missed
    // (e.g. activity backgrounded mid-drag). The rare panel-changed-mid-drag
    // case is accepted; user can recover by backgrounding the app.
    _isReorderingHome = false;
    _isReorderingTasks = false;
    widget.appListState.clearFilter();
    _dismissPanelActions();
  }

  @override
  void dispose() {
    if (widget.appChannel.onOpenSettings == _onOpenSettingsHandler) {
      widget.appChannel.onOpenSettings = null;
    }
    if (widget.appChannel.onGoHome == _onGoHomeHandler) {
      widget.appChannel.onGoHome = null;
    }
    WidgetsBinding.instance.removeObserver(this);
    _sheetAnim.dispose();
    _pageAnim.dispose();
    _listIsAtTop.dispose();
    super.dispose();
  }

  // --- Sheet animation ---

  void _animateSheetTo(double target) {
    _sheetAnimFrom = _sheetFraction;
    _sheetAnimTo = target;
    _sheetAnim.forward(from: 0);
  }

  void _closeDrawer() {
    _animateSheetTo(0);
    widget.appListState.clearFilter();
  }

  // --- Page animation ---

  void _animatePageTo(double target) {
    _pageAnimFrom = _pageFraction;
    _pageAnimTo = target;
    _pageAnim.forward(from: 0);
  }

  void _launchApp(
    String packageName, {
    bool isWorkApp = false,
    String? shortcutId,
  }) {
    widget.appChannel.launchApp(
      packageName,
      isWorkApp: isWorkApp,
      shortcutId: shortcutId,
    );
    _closeDrawer();
  }

  /// Unpins a shortcut from the launcher, and from home if it was there.
  Future<void> _removeShortcut(AppInfo shortcut) async {
    await widget.appChannel.removeShortcut(shortcut);
    await widget.homeState.removeApp(shortcut.key);
    await widget.appListState.loadApps();
  }

  void _openAppInfo(String packageName) {
    widget.appChannel.openAppInfo(packageName);
    _closeDrawer();
  }

  // --- Pointer handling ---

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;
    _activePointer = event.pointer;
    _sheetAnim.stop();
    _pageAnim.stop();
    _pointerStart = event.position;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
    _dragMode = _DragMode.none;
    _listWasAtTopOnDown = _listIsAtTop.value;

    // Double-tap detection (outside gesture arena, no tap delay).
    if (widget.settingsState.doubleTapToSleep.value &&
        _onHomePage &&
        !_drawerOpen &&
        !_isReorderingHome &&
        !_isReorderingTasks) {
      final now = DateTime.now();
      final samePosition =
          _lastTapPosition != null &&
          (event.position - _lastTapPosition!).distance < _doubleTapSlop;
      if (_lastTapTime != null &&
          samePosition &&
          now.difference(_lastTapTime!) < _doubleTapWindow) {
        _lastTapTime = null;
        _lastTapPosition = null;
        _handleDoubleTap();
        return;
      }
      _lastTapTime = now;
      _lastTapPosition = event.position;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;
    final start = _pointerStart;
    if (start == null) return;
    _velocityTracker?.addPosition(event.timeStamp, event.position);

    final dy = start.dy - event.position.dy; // positive = upward
    final dx = start.dx - event.position.dx; // positive = left
    final absDx = dx.abs();
    final absDy = dy.abs();

    if (_dragMode == _DragMode.none) {
      if (absDx < _dragStartThreshold && absDy < _dragStartThreshold) return;

      final hasLeft = widget.settingsState.leftPanel.value is! NoneModule;
      final hasRight = widget.settingsState.rightPanel.value is! NoneModule;
      if (absDx > absDy &&
          !_drawerOpen &&
          (hasLeft || hasRight) &&
          !_isReorderingTasks &&
          !_isReorderingHome) {
        // Horizontal drag — page navigation.
        // dx > 0: finger moved leftward → fraction increases (toward right).
        // dx < 0: finger moved rightward → fraction decreases (toward left).
        final lowerBound = hasLeft ? -1.0 : 0.0;
        final upperBound = hasRight ? 1.0 : 0.0;
        if (dx > 0 && _pageFraction >= upperBound) return;
        if (dx < 0 && _pageFraction <= lowerBound) return;
        _dragMode = _DragMode.page;
        _cancelDoubleTap();
        _dragStartFraction = _pageFraction;
      } else if (absDy > absDx) {
        // Vertical drag — sheet.
        // Only drag the sheet when on home page and it can actually move.
        if (!_onHomePage || _isReorderingHome) return;
        if (dy > 0 && !_drawerOpen) {
          // Upward drag with drawer closed — open sheet.
          _dragMode = _DragMode.sheet;
          _cancelDoubleTap();
          _dragStartFraction = _sheetFraction;
        } else if (_drawerOpen) {
          if (dy > 0) return;
          if (dy < 0 && !_listWasAtTopOnDown) return;
          _dragMode = _DragMode.sheet;
          _cancelDoubleTap();
          _dragStartFraction = _sheetFraction;
        } else {
          // Downward drag with drawer closed — expand quick settings.
          widget.appChannel.expandQuickSettings();
          _cancelDoubleTap();
          _resetPointer();
          return;
        }
      } else {
        return;
      }
    }

    if (_dragMode == _DragMode.page) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final threshold = dx >= 0 ? _dragStartThreshold : -_dragStartThreshold;
      final delta = (dx - threshold) / screenWidth;
      final hasLeft = widget.settingsState.leftPanel.value is! NoneModule;
      final hasRight = widget.settingsState.rightPanel.value is! NoneModule;
      final fraction = (_dragStartFraction + delta).clamp(
        hasLeft ? -1.0 : 0.0,
        hasRight ? 1.0 : 0.0,
      );
      setState(() => _pageFraction = fraction);
    } else if (_dragMode == _DragMode.sheet) {
      final screenHeight = MediaQuery.sizeOf(context).height;
      final threshold = dy >= 0 ? _dragStartThreshold : -_dragStartThreshold;
      final delta = (dy - threshold) / screenHeight;
      final fraction = (_dragStartFraction + delta).clamp(
        0.0,
        _maxSheetFraction,
      );
      setState(() => _sheetFraction = fraction);
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) return;
    _velocityTracker?.addPosition(event.timeStamp, event.position);
    // Flutter reports velocity along the screen axes; the fractions below grow
    // as the finger moves up and to the left, so flip the sign.
    final velocity =
        -(_velocityTracker?.getVelocity().pixelsPerSecond ?? Offset.zero);
    final mode = _dragMode;
    _resetPointer();

    if (mode == _DragMode.page) {
      final vx = velocity.dx;
      final delta = _pageFraction - _dragStartFraction;
      final hasLeft = widget.settingsState.leftPanel.value is! NoneModule;
      final hasRight = widget.settingsState.rightPanel.value is! NoneModule;
      final lower = hasLeft ? -1.0 : 0.0;
      final upper = hasRight ? 1.0 : 0.0;
      var target = _dragStartFraction;
      if (delta > _snapDeltaFraction || vx > _swipeVelocityThreshold) {
        // Forward (toward right panel): snap to next slot, bounded by what
        // is configured.
        target = (_dragStartFraction + 1).clamp(lower, upper);
      } else if (delta < -_snapDeltaFraction || vx < -_swipeVelocityThreshold) {
        // Backward (toward left panel): snap to previous slot, bounded.
        target = (_dragStartFraction - 1).clamp(lower, upper);
      }
      _animatePageTo(target);
      return;
    }

    if (mode == _DragMode.sheet) {
      final vy = velocity.dy;
      if (_sheetFraction > _dragStartFraction + _snapDeltaFraction ||
          vy > _swipeVelocityThreshold) {
        _animateSheetTo(_maxSheetFraction);
      } else if (_sheetFraction < _dragStartFraction - _snapDeltaFraction ||
          vy < -_swipeVelocityThreshold) {
        _closeDrawer();
      } else {
        _animateSheetTo(_dragStartFraction);
      }
      return;
    }

    // Resume interrupted sheet animation.
    if (_sheetFraction > _sheetSettledEpsilon &&
        _sheetFraction < _maxSheetFraction - _sheetSettledEpsilon) {
      _animateSheetTo(_sheetAnimTo > 0 ? _maxSheetFraction : 0);
      return;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    switch (_dragMode) {
      case _DragMode.sheet:
        _closeDrawer();
      case _DragMode.page:
        _animatePageTo(_dragStartFraction);
      case _DragMode.none:
        break;
    }
    _cancelDoubleTap();
    _resetPointer();
  }

  void _resetPointer() {
    _activePointer = null;
    _pointerStart = null;
    _velocityTracker = null;
    _dragMode = _DragMode.none;
  }

  void _cancelDoubleTap() {
    _lastTapTime = null;
    _lastTapPosition = null;
  }

  Future<void> _handleDoubleTap() async {
    final alreadyEnabled = await widget.appChannel
        .isAccessibilityServiceEnabled();
    if (alreadyEnabled) {
      await widget.appChannel.lockScreen();
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.doubleTapToSleepDialogTitle),
        content: Text(l10n.doubleTapToSleepDialog),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.renameDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.actionEnable),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.appChannel.openAccessibilitySettings();
    }
  }

  Widget _buildPanel(
    LauncherModule panel, {
    required bool isVisible,
    required bool isLeftSide,
  }) {
    return panel.build(
      context,
      LauncherModuleProps(
        taskState: widget.taskState,
        settingsState: widget.settingsState,
        isVisible: isVisible,
        scrollLocked: _dragMode == _DragMode.page,
        swipeRight: isLeftSide,
        onReorderStart: () => _isReorderingTasks = true,
        onReorderEnd: () => _isReorderingTasks = false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetHeight = screenHeight * _sheetFraction;
    final pageOffset = -screenWidth * (1 + _pageFraction);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Re-apply fullscreen: the predictive-back animation reveals the
        // system bars and the OS doesn't always restore them cleanly when
        // PopScope rejects the pop. Re-applying after each back gesture
        // forces the bars hidden again.
        if (widget.settingsState.hideStatusBar.value) {
          widget.appChannel.setFullscreen(true);
        }
        if (_homeKey.currentState?.dismissActions() ?? false) return;
        if (widget.settingsState.leftPanel.value.dismissActions()) return;
        if (widget.settingsState.rightPanel.value.dismissActions()) return;
        if (_drawerOpen) {
          _closeDrawer();
        } else if (!_onHomePage) {
          _animatePageTo(0);
        }
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Pages: [Left, Home, Right] sliding horizontally.
              Positioned(
                left: pageOffset,
                top: 0,
                bottom: 0,
                width: screenWidth * 3,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: _buildPanel(
                        widget.settingsState.leftPanel.value,
                        isVisible: _pageFraction < -0.5,
                        isLeftSide: true,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onLongPress: _openSettings,
                        child: HomeScreen(
                          key: _homeKey,
                          homeState: widget.homeState,
                          appListState: widget.appListState,
                          settingsState: widget.settingsState,
                          onLaunch: _launchApp,
                          onReorderStart: () => _isReorderingHome = true,
                          onReorderEnd: () => _isReorderingHome = false,
                          isActive: _onHomePage && !_drawerOpen,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: _buildPanel(
                        widget.settingsState.rightPanel.value,
                        isVisible: _pageFraction > 0.5,
                        isLeftSide: false,
                      ),
                    ),
                  ],
                ),
              ),
              // App drawer (only on home page).
              if (sheetHeight > 0 && _onHomePage)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: sheetHeight,
                  child: AppDrawerSheet(
                    appListState: widget.appListState,
                    homeState: widget.homeState,
                    settingsState: widget.settingsState,
                    isOpen:
                        _sheetAnimTo == _maxSheetFraction &&
                        _dragMode != _DragMode.sheet,
                    isAtTop: _listIsAtTop,
                    onLaunch: _launchApp,
                    onOpenAppInfo: _openAppInfo,
                    onRemoveShortcut: _removeShortcut,
                    onCloseDrawer: _closeDrawer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
