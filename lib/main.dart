import 'package:flutter/material.dart';
import 'package:last_launcher/app.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final appChannel = AppChannel()..initialize();
  final homeState = HomeState(prefs);
  final appListState = AppListState(appChannel, prefs);
  final settingsState = SettingsState(prefs);
  final taskState = TaskState(prefs);
  await appListState.loadApps();

  runApp(
    LastLauncherApp(
      appChannel: appChannel,
      homeState: homeState,
      appListState: appListState,
      settingsState: settingsState,
      taskState: taskState,
    ),
  );
}
