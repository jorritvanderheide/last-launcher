import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_screen.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/settings/screens/settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _swipeVelocityThreshold = 300.0; // px/s
const _swipeDistanceThreshold = 40.0; // px minimum drag distance

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

class _LauncherShellState extends State<LauncherShell> {
  bool _drawerOpen = false;

  // Pointer tracking for swipe detection (bypasses gesture arena).
  Offset? _pointerStart;
  DateTime? _pointerStartTime;

  void _openDrawer() {
    if (_drawerOpen) return;
    _drawerOpen = true;
    Navigator.of(context).push(_slideUpRoute());
  }

  void _closeDrawer() {
    if (!_drawerOpen) return;
    _drawerOpen = false;
    Navigator.of(context).pop();
  }

  void _launchApp(String packageName) {
    widget.appChannel.launchApp(packageName);
    _closeDrawer();
  }

  Route<void> _slideUpRoute() {
    return PageRouteBuilder<void>(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppDrawerScreen(
          appListState: widget.appListState,
          homeState: widget.homeState,
          settingsState: widget.settingsState,
          onLaunch: _launchApp,
          onCloseDrawer: _closeDrawer,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
            );
        return SlideTransition(position: offset, child: child);
      },
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerStart = event.position;
    _pointerStartTime = DateTime.now();
  }

  void _onPointerUp(PointerUpEvent event) {
    final start = _pointerStart;
    final startTime = _pointerStartTime;
    _pointerStart = null;
    _pointerStartTime = null;

    if (start == null || startTime == null || _drawerOpen) return;

    final delta = event.position - start;
    final dy = delta.dy;
    final dx = delta.dx;
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds == 0) return;

    // Must be primarily vertical.
    if (dy.abs() < dx.abs()) return;
    // Must exceed minimum distance.
    if (dy.abs() < _swipeDistanceThreshold) return;

    final velocityY = dy / (elapsed.inMilliseconds / 1000);

    if (velocityY < -_swipeVelocityThreshold) {
      _openDrawer();
    } else if (velocityY > _swipeVelocityThreshold) {
      widget.appChannel.expandQuickSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _drawerOpen) {
          _closeDrawer();
        }
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
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
    );
  }
}
