import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/launcher_panel.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsState state;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(prefs);
  });

  group('SettingsState defaults', () {
    test('theme defaults to system', () {
      expect(state.themeMode, ThemeMode.system);
      expect(state.isExtra, false);
      expect(state.themeValue, 'system');
    });

    test('boolean defaults', () {
      expect(state.autoKeyboard, true);
      expect(state.autoKeyboardTasks, true);
      expect(state.searchOnly, false);
      expect(state.autoLaunch, true);
      expect(state.tasksEnabled, false);
      expect(state.showHints, true);
      expect(state.removeOnComplete, false);
      expect(state.hideStatusBar, false);
    });
  });

  group('SettingsState theme', () {
    test('sets light theme', () async {
      await state.setTheme('light');
      expect(state.themeMode, ThemeMode.light);
      expect(state.themeValue, 'light');
      expect(state.isExtra, false);
    });

    test('sets dark theme', () async {
      await state.setTheme('dark');
      expect(state.themeMode, ThemeMode.dark);
      expect(state.themeValue, 'dark');
    });

    test('sets extra theme', () async {
      await state.setTheme('extra');
      expect(state.themeMode, ThemeMode.dark);
      expect(state.isExtra, true);
      expect(state.themeValue, 'extra');
    });

    test('extra to system clears extra', () async {
      await state.setTheme('extra');
      await state.setTheme('system');
      expect(state.isExtra, false);
      expect(state.themeMode, ThemeMode.system);
    });

    test('increments themeNotifier', () async {
      final initial = state.themeNotifier.value;
      await state.setTheme('dark');
      expect(state.themeNotifier.value, initial + 1);
    });
  });

  group('SettingsState toggles', () {
    test('setAutoKeyboard', () async {
      await state.setAutoKeyboard(false);
      expect(state.autoKeyboard, false);
    });

    test('setSearchOnly', () async {
      await state.setSearchOnly(true);
      expect(state.searchOnly, true);
    });

    test('setLeftPanel enables tasks', () async {
      await state.setLeftPanel(LauncherPanel.tasks);
      expect(state.leftPanel, LauncherPanel.tasks);
      expect(state.tasksEnabled, true);
    });

    test('setLeftPanel auto-clears conflicting right panel', () async {
      await state.setRightPanel(LauncherPanel.tasks);
      await state.setLeftPanel(LauncherPanel.tasks);
      expect(state.leftPanel, LauncherPanel.tasks);
      expect(state.rightPanel, LauncherPanel.none);
    });

    test('setRemoveOnComplete', () async {
      await state.setRemoveOnComplete(true);
      expect(state.removeOnComplete, true);
    });

    test('setHideStatusBar increments themeNotifier', () async {
      final initial = state.themeNotifier.value;
      await state.setHideStatusBar(true);
      expect(state.hideStatusBar, true);
      expect(state.themeNotifier.value, initial + 1);
    });
  });

  group('SettingsState persistence', () {
    test('persists and restores all settings', () async {
      await state.setTheme('extra');
      await state.setAutoKeyboard(false);
      await state.setSearchOnly(true);
      await state.setLeftPanel(LauncherPanel.tasks);
      await state.setRemoveOnComplete(true);
      await state.setHideStatusBar(true);

      final prefs = await SharedPreferences.getInstance();
      final restored = SettingsState(prefs);
      expect(restored.isExtra, true);
      expect(restored.themeMode, ThemeMode.dark);
      expect(restored.autoKeyboard, false);
      expect(restored.searchOnly, true);
      expect(restored.leftPanel, LauncherPanel.tasks);
      expect(restored.tasksEnabled, true);
      expect(restored.removeOnComplete, true);
      expect(restored.hideStatusBar, true);
    });

    test('migrates legacy tasks_enabled flag', () async {
      SharedPreferences.setMockInitialValues({'tasks_enabled': true});
      final prefs = await SharedPreferences.getInstance();
      final migrated = SettingsState(prefs);
      expect(migrated.leftPanel, LauncherPanel.tasks);
      expect(migrated.rightPanel, LauncherPanel.none);
      expect(migrated.tasksEnabled, true);
    });
  });

  group('SettingsState notifications', () {
    test('notifies on every setter', () async {
      var count = 0;
      state.addListener(() => count++);

      await state.setTheme('dark');
      await state.setAutoKeyboard(false);
      await state.setSearchOnly(true);
      await state.setAutoLaunch(false);
      await state.setLeftPanel(LauncherPanel.tasks);
      await state.setShowHints(false);
      await state.setRemoveOnComplete(true);
      await state.setHideStatusBar(true);

      expect(count, 8);
    });
  });
}
