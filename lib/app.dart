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

  ThemeData _buildDarkTheme(bool amoled) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: amoled
          ? colorScheme.copyWith(surface: Colors.black, onSurface: Colors.white)
          : colorScheme,
      scaffoldBackgroundColor: amoled ? Colors.black : null,
      useMaterial3: true,
    );
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
          darkTheme: _buildDarkTheme(widget.settingsState.amoled),
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
