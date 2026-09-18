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
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionHome => 'Home';

  @override
  String get sectionAppDrawer => 'App drawer';

  @override
  String get sectionTasks => 'Tasks';

  @override
  String get sectionModules => 'Modules';

  @override
  String get sectionSupport => 'Support';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionSearch => 'Search';

  @override
  String get sectionWork => 'Work profile';

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
  String get themeStyleTitle => 'Style';

  @override
  String get themeStyleStandard => 'Standard';

  @override
  String get themeStyleCustom => 'Custom';

  @override
  String get fontTitle => 'Font';

  @override
  String get fontStandard => 'Standard';

  @override
  String get fontMono => 'Monospace';

  @override
  String get textSizeTitle => 'Text size';

  @override
  String get textAlignTitle => 'Text alignment';

  @override
  String get alignLeft => 'Left';

  @override
  String get alignCenter => 'Center';

  @override
  String get alignRight => 'Right';

  @override
  String get accentColor => 'Accent color';

  @override
  String get accentColorSubtitle =>
      'Tint text and background with your system accent';

  @override
  String get terminalPrompt => 'Terminal prompt';

  @override
  String get terminalPromptSubtitle => 'Show search as a command line';

  @override
  String get sectionEffects => 'Effects';

  @override
  String get effectsDarkOnly => 'Dark mode only';

  @override
  String get glow => 'Glow';

  @override
  String get scanlines => 'Scanlines';

  @override
  String get scanlinesOff => 'Off';

  @override
  String get scanlinesLight => 'Light';

  @override
  String get scanlinesMedium => 'Medium';

  @override
  String get scanlinesStrong => 'Strong';

  @override
  String get animations => 'Animations';

  @override
  String get animationsSubtitle =>
      'Moving scanlines, glitches and a blinking cursor';

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
  String get leftOfHome => 'Left module';

  @override
  String get rightOfHome => 'Right module';

  @override
  String get panelNone => 'None';

  @override
  String get lockLayout => 'Lock layout';

  @override
  String get lockLayoutSubtitle =>
      'Disable pinning and long press on the home screen';

  @override
  String get doubleTapToSleep => 'Double tap to sleep';

  @override
  String get doubleTapToSleepSubtitle =>
      'Requires accessibility service enabled in system settings';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Set as default home app';

  @override
  String get setAsDefaultSubtitle => 'Open the system picker';

  @override
  String get drawerMode => 'Drawer mode';

  @override
  String get drawerModeList => 'List';

  @override
  String get searchOnlyMode => 'Search only';

  @override
  String get searchOnlyModeSubtitle => 'Hide app names, search to launch';

  @override
  String get prefixNoApp => 'No app can open this';

  @override
  String get prefixTypeWork => 'Work apps';

  @override
  String get prefixTypePersonal => 'Personal apps';

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
  String get quickLaunchHints => 'Quick launch hints';

  @override
  String get quickLaunchHintsSubtitle =>
      'Highlight shortest unique characters to launch';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'tasks';

  @override
  String get panelLaunchApp => 'Launch app';

  @override
  String get panelLaunchAppHint => 'an app';

  @override
  String get launchAppLeft => 'Left app';

  @override
  String get launchAppRight => 'Right app';

  @override
  String get launchAppChoose => 'Choose an app';

  @override
  String get launchAppOnlyLeft => 'Only while this is the left module';

  @override
  String get launchAppOnlyRight => 'Only while this is the right module';

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
  String get backupTitle => 'Backup & restore';

  @override
  String get backupExport => 'Export backup';

  @override
  String get backupExportSubtitle =>
      'Save settings, labels, hidden and pinned apps to a file';

  @override
  String get backupRestore => 'Restore backup';

  @override
  String get backupRestoreSubtitle => 'Replace everything with a saved backup';

  @override
  String get backupAlsoInclude => 'Also include';

  @override
  String get backupRestoreConfirm =>
      'This replaces the current settings, labels, hidden and pinned apps.';

  @override
  String get backupExportAction => 'Export';

  @override
  String get backupRestoreAction => 'Restore';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get backupInvalid => 'This file isn\'t a Last Launcher backup';

  @override
  String get backupTooNew =>
      'This backup is from a newer version of Last Launcher';

  @override
  String get backupFailed => 'Couldn\'t read or write the file';

  @override
  String get hintSwipeUp => 'Swipe up for apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Swipe right for $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Swipe left for $module';
  }

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
  String get actionRemove => 'Remove';

  @override
  String get actionClose => 'Close';

  @override
  String get actionAppInfo => 'App info';

  @override
  String get actionEnable => 'Enable';

  @override
  String get renameDialogTitle => 'Rename';

  @override
  String get renameDialogCancel => 'Cancel';

  @override
  String get renameDialogSave => 'Save';

  @override
  String get showWorkAppDot => 'Show work app dot';

  @override
  String get showWorkAppDotSubtitle =>
      'Show a small dot in front of work profile apps';

  @override
  String get showWorkAppDotOnHome => 'Show work dot on home screen';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Show work profile dot on pinned home screen apps';

  @override
  String get hidePersonalWhenWorkActive => 'Don\'t show non-work apps';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Non-work apps reappear when work profile is paused';

  @override
  String get homeScreenFull => 'Home screen is full';
}
