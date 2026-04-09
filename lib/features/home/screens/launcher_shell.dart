import 'dart:math';

import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_drawer_screen.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/home_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _velocityThreshold = 100.0;

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

  void _openDrawer() {
    if (_drawerOpen) return;
    _drawerOpen = true;
    Navigator.of(context).push(_slideUpRoute()).then((_) {
      _drawerOpen = false;
    });
  }

  void _closeDrawer() {
    if (!_drawerOpen) return;
    Navigator.of(context).pop();
  }

  void _launchApp(String packageName) {
    widget.appChannel.launchApp(packageName);
    _closeDrawer();
  }

  Route<void> _slideUpRoute() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppDrawerScreen(
          appListState: widget.appListState,
          homeState: widget.homeState,
          onLaunch: _launchApp,
          onCloseDrawer: _closeDrawer,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    if (max(velocity.dx.abs(), velocity.dy.abs()) < _velocityThreshold) return;

    if (velocity.dy.abs() > velocity.dx.abs()) {
      if (velocity.dy < 0 && !_drawerOpen) {
        _openDrawer();
      } else if (velocity.dy > 0 && !_drawerOpen) {
        widget.appChannel.expandQuickSettings();
      }
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
      child: GestureDetector(
        onPanEnd: _onPanEnd,
        child: HomeScreen(
          appChannel: widget.appChannel,
          homeState: widget.homeState,
          settingsState: widget.settingsState,
          onLaunch: _launchApp,
        ),
      ),
    );
  }
}
