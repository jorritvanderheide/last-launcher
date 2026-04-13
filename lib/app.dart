import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

final _lightTheme = _buildTheme(Brightness.light);
final _darkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: isDark ? Colors.white : Colors.black,
    onPrimary: isDark ? Colors.black : Colors.white,
    secondary: isDark ? Colors.white : Colors.black,
    onSecondary: isDark ? Colors.black : Colors.white,
    surface: isDark ? Colors.black : Colors.white,
    onSurface: isDark ? Colors.white : Colors.black,
    error: Colors.red,
    onError: Colors.white,
    inverseSurface: isDark ? Colors.white : Colors.black,
    onInverseSurface: isDark ? Colors.black : Colors.white,
    surfaceContainerLow: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
    surfaceContainer: isDark ? const Color(0xFF121212) : const Color(0xFFEEEEEE),
    surfaceContainerHigh: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
    outline: isDark ? Colors.white24 : Colors.black26,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

class LastLauncherApp extends StatefulWidget {
  const LastLauncherApp({
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
      listenable: widget.settingsState.themeNotifier,
      builder: (context, _) {
        SystemChrome.setEnabledSystemUIMode(
          widget.settingsState.hideStatusBar
              ? SystemUiMode.immersiveSticky
              : SystemUiMode.edgeToEdge,
        );
        return MaterialApp(
          title: 'Last Launcher',
          themeMode: widget.settingsState.themeMode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          home: LauncherShell(
            appChannel: widget.appChannel,
            homeState: widget.homeState,
            appListState: widget.appListState,
            settingsState: widget.settingsState,
            taskState: widget.taskState,
          ),
        );
      },
    );
  }
}
