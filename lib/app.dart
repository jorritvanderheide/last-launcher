import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/app_theme.dart';
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

/// How strongly each scanline level draws, relative to the original look.
double _scanlineStrength(ScanlineLevel level) => switch (level) {
  ScanlineLevel.off => 0,
  ScanlineLevel.light => 0.5,
  ScanlineLevel.medium => 1,
  ScanlineLevel.strong => 2,
};

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
    await widget.homeState.pruneMissing(
      widget.appListState.allApps,
      hasWorkProfile: widget.appListState.hasWorkProfile,
    );
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
          theme: themeFor(Brightness.light, spec),
          darkTheme: themeFor(Brightness.dark, spec),
          builder: (context, child) => SettingsTheme(
            data: themeFor(Theme.of(context).brightness, spec, settings: true),
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
