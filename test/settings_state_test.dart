import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    test('theme defaults to system, standard style', () {
      expect(state.themeMode.value, ThemeMode.system);
      expect(state.themeStyle.value, ThemeStyle.standard);
      expect(state.effectiveThemeMode, ThemeMode.system);
      expect(state.isExtra, false);
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

  group('SettingsState theme', () {
    test('mode applies in the standard style', () {
      state.themeMode.value = ThemeMode.light;
      expect(state.effectiveThemeMode, ThemeMode.light);
      expect(state.themeModeAvailable, true);
    });

    test('extra is always dark but keeps the chosen mode', () {
      state.themeMode.value = ThemeMode.light;
      state.themeStyle.value = ThemeStyle.extra;
      expect(state.isExtra, true);
      expect(state.themeModeAvailable, false);
      expect(state.effectiveThemeMode, ThemeMode.dark);

      state.themeStyle.value = ThemeStyle.standard;
      expect(state.effectiveThemeMode, ThemeMode.light);
    });

    test('migrates the old extra theme mode to dark plus extra', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'extra'});
      final migrated = await _reload();
      expect(migrated.themeMode.value, ThemeMode.dark);
      expect(migrated.themeStyle.value, ThemeStyle.extra);

      // And stays migrated.
      final again = await _reload();
      expect(again.themeStyle.value, ThemeStyle.extra);
    });

    test('keeps reading the old light and dark values', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final restored = await _reload();
      expect(restored.themeMode.value, ThemeMode.light);
      expect(restored.themeStyle.value, ThemeStyle.standard);
    });

    test('theme and status bar changes signal an app rebuild', () {
      var count = 0;
      state.appearanceChanged.addListener(() => count++);
      state.themeMode.value = ThemeMode.dark;
      state.themeStyle.value = ThemeStyle.extra;
      state.hideStatusBar.value = true;
      state.autoKeyboard.value = false;
      expect(count, 3);
    });
  });

  group('SettingsState panels', () {
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

    test('quick-launch options need auto-launch and the list', () {
      state.extraChar.value = true;
      state.quickLaunchHints.value = true;
      expect(state.extraCharActive, true);
      expect(state.quickLaunchHintsActive, true);

      state.autoLaunch.value = false;
      expect(state.quickLaunchOptionsAvailable, false);
      expect(state.extraCharActive, false);
      expect(state.quickLaunchHintsActive, false);

      state.autoLaunch.value = true;
      state.searchOnly.value = true;
      expect(state.extraCharActive, false);
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
      state.themeStyle.value = ThemeStyle.extra;
      state.autoKeyboard.value = false;
      state.searchOnly.value = true;
      state.setLeftPanel(TasksModule());
      state.removeOnComplete.value = true;
      state.hideStatusBar.value = true;

      final restored = await _reload();
      expect(restored.isExtra, true);
      expect(restored.effectiveThemeMode, ThemeMode.dark);
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
