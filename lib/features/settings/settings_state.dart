import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/features/modules/tasks_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontChoice { standard, mono }

enum TextSize { small, medium, large }

enum ScanlineLevel { off, light, medium, strong }

/// A named bundle of look options. Derived from the options themselves:
/// changing any one of them after picking a preset makes it [custom].
enum ThemePreset { standard, extra, custom }

class SearchPrefs {
  const SearchPrefs({
    required this.matchOriginal,
    required this.includeHidden,
    required this.hidePersonalWhenWorkActive,
  });

  final bool matchOriginal;
  final bool includeHidden;
  final bool hidePersonalWhenWorkActive;
}

/// One persisted setting. Assigning [value] stores it and notifies.
class Setting<T> extends ValueNotifier<T> {
  Setting(this.key, this._read, this._write) : super(_read());

  /// SharedPreferences key the value lives under. Never rename one: it is
  /// where existing users' choices are stored.
  final String key;
  final T Function() _read;
  final Future<bool> Function(T) _write;

  /// Picks up a value stored behind this setting's back, e.g. by a restore.
  void reload() => super.value = _read();

  @override
  set value(T newValue) {
    if (newValue == value) return;
    super.value = newValue;
    unawaited(_write(newValue));
  }
}

/// All user settings.
///
/// Each setting is declared once below, with its key, type and default on one
/// line. Rules that tie settings together are derived getters
/// ([autoLaunchActive], [workAppDotActive], ...) and never writes, so what the
/// user picked is kept as-is and comes back when the rule stops applying.
///
/// Listening to the whole object fires on any change; listen to a single
/// [Setting] to react to just that one.
class SettingsState extends ChangeNotifier {
  SettingsState(this._prefs) {
    _migrate();
  }

  final SharedPreferences _prefs;

  // --- Appearance --------------------------------------------------------

  late final themeMode = _enum(
    'theme_mode',
    ThemeMode.values,
    ThemeMode.system,
  );
  late final font = _enum('font', FontChoice.values, FontChoice.standard);
  late final textSize = _enum('text_size', TextSize.values, TextSize.medium);
  late final accentColor = _bool('accent_color', false);
  late final terminalPrompt = _bool('terminal_prompt', false);
  // Effects: only drawn in dark mode, where they were designed.
  late final glow = _bool('glow', false);
  late final scanlines = _enum(
    'scanlines',
    ScanlineLevel.values,
    ScanlineLevel.off,
  );
  late final animations = _bool('animations', true);
  late final hideStatusBar = _bool('hide_status_bar', false);
  late final showHints = _bool('show_hints', true);

  // --- Home --------------------------------------------------------------

  late final locked = _bool('locked', false);
  late final doubleTapToSleep = _bool('double_tap_to_sleep', true);
  late final _leftPanel = _module('left_panel');
  late final _rightPanel = _module('right_panel');

  // --- App drawer and search ---------------------------------------------

  late final hidePinnedFromDrawer = _bool('hide_pinned_from_drawer', true);
  late final includeHiddenInSearch = _bool('include_hidden_in_search', false);
  late final matchOriginalName = _bool('match_original_name', true);
  late final searchOnly = _bool('search_only', false);
  late final autoKeyboard = _bool('auto_keyboard', true);
  late final autoLaunch = _bool('auto_launch', true);
  late final extraChar = _bool('extra_char', false);
  late final quickLaunchHints = _bool('quick_launch_hints', false);

  // --- Work profile ------------------------------------------------------

  late final hidePersonalWhenWorkActive = _bool(
    'hide_personal_when_work_active',
    false,
  );
  late final showWorkAppDot = _bool('show_work_app_dot', true);
  late final showWorkAppDotOnHome = _bool('show_work_app_dot_on_home', false);

  // --- Tasks -------------------------------------------------------------

  late final autoKeyboardTasks = _bool('auto_keyboard_tasks', true);
  late final removeOnComplete = _bool('remove_on_complete', false);
  late final clearCompletedDaily = _bool('clear_completed_daily', false);

  // --- Derived: what is actually in effect -------------------------------

  ThemePreset get preset {
    final mono = font.value == FontChoice.mono;
    if (mono &&
        glow.value &&
        scanlines.value == ScanlineLevel.medium &&
        terminalPrompt.value &&
        animations.value) {
      return ThemePreset.extra;
    }
    if (!mono &&
        !glow.value &&
        scanlines.value == ScanlineLevel.off &&
        !terminalPrompt.value) {
      return ThemePreset.standard;
    }
    return ThemePreset.custom;
  }

  /// Sets every option a preset covers. Extra also switches to dark mode,
  /// since its effects only show there.
  void applyPreset(ThemePreset preset) {
    switch (preset) {
      case ThemePreset.extra:
        themeMode.value = ThemeMode.dark;
        font.value = FontChoice.mono;
        glow.value = true;
        scanlines.value = ScanlineLevel.medium;
        terminalPrompt.value = true;
        animations.value = true;
      case ThemePreset.standard:
        font.value = FontChoice.standard;
        glow.value = false;
        scanlines.value = ScanlineLevel.off;
        terminalPrompt.value = false;
      case ThemePreset.custom:
        break;
    }
  }

  /// Search-only mode has no list to scroll, so the keyboard is always up.
  bool get autoKeyboardActive => searchOnly.value || autoKeyboard.value;

  /// Search-only mode always launches the single remaining match.
  bool get autoLaunchActive => searchOnly.value || autoLaunch.value;

  /// The quick-launch refinements build on auto-launch in the drawer's list,
  /// which search-only mode doesn't show.
  bool get quickLaunchOptionsAvailable => !searchOnly.value && autoLaunch.value;

  bool get extraCharActive => quickLaunchOptionsAvailable && extraChar.value;

  bool get quickLaunchHintsActive =>
      quickLaunchOptionsAvailable && quickLaunchHints.value;

  /// With personal apps hidden there is nothing to tell work apps apart from.
  bool get workAppDotAvailable => !hidePersonalWhenWorkActive.value;

  bool get workAppDotActive => workAppDotAvailable && showWorkAppDot.value;

  bool get workAppDotOnHomeActive =>
      workAppDotActive && showWorkAppDotOnHome.value;

  SearchPrefs get searchPrefs => SearchPrefs(
    matchOriginal: matchOriginalName.value,
    includeHidden: includeHiddenInSearch.value,
    hidePersonalWhenWorkActive: hidePersonalWhenWorkActive.value,
  );

  /// Fires when anything in [searchPrefs] changes.
  late final Listenable searchPrefsChanged = Listenable.merge([
    matchOriginalName,
    includeHiddenInSearch,
    hidePersonalWhenWorkActive,
  ]);

  /// Fires when anything that needs the whole [MaterialApp] rebuilt changes,
  /// so routine settings don't rebuild the entire app.
  late final Listenable appearanceChanged = Listenable.merge([
    themeMode,
    font,
    textSize,
    accentColor,
    terminalPrompt,
    glow,
    scanlines,
    animations,
    hideStatusBar,
  ]);

  // --- Panels ------------------------------------------------------------

  ValueListenable<LauncherModule> get leftPanel => _leftPanel;
  ValueListenable<LauncherModule> get rightPanel => _rightPanel;

  void setLeftPanel(LauncherModule panel) =>
      _setPanel(_leftPanel, _rightPanel, panel);

  void setRightPanel(LauncherModule panel) =>
      _setPanel(_rightPanel, _leftPanel, panel);

  /// A module can only sit on one side, so taking it for one side clears the
  /// other.
  void _setPanel(
    Setting<LauncherModule> side,
    Setting<LauncherModule> other,
    LauncherModule panel,
  ) {
    if (panel is! NoneModule && other.value.id == panel.id) {
      other.value = const NoneModule();
    }
    side.value = panel;
  }

  // --- Migrations --------------------------------------------------------

  /// Rewrites values stored by older versions, before any setting reads them.
  /// Settings are created lazily, so doing this up front keeps each one's
  /// initial value independent of which was created first.
  void _migrate() {
    // Extra used to be a fourth theme mode next to system, light and dark.
    // It is now a preset of separate options, and was always shown dark.
    // theme_style only ever existed in development builds.
    final wasExtra =
        _prefs.getString('theme_mode') == 'extra' ||
        _prefs.getString('theme_style') == 'extra';
    if (wasExtra) {
      unawaited(_prefs.setString('theme_mode', ThemeMode.dark.name));
      unawaited(_prefs.setString('font', FontChoice.mono.name));
      unawaited(_prefs.setBool('glow', true));
      unawaited(_prefs.setString('scanlines', ScanlineLevel.medium.name));
      unawaited(_prefs.setBool('terminal_prompt', true));
      unawaited(_prefs.setBool('animations', true));
    }
    unawaited(_prefs.remove('theme_style'));

    // Before either side was configurable there was only a tasks_enabled
    // flag, which meant tasks on the left.
    final panelsNeverChosen =
        _prefs.getString('left_panel') == null &&
        _prefs.getString('right_panel') == null;
    if (panelsNeverChosen && (_prefs.getBool('tasks_enabled') ?? false)) {
      unawaited(_prefs.setString('left_panel', TasksModule().id));
    }
  }

  // --- Declaration helpers -----------------------------------------------

  Setting<bool> _bool(String key, bool fallback) => _track(
    Setting(
      key,
      () => _prefs.getBool(key) ?? fallback,
      (v) => _prefs.setBool(key, v),
    ),
  );

  /// Stored by name, so reordering an enum's values is safe; renaming one is
  /// not.
  Setting<T> _enum<T extends Enum>(String key, List<T> values, T fallback) =>
      _track(
        Setting(
          key,
          () => values.asNameMap()[_prefs.getString(key)] ?? fallback,
          (v) => _prefs.setString(key, v.name),
        ),
      );

  Setting<LauncherModule> _module(String key) => _track(
    Setting(
      key,
      () => moduleById(_prefs.getString(key)),
      (m) => _prefs.setString(key, m.id),
    ),
  );

  Setting<T> _track<T>(Setting<T> setting) {
    setting.addListener(notifyListeners);
    _created.add(setting);
    return setting;
  }

  /// Settings are created on first use; these are the ones that exist.
  final _created = <Setting<Object?>>[];

  /// Re-reads everything from storage after it was replaced wholesale, e.g.
  /// by restoring a backup. Settings not created yet read fresh anyway.
  void reload() {
    _migrate();
    for (final setting in _created) {
      setting.reload();
    }
  }
}
