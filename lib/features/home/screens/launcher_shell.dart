import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_sheet.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/screens/task_screen.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _maxSheetFraction = 0.9;
const _dragStartThreshold = 20.0;
const _swipeVelocityThreshold = 300.0;
const _pageAnimDuration = Duration(milliseconds: 100);

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
  final _taskKey = GlobalKey<TaskScreenState>();

  // Sheet (vertical drawer).
  double _sheetFraction = 0;
  bool get _drawerOpen => _sheetFraction > 0.01;
  late final AnimationController _sheetAnim;
  double _sheetAnimFrom = 0;
  double _sheetAnimTo = 0;

  // Page (horizontal: 0 = tasks, 1 = home).
  double _pageFraction = 1;
  bool get _onHomePage => _pageFraction > 0.5;
  late final AnimationController _pageAnim;
  double _pageAnimFrom = 1;
  double _pageAnimTo = 1;

  // Pointer tracking.
  int? _activePointer;
  Offset? _pointerStart;
  DateTime? _pointerStartTime;
  bool _isDraggingSheet = false;
  bool _isDraggingPage = false;
  double _dragStartFraction = 0;
  bool _listWasAtTopOnDown = true;

  // Whether the app list is scrolled to the top.
  final _listIsAtTop = ValueNotifier<bool>(true);

  // Whether a reorder drag or list scroll is in progress.
  bool _isReorderingTasks = false;
  bool _isReorderingHome = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sheetAnim =
        AnimationController(
          vsync: this,
          duration: Duration.zero,
        )..addListener(() {
          final t = Curves.easeOut.transform(_sheetAnim.value);
          setState(() {
            _sheetFraction =
                _sheetAnimFrom + (_sheetAnimTo - _sheetAnimFrom) * t;
          });
        });
    _pageAnim =
        AnimationController(
          vsync: this,
          duration: _pageAnimDuration,
        )..addListener(() {
          final t = Curves.easeOut.transform(_pageAnim.value);
          setState(() {
            _pageFraction = _pageAnimFrom + (_pageAnimTo - _pageAnimFrom) * t;
          });
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _resetToHome();
    }
  }

  void _resetToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    _sheetAnim.stop();
    _pageAnim.stop();
    setState(() {
      _sheetFraction = 0;
      _sheetAnimTo = 0;
      _pageFraction = 1;
      _pageAnimTo = 1;
    });
    widget.appListState.clearFilter();
  }

  @override
  void dispose() {
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


  void _launchApp(String packageName) {
    widget.appChannel.launchApp(packageName);
    _closeDrawer();
  }

  // --- Pointer handling ---

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;
    _activePointer = event.pointer;
    _sheetAnim.stop();
    _pageAnim.stop();
    _pointerStart = event.position;
    _pointerStartTime = DateTime.now();
    _isDraggingSheet = false;
    _isDraggingPage = false;
    _listWasAtTopOnDown = _listIsAtTop.value;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;
    final start = _pointerStart;
    if (start == null) return;

    final dy = start.dy - event.position.dy; // positive = upward
    final dx = start.dx - event.position.dx; // positive = left
    final absDx = dx.abs();
    final absDy = dy.abs();

    if (!_isDraggingSheet && !_isDraggingPage) {
      if (absDx < _dragStartThreshold && absDy < _dragStartThreshold) return;

      if (absDx > absDy && !_drawerOpen &&
          widget.settingsState.tasksEnabled &&
          !_isReorderingTasks) {
        // Horizontal drag — page navigation.
        // Don't start if already at the edge in the drag direction.
        final wouldGoLeft = dx > 0;
        if (wouldGoLeft && _pageFraction >= 1) return;
        if (!wouldGoLeft && _pageFraction <= 0) return;
        _isDraggingPage = true;
        _dragStartFraction = _pageFraction;
      } else if (absDy > absDx) {
        // Vertical drag — sheet.
        // Only drag the sheet when on home page and it can actually move.
        if (!_onHomePage || _isReorderingHome) return;
        if (dy > 0 && !_drawerOpen) {
          // Upward drag with drawer closed — open sheet.
          _isDraggingSheet = true;
          _dragStartFraction = _sheetFraction;
        } else if (_drawerOpen) {
          if (dy > 0) return;
          if (dy < 0 && !_listWasAtTopOnDown) return;
          _isDraggingSheet = true;
          _dragStartFraction = _sheetFraction;
        } else {
          // Downward drag with drawer closed — expand quick settings.
          widget.appChannel.expandQuickSettings();
          _resetPointer();
          return;
        }
      } else {
        return;
      }
    }

    if (_isDraggingPage) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final threshold = dx >= 0 ? _dragStartThreshold : -_dragStartThreshold;
      final delta = (dx - threshold) / screenWidth;
      final fraction = (_dragStartFraction + delta).clamp(0.0, 1.0);
      setState(() => _pageFraction = fraction);
    } else if (_isDraggingSheet) {
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
    final start = _pointerStart;
    final startTime = _pointerStartTime;
    _resetPointer();

    if (_isDraggingPage) {
      _isDraggingPage = false;
      final vx = _velocity(start?.dx, event.position.dx, startTime);
      if (_pageFraction < _dragStartFraction - 0.05 ||
          vx < -_swipeVelocityThreshold) {
        _animatePageTo(0); // snap to tasks
      } else if (_pageFraction > _dragStartFraction + 0.05 ||
          vx > _swipeVelocityThreshold) {
        _animatePageTo(1); // snap to home
      } else {
        _animatePageTo(_dragStartFraction);
      }
      return;
    }

    if (_isDraggingSheet) {
      _isDraggingSheet = false;
      final vy = _velocity(start?.dy, event.position.dy, startTime);
      if (_sheetFraction > _dragStartFraction + 0.05 ||
          vy > _swipeVelocityThreshold) {
        _animateSheetTo(_maxSheetFraction);
      } else if (_sheetFraction < _dragStartFraction - 0.05 ||
          vy < -_swipeVelocityThreshold) {
        _closeDrawer();
      } else {
        _animateSheetTo(_dragStartFraction);
      }
      return;
    }

    // Resume interrupted sheet animation.
    if (_sheetFraction > 0.01 && _sheetFraction < _maxSheetFraction - 0.01) {
      _animateSheetTo(_sheetAnimTo > 0 ? _maxSheetFraction : 0);
      return;
    }

  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    if (_isDraggingSheet) {
      _isDraggingSheet = false;
      _closeDrawer();
    }
    if (_isDraggingPage) {
      _isDraggingPage = false;
      _animatePageTo(_dragStartFraction > 0.5 ? 1 : 0);
    }
    _resetPointer();
  }

  /// Single-axis velocity in px/s (positive = start→end direction).
  double _velocity(double? startV, double endV, DateTime? startTime) {
    if (startV == null || startTime == null) return 0;
    final micros = DateTime.now().difference(startTime).inMicroseconds;
    if (micros < 1000) return 0;
    return (startV - endV) / (micros / 1000000);
  }

  void _resetPointer() {
    _activePointer = null;
    _pointerStart = null;
    _pointerStartTime = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetHeight = screenHeight * _sheetFraction;
    final pageOffset = -_pageFraction * screenWidth;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_homeKey.currentState?.dismissActions() ?? false) return;
        if (_taskKey.currentState?.dismissActions() ?? false) return;
        if (_drawerOpen) {
          _closeDrawer();
        } else if (!_onHomePage) {
          _animatePageTo(1);
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
              // Pages: [Tasks, Home] sliding horizontally.
              Positioned(
                left: pageOffset,
                top: 0,
                bottom: 0,
                width: screenWidth * 2,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: TaskScreen(
                        key: _taskKey,
                        taskState: widget.taskState,
                        settingsState: widget.settingsState,
                        isVisible: !_onHomePage,
                        onReorderStart: () =>
                            _isReorderingTasks = true,
                        onReorderEnd: () =>
                            _isReorderingTasks = false,
                        scrollLocked: _isDraggingPage,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPress: () {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              pageBuilder: (_, _, _) => SettingsScreen(
                                settingsState: widget.settingsState,
                                appListState: widget.appListState,
                                homeState: widget.homeState,
                                appChannel: widget.appChannel,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: HomeScreen(
                          key: _homeKey,
                          homeState: widget.homeState,
                          appListState: widget.appListState,
                          settingsState: widget.settingsState,
                          onLaunch: _launchApp,
                          onReorderStart: () =>
                              _isReorderingHome = true,
                          onReorderEnd: () =>
                              _isReorderingHome = false,
                          isActive: _onHomePage && !_drawerOpen,
                        ),
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
                        _sheetAnimTo == _maxSheetFraction && !_isDraggingSheet,
                    isAtTop: _listIsAtTop,
                    onLaunch: _launchApp,
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
