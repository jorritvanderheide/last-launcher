import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _seedColor = Colors.deepPurple;

ThemeData _buildTheme(
  ColorScheme? dynamicScheme,
  Brightness brightness, {
  bool amoled = false,
}) {
  var colorScheme =
      dynamicScheme?.harmonized() ??
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);
  if (amoled && brightness == Brightness.dark) {
    colorScheme = colorScheme.copyWith(
      surface: Colors.black,
      surfaceDim: Colors.black,
      surfaceContainerLowest: Colors.black,
      surfaceContainerLow: const Color(0xFF0A0A0A),
      surfaceContainer: const Color(0xFF121212),
      surfaceContainerHigh: const Color(0xFF1A1A1A),
      surfaceContainerHighest: const Color(0xFF222222),
    );
  }
  return ThemeData(
    colorScheme: colorScheme,
    floatingActionButtonTheme: amoled && brightness == Brightness.dark
        ? FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: colorScheme.onSurface,
          )
        : null,
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
        final amoled = widget.settingsState.amoled;

        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
              title: 'Last Launcher',
              themeMode: widget.settingsState.themeMode,
              theme: _buildTheme(lightDynamic, Brightness.light),
              darkTheme: _buildTheme(
                darkDynamic,
                Brightness.dark,
                amoled: amoled,
              ),
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
      },
    );
  }
}
