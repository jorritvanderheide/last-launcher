import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

class LastLauncherApp extends StatefulWidget {
  const LastLauncherApp({
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
  State<LastLauncherApp> createState() => _LastLauncherAppState();
}

class _LastLauncherAppState extends State<LastLauncherApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.appListState.loadApps();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Last Launcher',
          themeMode: widget.settingsState.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: LauncherShell(
            appChannel: widget.appChannel,
            homeState: widget.homeState,
            appListState: widget.appListState,
            settingsState: widget.settingsState,
          ),
        );
      },
    );
  }
}
