import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('sv'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Launcher'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'The last launcher you\'ll ever need'**
  String get appTagline;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get sectionHome;

  /// No description provided for @sectionAppDrawer.
  ///
  /// In en, this message translates to:
  /// **'App drawer'**
  String get sectionAppDrawer;

  /// No description provided for @sectionTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get sectionTasks;

  /// No description provided for @sectionModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get sectionModules;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @sectionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sectionSearch;

  /// No description provided for @sectionWork.
  ///
  /// In en, this message translates to:
  /// **'Work profile'**
  String get sectionWork;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get themeExtra;

  /// No description provided for @themeStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get themeStyleTitle;

  /// No description provided for @themeStyleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get themeStyleStandard;

  /// No description provided for @themeStyleCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get themeStyleCustom;

  /// No description provided for @fontTitle.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get fontTitle;

  /// No description provided for @fontStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get fontStandard;

  /// No description provided for @fontMono.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get fontMono;

  /// No description provided for @textSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSizeTitle;

  /// No description provided for @textAlignTitle.
  ///
  /// In en, this message translates to:
  /// **'Text alignment'**
  String get textAlignTitle;

  /// No description provided for @alignLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get alignLeft;

  /// No description provided for @alignCenter.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get alignCenter;

  /// No description provided for @alignRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get alignRight;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @accentColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tint text and background with your system accent'**
  String get accentColorSubtitle;

  /// No description provided for @terminalPrompt.
  ///
  /// In en, this message translates to:
  /// **'Terminal prompt'**
  String get terminalPrompt;

  /// No description provided for @terminalPromptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show search as a command line'**
  String get terminalPromptSubtitle;

  /// No description provided for @sectionEffects.
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get sectionEffects;

  /// No description provided for @effectsDarkOnly.
  ///
  /// In en, this message translates to:
  /// **'Dark mode only'**
  String get effectsDarkOnly;

  /// No description provided for @glow.
  ///
  /// In en, this message translates to:
  /// **'Glow'**
  String get glow;

  /// No description provided for @scanlines.
  ///
  /// In en, this message translates to:
  /// **'Scanlines'**
  String get scanlines;

  /// No description provided for @scanlinesOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get scanlinesOff;

  /// No description provided for @scanlinesLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get scanlinesLight;

  /// No description provided for @scanlinesMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get scanlinesMedium;

  /// No description provided for @scanlinesStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get scanlinesStrong;

  /// No description provided for @animations.
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get animations;

  /// No description provided for @animationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Moving scanlines, glitches and a blinking cursor'**
  String get animationsSubtitle;

  /// No description provided for @hideStatusBar.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get hideStatusBar;

  /// No description provided for @hideStatusBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide status bar and navigation'**
  String get hideStatusBarSubtitle;

  /// No description provided for @showHints.
  ///
  /// In en, this message translates to:
  /// **'Show hints'**
  String get showHints;

  /// No description provided for @showHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show usage hints throughout the app'**
  String get showHintsSubtitle;

  /// No description provided for @hidePinnedApps.
  ///
  /// In en, this message translates to:
  /// **'Hide pinned apps'**
  String get hidePinnedApps;

  /// No description provided for @hidePinnedAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide pinned apps from the app drawer'**
  String get hidePinnedAppsSubtitle;

  /// No description provided for @includeHiddenInSearch.
  ///
  /// In en, this message translates to:
  /// **'Include hidden in search'**
  String get includeHiddenInSearch;

  /// No description provided for @includeHiddenInSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let search also match hidden apps'**
  String get includeHiddenInSearchSubtitle;

  /// No description provided for @matchOriginalName.
  ///
  /// In en, this message translates to:
  /// **'Match original name'**
  String get matchOriginalName;

  /// No description provided for @matchOriginalNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find renamed apps by their original name'**
  String get matchOriginalNameSubtitle;

  /// No description provided for @hiddenApps.
  ///
  /// In en, this message translates to:
  /// **'Hidden apps'**
  String get hiddenApps;

  /// No description provided for @hiddenAppsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hiddenAppsNone;

  /// No description provided for @hiddenAppsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hidden'**
  String hiddenAppsCount(int count);

  /// No description provided for @noHiddenApps.
  ///
  /// In en, this message translates to:
  /// **'No hidden apps'**
  String get noHiddenApps;

  /// No description provided for @leftOfHome.
  ///
  /// In en, this message translates to:
  /// **'Left module'**
  String get leftOfHome;

  /// No description provided for @rightOfHome.
  ///
  /// In en, this message translates to:
  /// **'Right module'**
  String get rightOfHome;

  /// No description provided for @panelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get panelNone;

  /// No description provided for @lockLayout.
  ///
  /// In en, this message translates to:
  /// **'Lock layout'**
  String get lockLayout;

  /// No description provided for @lockLayoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disable pinning and long press on the home screen'**
  String get lockLayoutSubtitle;

  /// No description provided for @doubleTapToSleep.
  ///
  /// In en, this message translates to:
  /// **'Double tap to sleep'**
  String get doubleTapToSleep;

  /// No description provided for @doubleTapToSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Requires accessibility service enabled in system settings'**
  String get doubleTapToSleepSubtitle;

  /// No description provided for @doubleTapToSleepDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on accessibility service'**
  String get doubleTapToSleepDialogTitle;

  /// No description provided for @doubleTapToSleepDialog.
  ///
  /// In en, this message translates to:
  /// **'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.'**
  String get doubleTapToSleepDialog;

  /// No description provided for @doubleTapToSleepPrivacy.
  ///
  /// In en, this message translates to:
  /// **'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.'**
  String get doubleTapToSleepPrivacy;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default home app'**
  String get setAsDefault;

  /// No description provided for @setAsDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the system picker'**
  String get setAsDefaultSubtitle;

  /// No description provided for @drawerMode.
  ///
  /// In en, this message translates to:
  /// **'Drawer mode'**
  String get drawerMode;

  /// No description provided for @drawerModeList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get drawerModeList;

  /// No description provided for @searchOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'Search only'**
  String get searchOnlyMode;

  /// No description provided for @searchOnlyModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide app names, search to launch'**
  String get searchOnlyModeSubtitle;

  /// No description provided for @autoShowKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Show keyboard'**
  String get autoShowKeyboard;

  /// No description provided for @autoShowKeyboardAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open keyboard when drawer opens'**
  String get autoShowKeyboardAppsSubtitle;

  /// No description provided for @autoShowKeyboardTasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open keyboard when tasks open'**
  String get autoShowKeyboardTasksSubtitle;

  /// No description provided for @autoLaunchOnMatch.
  ///
  /// In en, this message translates to:
  /// **'Auto-launch on match'**
  String get autoLaunchOnMatch;

  /// No description provided for @autoLaunchOnMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Launch when one app matches'**
  String get autoLaunchOnMatchSubtitle;

  /// No description provided for @quickLaunchHints.
  ///
  /// In en, this message translates to:
  /// **'Quick launch hints'**
  String get quickLaunchHints;

  /// No description provided for @quickLaunchHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlight shortest unique characters to launch'**
  String get quickLaunchHintsSubtitle;

  /// No description provided for @extraChar.
  ///
  /// In en, this message translates to:
  /// **'Extra character'**
  String get extraChar;

  /// No description provided for @extraCharSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require an extra character before auto-launch'**
  String get extraCharSubtitle;

  /// No description provided for @panelTasks.
  ///
  /// In en, this message translates to:
  /// **'tasks'**
  String get panelTasks;

  /// No description provided for @panelLaunchApp.
  ///
  /// In en, this message translates to:
  /// **'Launch app'**
  String get panelLaunchApp;

  /// No description provided for @panelLaunchAppHint.
  ///
  /// In en, this message translates to:
  /// **'an app'**
  String get panelLaunchAppHint;

  /// No description provided for @launchAppLeft.
  ///
  /// In en, this message translates to:
  /// **'Left app'**
  String get launchAppLeft;

  /// No description provided for @launchAppRight.
  ///
  /// In en, this message translates to:
  /// **'Right app'**
  String get launchAppRight;

  /// No description provided for @launchAppChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose an app'**
  String get launchAppChoose;

  /// No description provided for @launchAppOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only while this is the left module'**
  String get launchAppOnlyLeft;

  /// No description provided for @launchAppOnlyRight.
  ///
  /// In en, this message translates to:
  /// **'Only while this is the right module'**
  String get launchAppOnlyRight;

  /// No description provided for @removeOnComplete.
  ///
  /// In en, this message translates to:
  /// **'Remove on complete'**
  String get removeOnComplete;

  /// No description provided for @removeOnCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove tasks when marked as done'**
  String get removeOnCompleteSubtitle;

  /// No description provided for @clearCompletedDaily.
  ///
  /// In en, this message translates to:
  /// **'Clear completed daily'**
  String get clearCompletedDaily;

  /// No description provided for @clearCompletedDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove completed tasks at the end of the day'**
  String get clearCompletedDailySubtitle;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @donateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support the development of Last Launcher'**
  String get donateSubtitle;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate Last Launcher'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a review on the Play Store'**
  String get rateAppSubtitle;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Email the developer'**
  String get sendFeedbackSubtitle;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the project page'**
  String get helpSubtitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get openSourceLicenses;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version and licenses'**
  String get aboutSubtitle;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get backupExport;

  /// No description provided for @backupExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save settings, labels, hidden and pinned apps to a file'**
  String get backupExportSubtitle;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replace everything with a saved backup'**
  String get backupRestoreSubtitle;

  /// No description provided for @backupAlsoInclude.
  ///
  /// In en, this message translates to:
  /// **'Also include'**
  String get backupAlsoInclude;

  /// No description provided for @backupRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'This replaces the current settings, labels, hidden and pinned apps.'**
  String get backupRestoreConfirm;

  /// No description provided for @backupExportAction.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get backupExportAction;

  /// No description provided for @backupRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreAction;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupSaved;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a Last Launcher backup'**
  String get backupInvalid;

  /// No description provided for @backupTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of Last Launcher'**
  String get backupTooNew;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read or write the file'**
  String get backupFailed;

  /// No description provided for @hintSwipeUp.
  ///
  /// In en, this message translates to:
  /// **'Swipe up for apps'**
  String get hintSwipeUp;

  /// No description provided for @hintSwipeRightFor.
  ///
  /// In en, this message translates to:
  /// **'Swipe right for {module}'**
  String hintSwipeRightFor(String module);

  /// No description provided for @hintSwipeLeftFor.
  ///
  /// In en, this message translates to:
  /// **'Swipe left for {module}'**
  String hintSwipeLeftFor(String module);

  /// No description provided for @hintLongPress.
  ///
  /// In en, this message translates to:
  /// **'Long press for settings'**
  String get hintLongPress;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @emptyTaskList.
  ///
  /// In en, this message translates to:
  /// **'Type to add a task'**
  String get emptyTaskList;

  /// No description provided for @returnToAddTask.
  ///
  /// In en, this message translates to:
  /// **'Press return to add a task'**
  String get returnToAddTask;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get actionUnpin;

  /// No description provided for @actionPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get actionPin;

  /// No description provided for @actionPinFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get actionPinFull;

  /// No description provided for @actionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// No description provided for @actionUnhide.
  ///
  /// In en, this message translates to:
  /// **'Unhide'**
  String get actionUnhide;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get actionAppInfo;

  /// No description provided for @actionEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get actionEnable;

  /// No description provided for @renameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameDialogTitle;

  /// No description provided for @renameDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get renameDialogCancel;

  /// No description provided for @renameDialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get renameDialogSave;

  /// No description provided for @showWorkAppDot.
  ///
  /// In en, this message translates to:
  /// **'Show work app dot'**
  String get showWorkAppDot;

  /// No description provided for @showWorkAppDotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a small dot in front of work profile apps'**
  String get showWorkAppDotSubtitle;

  /// No description provided for @showWorkAppDotOnHome.
  ///
  /// In en, this message translates to:
  /// **'Show work dot on home screen'**
  String get showWorkAppDotOnHome;

  /// No description provided for @showWorkAppDotOnHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show work profile dot on pinned home screen apps'**
  String get showWorkAppDotOnHomeSubtitle;

  /// No description provided for @hidePersonalWhenWorkActive.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show non-work apps'**
  String get hidePersonalWhenWorkActive;

  /// No description provided for @hidePersonalWhenWorkActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Non-work apps reappear when work profile is paused'**
  String get hidePersonalWhenWorkActiveSubtitle;

  /// No description provided for @homeScreenFull.
  ///
  /// In en, this message translates to:
  /// **'Home screen is full'**
  String get homeScreenFull;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fi',
    'fr',
    'hi',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'sv',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
