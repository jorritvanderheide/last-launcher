import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/widgets/scanline_overlay.dart';

final _lightTheme = _buildTheme(Brightness.light);
final _darkTheme = _buildTheme(Brightness.dark);
final _extraTheme = _buildTheme(Brightness.dark, extra: true);

ThemeData _buildTheme(Brightness brightness, {bool extra = false}) {
  final isDark = brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;
  final glowColor = isDark ? Colors.white : Colors.black;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: textColor,
    onPrimary: isDark ? Colors.black : Colors.white,
    secondary: textColor,
    onSecondary: isDark ? Colors.black : Colors.white,
    surface: isDark ? Colors.black : Colors.white,
    onSurface: textColor,
    error: Colors.red,
    onError: Colors.white,
    inverseSurface: textColor,
    onInverseSurface: isDark ? Colors.black : Colors.white,
    surfaceContainerLow: isDark
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFF5F5F5),
    surfaceContainer: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFEEEEEE),
    surfaceContainerHigh: isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFE0E0E0),
    outline: isDark ? textColor.withAlpha(60) : Colors.black26,
  );

  final shadows = extra
      ? [
          Shadow(color: glowColor.withAlpha(120), blurRadius: 8),
          Shadow(color: glowColor.withAlpha(70), blurRadius: 24),
        ]
      : <Shadow>[];

  final applied = ThemeData(brightness: brightness).textTheme.apply(
    fontFamily: extra ? 'JetBrainsMono' : null,
    bodyColor: textColor,
    displayColor: textColor,
  );
  final textTheme = applied.copyWith(
    titleLarge: applied.titleLarge?.copyWith(shadows: shadows),
    titleMedium: applied.titleMedium?.copyWith(shadows: shadows),
    titleSmall: applied.titleSmall?.copyWith(shadows: shadows),
    bodyLarge: applied.bodyLarge?.copyWith(shadows: shadows),
    bodyMedium: applied.bodyMedium?.copyWith(shadows: shadows),
    bodySmall: applied.bodySmall?.copyWith(shadows: shadows),
    labelLarge: applied.labelLarge?.copyWith(shadows: shadows),
    labelMedium: applied.labelMedium?.copyWith(shadows: shadows),
    labelSmall: applied.labelSmall?.copyWith(shadows: shadows),
  );

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: textColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.surface,
      foregroundColor: textColor,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      shape: const RoundedRectangleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(),
    ),
    dialogTheme: const DialogThemeData(shape: RoundedRectangleBorder()),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        final base = selected ? textColor : colorScheme.outline;
        return disabled ? base.withAlpha(80) : base;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        if (selected) {
          return textColor.withAlpha(disabled ? 30 : 60);
        }
        return colorScheme.surface;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.outline.withAlpha(60)
            : colorScheme.outline;
      }),
    ),
    dividerTheme: const DividerThemeData(space: 0, thickness: 0),
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: widget.settingsState.themeMode,
          theme: _lightTheme,
          darkTheme: widget.settingsState.isExtra ? _extraTheme : _darkTheme,
          home: widget.settingsState.isExtra
              ? ScanlineOverlay(
                  child: LauncherShell(
                    appChannel: widget.appChannel,
                    homeState: widget.homeState,
                    appListState: widget.appListState,
                    settingsState: widget.settingsState,
                    taskState: widget.taskState,
                  ),
                )
              : LauncherShell(
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
