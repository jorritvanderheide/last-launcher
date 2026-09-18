import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/scanline_overlay.dart';
import 'package:last_launcher/shared/widgets/settings_theme.dart';

/// The parts of the look that end up in [ThemeData]. A record, so equal
/// looks compare equal and each theme is only ever built once.
typedef ThemeSpec = ({bool mono, bool glow, AccentColors? accent});

final _themes = <(Brightness, ThemeSpec, bool), ThemeData>{};

ThemeData _themeFor(
  Brightness brightness,
  ThemeSpec spec, {
  bool settings = false,
}) => _themes.putIfAbsent((
  brightness,
  spec,
  settings,
), () => buildLauncherTheme(brightness, spec, settings: settings));

/// How strongly each scanline level draws, relative to the original look.
double _scanlineStrength(ScanlineLevel level) => switch (level) {
  ScanlineLevel.off => 0,
  ScanlineLevel.light => 0.5,
  ScanlineLevel.medium => 1,
  ScanlineLevel.strong => 2,
};

/// The app's theme. With [settings] set, the variant for settings pages:
/// text, icons and backgrounds stay plain, and only the highlights (page
/// titles and section headings, switches, sliders, focused fields) take the
/// accent.
@visibleForTesting
ThemeData buildLauncherTheme(
  Brightness brightness,
  ThemeSpec spec, {
  bool settings = false,
}) {
  final isDark = brightness == Brightness.dark;
  final accent = spec.accent;
  final plain = isDark ? Colors.white : Colors.black;
  final highlight = accent == null
      ? plain
      : (isDark ? accent.onDark : accent.onLight);
  final textColor = settings ? plain : highlight;
  final glowColor = textColor;

  // With the accent on, the launcher's backgrounds take on a faint tint of
  // it; settings pages stay plain.
  Color tinted(Color background) => accent == null || settings
      ? background
      : Color.alphaBlend(accent.tint.withAlpha(isDark ? 20 : 26), background);

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: highlight,
    onPrimary: isDark ? Colors.black : Colors.white,
    secondary: highlight,
    onSecondary: isDark ? Colors.black : Colors.white,
    surface: tinted(isDark ? Colors.black : Colors.white),
    onSurface: textColor,
    error: Colors.red,
    onError: Colors.white,
    inverseSurface: textColor,
    onInverseSurface: isDark ? Colors.black : Colors.white,
    surfaceContainerLow: tinted(
      isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
    ),
    surfaceContainer: tinted(
      isDark ? const Color(0xFF121212) : const Color(0xFFEEEEEE),
    ),
    surfaceContainerHigh: tinted(
      isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
    ),
    outline: isDark ? textColor.withAlpha(60) : Colors.black26,
  );

  // Glow is one of the effects that only exist in dark mode.
  final shadows = spec.glow && isDark
      ? [
          Shadow(color: glowColor.withAlpha(120), blurRadius: 8),
          Shadow(color: glowColor.withAlpha(70), blurRadius: 24),
        ]
      : <Shadow>[];

  final applied = ThemeData(brightness: brightness).textTheme.apply(
    fontFamily: spec.mono ? 'JetBrainsMono' : null,
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
      // Page titles are headings: they take the accent, the icons don't.
      titleTextStyle: textTheme.titleLarge?.copyWith(color: highlight),
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
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: highlight, width: 1.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        final base = selected ? highlight : colorScheme.outline;
        return disabled ? base.withAlpha(80) : base;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        if (selected) {
          return highlight.withAlpha(disabled ? 30 : 60);
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
  /// The system accent, re-read on every resume since the user can change it
  /// (with the wallpaper, say) while the launcher is in the background.
  AccentColors? _accent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAccent();
    widget.settingsState.addListener(_syncFullscreen);
    _syncFullscreen();
    _maybeClearCompleted();
  }

  @override
  void dispose() {
    widget.settingsState.removeListener(_syncFullscreen);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshApps();
      _refreshAccent();
      _maybeClearCompleted();
      _syncFullscreen();
    }
  }

  Future<void> _refreshApps() async {
    await widget.appListState.loadApps();
    await widget.homeState.pruneMissing(widget.appListState.installedPackages);
  }

  Future<void> _refreshAccent() async {
    final accent = await widget.appChannel.getAccentColors();
    if (mounted && accent != _accent) setState(() => _accent = accent);
  }

  void _syncFullscreen() {
    widget.appChannel.setFullscreen(widget.settingsState.hideStatusBar.value);
  }

  void _maybeClearCompleted() {
    if (widget.settingsState.clearCompletedDaily.value) {
      widget.taskState.clearCompletedIfNewDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsState.appearanceChanged,
      builder: (context, _) {
        final settings = widget.settingsState;
        final spec = (
          mono: settings.font.value == FontChoice.mono,
          glow: settings.glow.value,
          accent: settings.accentColor.value ? _accent : null,
        );
        final brightness = switch (settings.themeMode.value) {
          ThemeMode.light => Brightness.light,
          ThemeMode.dark => Brightness.dark,
          ThemeMode.system => MediaQuery.platformBrightnessOf(context),
        };
        final iconBrightness = brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarIconBrightness: iconBrightness,
            systemNavigationBarIconBrightness: iconBrightness,
          ),
        );
        return MaterialApp(
          title: 'Last Launcher',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: settings.themeMode.value,
          theme: _themeFor(Brightness.light, spec),
          darkTheme: _themeFor(Brightness.dark, spec),
          builder: (context, child) => SettingsTheme(
            data: _themeFor(Theme.of(context).brightness, spec, settings: true),
            child: AppearanceScope(
              labelFontSize: settings.textSize.value,
              labelAlign: switch (settings.labelAlignment.value) {
                LabelAlignment.left => TextAlign.left,
                LabelAlignment.center => TextAlign.center,
                LabelAlignment.right => TextAlign.right,
              },
              accentAvailable: _accent != null,
              terminalPrompt: settings.terminalPrompt.value,
              animate:
                  settings.animations.value &&
                  !MediaQuery.disableAnimationsOf(context),
              child: child!,
            ),
          ),
          home: ScanlineOverlay(
            strength: _scanlineStrength(settings.scanlines.value),
            child: LauncherShell(
              appChannel: widget.appChannel,
              homeState: widget.homeState,
              appListState: widget.appListState,
              settingsState: widget.settingsState,
              taskState: widget.taskState,
            ),
          ),
        );
      },
    );
  }
}
