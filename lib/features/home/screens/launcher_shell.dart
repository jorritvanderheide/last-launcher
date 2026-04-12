import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_sheet.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _maxSheetFraction = 0.9;
const _dragStartThreshold = 20.0; // px vertical before sheet starts moving
const _swipeVelocityThreshold = 300.0; // px/s for swipe-down quick settings

class LauncherShell extends StatefulWidget {
  const LauncherShell({
    required this.appChannel,
    required this.homeState,
    required this.appListState,
    required this.settingsState,
    super.key,
  });

  final AppChannel appChannel;
  final HomeState homeState;
  final AppListState appListState;
  final SettingsState settingsState;

  @override
  State<LauncherShell> createState() => _LauncherShellState();
}

class _LauncherShellState extends State<LauncherShell>
    with SingleTickerProviderStateMixin {
  // Current sheet height as a fraction of screen height (0..._maxSheetFraction).
  double _sheetFraction = 0;
  bool get _drawerOpen => _sheetFraction > 0.01;

  // Animation for snap open/close.
  late final AnimationController _animController;
  double _animFrom = 0;
  double _animTo = 0;

  // Pointer tracking (bypasses gesture arena).
  int? _activePointer;
  Offset? _pointerStart;
  DateTime? _pointerStartTime;
  bool _isDraggingSheet = false;
  double _dragStartFraction = 0;

  // Whether the app list is scrolled to the top.
  final _listIsAtTop = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          final t = Curves.easeOut.transform(_animController.value);
          setState(() {
            _sheetFraction = _animFrom + (_animTo - _animFrom) * t;
          });
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    _listIsAtTop.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _animFrom = _sheetFraction;
    _animTo = target;
    _animController.forward(from: 0);
  }

  void _openDrawer() {
    _animateTo(_maxSheetFraction);
  }

  void _closeDrawer() {
    _animateTo(0);
    widget.appListState.clearFilter();
  }

  void _launchApp(String packageName) {
    widget.appChannel.launchApp(packageName);
    _closeDrawer();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointer != null) return; // ignore second finger
    _activePointer = event.pointer;
    _animController.stop();
    _pointerStart = event.position;
    _pointerStartTime = DateTime.now();
    _isDraggingSheet = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;
    final start = _pointerStart;
    if (start == null) return;

    final dy = start.dy - event.position.dy; // positive = upward
    final dx = (event.position.dx - start.dx).abs();

    if (!_isDraggingSheet) {
      // Not yet dragging — check if this qualifies as a vertical drag.
      if (dy.abs() < _dragStartThreshold || dx > dy.abs()) return;

      // Only drag the sheet when it can actually move:
      // - Upward drag: only when sheet is not fully open
      // - Downward drag: only when at top of list
      if (_drawerOpen) {
        if (dy > 0) return;
        if (dy < 0 && !_listIsAtTop.value) return;
      }

      _isDraggingSheet = true;
      _dragStartFraction = _sheetFraction;
    }

    final screenHeight = MediaQuery.sizeOf(context).height;
    final threshold = dy >= 0 ? _dragStartThreshold : -_dragStartThreshold;
    final delta = (dy - threshold) / screenHeight;
    final fraction = (_dragStartFraction + delta).clamp(0.0, _maxSheetFraction);
    setState(() => _sheetFraction = fraction);
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) return;
    final start = _pointerStart;
    final startTime = _pointerStartTime;
    _resetPointer();

    if (_isDraggingSheet) {
      _isDraggingSheet = false;
      if (_sheetFraction > _dragStartFraction + 0.05) {
        _openDrawer();
      } else if (_sheetFraction < _dragStartFraction - 0.05) {
        _closeDrawer();
      } else {
        // Didn't move enough — return to where it started.
        _animateTo(_dragStartFraction);
      }
      return;
    }

    // Resume interrupted animation if sheet is partially open.
    if (_sheetFraction > 0.01 && _sheetFraction < _maxSheetFraction - 0.01) {
      _animateTo(_animTo > 0 ? _maxSheetFraction : 0);
      return;
    }

    // Handle quick swipe down for quick settings.
    if (start == null || startTime == null || _drawerOpen) return;
    final dy = event.position.dy - start.dy;
    final dx = (event.position.dx - start.dx).abs();
    final elapsedMicros = DateTime.now().difference(startTime).inMicroseconds;
    if (elapsedMicros < 1000 || dy.abs() < dx.abs()) return;
    final velocityY = dy / (elapsedMicros / 1000000);
    if (velocityY > _swipeVelocityThreshold) {
      widget.appChannel.expandQuickSettings();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    if (_isDraggingSheet) {
      _isDraggingSheet = false;
      _closeDrawer();
    }
    _resetPointer();
  }

  void _resetPointer() {
    _activePointer = null;
    _pointerStart = null;
    _pointerStartTime = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetHeight = screenHeight * _sheetFraction;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _drawerOpen) {
          _closeDrawer();
        }
      },
      child: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () {
                Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    pageBuilder: (_, _, _) =>
                        SettingsScreen(settingsState: widget.settingsState),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: HomeScreen(
                homeState: widget.homeState,
                appListState: widget.appListState,
                onLaunch: _launchApp,
              ),
            ),
          ),
          if (sheetHeight > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: sheetHeight,
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: AppDrawerSheet(
                  appListState: widget.appListState,
                  homeState: widget.homeState,
                  settingsState: widget.settingsState,
                  isOpen: _animTo == _maxSheetFraction && !_isDraggingSheet,
                  isAtTop: _listIsAtTop,
                  onLaunch: _launchApp,
                  onCloseDrawer: _closeDrawer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
