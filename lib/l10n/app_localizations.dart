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

  /// No description provided for @sectionApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get sectionApps;

  /// No description provided for @sectionBehavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get sectionBehavior;

  /// No description provided for @sectionTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get sectionTasks;

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

  /// No description provided for @homeScreenHints.
  ///
  /// In en, this message translates to:
  /// **'Home screen hints'**
  String get homeScreenHints;

  /// No description provided for @homeScreenHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show tips when home screen is empty'**
  String get homeScreenHintsSubtitle;

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

  /// No description provided for @taskScreen.
  ///
  /// In en, this message translates to:
  /// **'Task screen'**
  String get taskScreen;

  /// No description provided for @taskScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe right from home to view tasks'**
  String get taskScreenSubtitle;

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

  /// No description provided for @hintSwipeUp.
  ///
  /// In en, this message translates to:
  /// **'Swipe up to search'**
  String get hintSwipeUp;

  /// No description provided for @hintSwipeRight.
  ///
  /// In en, this message translates to:
  /// **'Swipe right for tasks'**
  String get hintSwipeRight;

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
  /// **'Type to add a new task'**
  String get emptyTaskList;

  /// No description provided for @returnToAddTask.
  ///
  /// In en, this message translates to:
  /// **'Press return to add task'**
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

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

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
