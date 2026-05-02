// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'The last launcher you\'ll ever need';

  @override
  String get settings => 'Settings';

  @override
  String get sectionGeneral => 'General';

  @override
  String get sectionAppDrawer => 'App drawer';

  @override
  String get sectionTasks => 'Tasks';

  @override
  String get sectionSupport => 'Support';

  @override
  String get sectionAbout => 'About';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Fullscreen';

  @override
  String get hideStatusBarSubtitle => 'Hide status bar and navigation';

  @override
  String get showHints => 'Show hints';

  @override
  String get showHintsSubtitle => 'Show usage hints throughout the app';

  @override
  String get hidePinnedApps => 'Hide pinned apps';

  @override
  String get hidePinnedAppsSubtitle => 'Hide pinned apps from the app drawer';

  @override
  String get includeHiddenInSearch => 'Include hidden in search';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Let search also match hidden apps';

  @override
  String get matchOriginalName => 'Match original name';

  @override
  String get matchOriginalNameSubtitle =>
      'Find renamed apps by their original name';

  @override
  String get hiddenApps => 'Hidden apps';

  @override
  String get hiddenAppsNone => 'None';

  @override
  String hiddenAppsCount(int count) {
    return '$count hidden';
  }

  @override
  String get noHiddenApps => 'No hidden apps';

  @override
  String get lockLayout => 'Lock layout';

  @override
  String get lockLayoutSubtitle =>
      'Disable pinning and long press on the home and task screens';

  @override
  String get searchOnlyMode => 'Search only';

  @override
  String get searchOnlyModeSubtitle => 'Hide app names, search to launch';

  @override
  String get autoShowKeyboard => 'Show keyboard';

  @override
  String get autoShowKeyboardAppsSubtitle => 'Open keyboard when drawer opens';

  @override
  String get autoShowKeyboardTasksSubtitle => 'Open keyboard when tasks open';

  @override
  String get autoLaunchOnMatch => 'Auto-launch on match';

  @override
  String get autoLaunchOnMatchSubtitle => 'Launch when one app matches';

  @override
  String get taskScreen => 'Task screen';

  @override
  String get taskScreenSubtitle => 'Swipe right from home to view tasks';

  @override
  String get removeOnComplete => 'Remove on complete';

  @override
  String get removeOnCompleteSubtitle => 'Remove tasks when marked as done';

  @override
  String get clearCompletedDaily => 'Clear completed daily';

  @override
  String get clearCompletedDailySubtitle =>
      'Remove completed tasks at the end of the day';

  @override
  String get taskOptionDisabled => 'Enable Task screen to configure';

  @override
  String get donate => 'Donate';

  @override
  String get donateSubtitle => 'Support the development of Last Launcher';

  @override
  String get rateApp => 'Rate Last Launcher';

  @override
  String get rateAppSubtitle => 'Leave a review on the Play Store';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get sendFeedbackSubtitle => 'Email the developer';

  @override
  String get help => 'Help';

  @override
  String get helpSubtitle => 'View the project page';

  @override
  String get version => 'Version';

  @override
  String get license => 'License';

  @override
  String get openSourceLicenses => 'Open source licenses';

  @override
  String get aboutSubtitle => 'Version and licenses';

  @override
  String get hintSwipeUp => 'Swipe up to search';

  @override
  String get hintSwipeRight => 'Swipe right for tasks';

  @override
  String get hintLongPress => 'Long press for settings';

  @override
  String get noResults => 'No results';

  @override
  String get emptyTaskList => 'Type to add a task';

  @override
  String get returnToAddTask => 'Press return to add a task';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionUnpin => 'Unpin';

  @override
  String get actionPin => 'Pin';

  @override
  String get actionPinFull => 'Full';

  @override
  String get actionHide => 'Hide';

  @override
  String get actionUnhide => 'Unhide';

  @override
  String get actionDone => 'Done';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionClose => 'Close';

  @override
  String get actionAppInfo => 'App info';

  @override
  String get renameDialogTitle => 'Rename';

  @override
  String get renameDialogCancel => 'Cancel';

  @override
  String get renameDialogSave => 'Save';

  @override
  String get homeScreenFull => 'Home screen is full';
}
