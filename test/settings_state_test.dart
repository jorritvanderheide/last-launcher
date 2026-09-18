import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/modules/none_module.dart';
import 'package:last_launcher/features/modules/tasks_module.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsState> _reload() async =>
    SettingsState(await SharedPreferences.getInstance());

void main() {
  late SettingsState state;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    state = await _reload();
  });

  group('SettingsState defaults', () {
    test('look defaults to system, standard', () {
      expect(state.themeMode.value, ThemeMode.system);
      expect(state.preset, ThemePreset.standard);
      expect(state.font.value, FontChoice.standard);
      expect(state.glow.value, false);
      expect(state.scanlines.value, ScanlineLevel.off);
      expect(state.terminalPrompt.value, false);
      expect(state.animations.value, true);
      expect(state.labelAlignment.value, LabelAlignment.left);
    });

    test('boolean defaults', () {
      expect(state.autoKeyboard.value, true);
      expect(state.autoKeyboardTasks.value, true);
      expect(state.searchOnly.value, false);
      expect(state.autoLaunch.value, true);
      expect(state.showHints.value, true);
      expect(state.removeOnComplete.value, false);
      expect(state.hideStatusBar.value, false);
      expect(state.leftPanel.value, isA<NoneModule>());
      expect(state.rightPanel.value, isA<NoneModule>());
    });
  });

  group('SettingsState look', () {
    test('extra preset sets its options and dark mode', () {
      state.themeMode.value = ThemeMode.light;
      state.applyPreset(ThemePreset.extra);
      expect(state.preset, ThemePreset.extra);
      expect(state.themeMode.value, ThemeMode.dark);
      expect(state.font.value, FontChoice.mono);
      expect(state.glow.value, true);
      expect(state.scanlines.value, ScanlineLevel.medium);
      expect(state.terminalPrompt.value, true);
    });

    test('animations only apply with something to animate', () {
      expect(state.animations.value, true);
      expect(state.animationsAvailable, false);
      expect(state.animationsActive, false);

      state.scanlines.value = ScanlineLevel.light;
      expect(state.animationsActive, true);

      state.scanlines.value = ScanlineLevel.off;
      state.terminalPrompt.value = true;
      expect(state.animationsActive, true);
    });

    test('changing one option makes the look custom', () {
      state.applyPreset(ThemePreset.extra);
      state.scanlines.value = ScanlineLevel.strong;
      expect(state.preset, ThemePreset.custom);

      state.applyPreset(ThemePreset.standard);
      state.font.value = FontChoice.mono;
      expect(state.preset, ThemePreset.custom);
    });

    test('standard preset clears the effects but keeps the mode', () {
      state.applyPreset(ThemePreset.extra);
      state.applyPreset(ThemePreset.standard);
      expect(state.preset, ThemePreset.standard);
      expect(state.themeMode.value, ThemeMode.dark);
    });

    test('migrates the released extra theme to the extra preset', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'extra'});
      final migrated = await _reload();
      expect(migrated.themeMode.value, ThemeMode.dark);
      expect(migrated.preset, ThemePreset.extra);

      // And stays migrated.
      expect((await _reload()).preset, ThemePreset.extra);
    });

    test('migrates the development-only theme_style too', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'light',
        'theme_style': 'extra',
      });
      final migrated = await _reload();
      expect(migrated.preset, ThemePreset.extra);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('theme_style'), false);
    });

    test('keeps reading the old light and dark values', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final restored = await _reload();
      expect(restored.themeMode.value, ThemeMode.light);
      expect(restored.preset, ThemePreset.standard);
    });

    test('look and status bar changes signal an app rebuild', () {
      var count = 0;
      state.appearanceChanged.addListener(() => count++);
      state.themeMode.value = ThemeMode.dark;
      state.glow.value = true;
      state.hideStatusBar.value = true;
      state.autoKeyboard.value = false;
      expect(count, 3);
    });
  });

  group('SettingsState text size', () {
    test('defaults to the original size, in the middle of the range', () {
      expect(state.textSize.value, SettingsState.defaultTextSize);
      expect(
        (SettingsState.textSizeMin + SettingsState.textSizeMax) / 2,
        SettingsState.defaultTextSize,
      );
    });

    test('persists a chosen size', () async {
      state.textSize.value = 24;
      expect((await _reload()).textSize.value, 24);
    });

    test('keeps a stored size within range', () async {
      SharedPreferences.setMockInitialValues({'text_size': 90.0});
      expect((await _reload()).textSize.value, SettingsState.textSizeMax);
    });

    test('migrates the development-only size names', () async {
      for (final (name, size) in [
        ('small', 22.0),
        ('medium', 28.0),
        ('large', 34.0),
      ]) {
        SharedPreferences.setMockInitialValues({'text_size': name});
        expect((await _reload()).textSize.value, size);
      }
    });
  });

  group('SettingsState stored by another version', () {
    test('a value of the wrong type reads as the default', () async {
      SharedPreferences.setMockInitialValues({
        // The reported crash: a number where text was expected, and back.
        'theme_mode': 28.0,
        'font': 1.5,
        'locked': 'yes',
        'text_size': true,
        'left_panel': 3,
        'launch_app_left': false,
      });
      final state = await _reload();
      expect(state.themeMode.value, ThemeMode.system);
      expect(state.font.value, FontChoice.standard);
      expect(state.locked.value, false);
      expect(state.textSize.value, SettingsState.defaultTextSize);
      expect(state.leftPanel.value, isA<NoneModule>());
      expect(state.launchAppLeft.value, isNull);
    });

    test('a whole-number size reads as a size', () async {
      SharedPreferences.setMockInitialValues({'text_size': 24});
      expect((await _reload()).textSize.value, 24.0);
    });
  });

  group('SettingsState panels', () {
    test('a module that allows both sides keeps both', () {
      const everywhere = _EverywhereModule();
      state.setLeftPanel(everywhere);
      state.setRightPanel(everywhere);
      expect(state.leftPanel.value.id, everywhere.id);
      expect(state.rightPanel.value.id, everywhere.id);
    });

    test('setLeftPanel', () {
      state.setLeftPanel(TasksModule());
      expect(state.leftPanel.value, isA<TasksModule>());
    });

    test('setLeftPanel auto-clears conflicting right panel', () {
      state.setRightPanel(TasksModule());
      state.setLeftPanel(TasksModule());
      expect(state.leftPanel.value, isA<TasksModule>());
      expect(state.rightPanel.value, isA<NoneModule>());
    });
  });

  group('SettingsState derived rules', () {
    test('search-only mode forces keyboard and auto-launch on', () {
      state.autoKeyboard.value = false;
      state.autoLaunch.value = false;
      state.searchOnly.value = true;
      expect(state.autoKeyboardActive, true);
      expect(state.autoLaunchActive, true);
      // The user's own choices are untouched.
      expect(state.autoKeyboard.value, false);
      expect(state.autoLaunch.value, false);
    });

    test('quick-launch options need auto-launch', () {
      state.extraChar.value = true;
      state.quickLaunchHints.value = true;
      expect(state.extraCharActive, true);
      expect(state.quickLaunchHintsActive, true);

      state.autoLaunch.value = false;
      expect(state.extraCharAvailable, false);
      expect(state.quickLaunchHintsAvailable, false);
      expect(state.extraCharActive, false);
      expect(state.quickLaunchHintsActive, false);
    });

    test('search-only keeps extra character but has no hints', () {
      state.extraChar.value = true;
      state.quickLaunchHints.value = true;
      state.autoLaunch.value = false;
      state.searchOnly.value = true;
      // Search-only launches on its own, so extra character applies.
      expect(state.extraCharAvailable, true);
      expect(state.extraCharActive, true);
      expect(state.quickLaunchHintsActive, false);
    });

    test('work dots follow hide-personal and each other', () {
      state.showWorkAppDotOnHome.value = true;
      expect(state.workAppDotActive, true);
      expect(state.workAppDotOnHomeActive, true);

      state.showWorkAppDot.value = false;
      expect(state.workAppDotOnHomeActive, false);

      state.showWorkAppDot.value = true;
      state.hidePersonalWhenWorkActive.value = true;
      expect(state.workAppDotAvailable, false);
      expect(state.workAppDotActive, false);
      expect(state.workAppDotOnHomeActive, false);
    });

    test('suppressed choices survive a restart', () async {
      state.quickLaunchHints.value = true;
      state.extraChar.value = true;
      state.showWorkAppDotOnHome.value = true;
      state.autoLaunch.value = false;
      state.hidePersonalWhenWorkActive.value = true;

      final restored = await _reload();
      restored.autoLaunch.value = true;
      restored.hidePersonalWhenWorkActive.value = false;
      expect(restored.quickLaunchHintsActive, true);
      expect(restored.extraCharActive, true);
      expect(restored.workAppDotOnHomeActive, true);
    });
  });

  group('SettingsState persistence', () {
    test('persists and restores settings', () async {
      state.applyPreset(ThemePreset.extra);
      state.autoKeyboard.value = false;
      state.searchOnly.value = true;
      state.setLeftPanel(TasksModule());
      state.removeOnComplete.value = true;
      state.hideStatusBar.value = true;

      final restored = await _reload();
      expect(restored.preset, ThemePreset.extra);
      expect(restored.themeMode.value, ThemeMode.dark);
      expect(restored.autoKeyboard.value, false);
      expect(restored.searchOnly.value, true);
      expect(restored.leftPanel.value, isA<TasksModule>());
      expect(restored.removeOnComplete.value, true);
      expect(restored.hideStatusBar.value, true);
    });

    test('migrates legacy tasks_enabled=true flag', () async {
      SharedPreferences.setMockInitialValues({'tasks_enabled': true});
      final migrated = await _reload();
      expect(migrated.leftPanel.value, isA<TasksModule>());
      expect(migrated.rightPanel.value, isA<NoneModule>());
    });

    test('migrates legacy tasks_enabled=false flag', () async {
      SharedPreferences.setMockInitialValues({'tasks_enabled': false});
      final migrated = await _reload();
      expect(migrated.leftPanel.value, isA<NoneModule>());
      expect(migrated.rightPanel.value, isA<NoneModule>());
    });
  });

  group('SettingsState notifications', () {
    test('notifies once per actual change', () {
      var count = 0;
      state.addListener(() => count++);

      state.themeMode.value = ThemeMode.dark;
      state.autoKeyboard.value = false;
      state.searchOnly.value = true;
      state.autoLaunch.value = false;
      state.setLeftPanel(TasksModule());
      state.showHints.value = false;
      state.removeOnComplete.value = true;
      state.hideStatusBar.value = true;
      // Unchanged values neither notify nor write.
      state.hideStatusBar.value = true;

      expect(count, 8);
    });
  });
}

class _EverywhereModule extends LauncherModule {
  const _EverywhereModule();

  @override
  String get id => 'everywhere';

  @override
  bool get allowsBothSides => true;

  @override
  String displayName(BuildContext context) => 'Everywhere';

  @override
  String hintName(BuildContext context, ModuleSide side, ModuleDeps deps) =>
      'everywhere';

  @override
  Widget build(BuildContext context, LauncherModuleProps props) =>
      const SizedBox.shrink();
}
