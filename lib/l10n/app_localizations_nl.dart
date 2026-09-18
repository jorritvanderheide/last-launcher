// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'De laatste launcher die je ooit nodig hebt';

  @override
  String get settings => 'Instellingen';

  @override
  String get sectionAppearance => 'Uiterlijk';

  @override
  String get sectionHome => 'Startscherm';

  @override
  String get sectionAppDrawer => 'App-lade';

  @override
  String get sectionTasks => 'Taken';

  @override
  String get sectionModules => 'Modules';

  @override
  String get sectionSupport => 'Ondersteuning';

  @override
  String get sectionAbout => 'Over';

  @override
  String get sectionSearch => 'Zoeken';

  @override
  String get sectionWork => 'Werkprofiel';

  @override
  String get themeTitle => 'Thema';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => 'Stijl';

  @override
  String get themeStyleStandard => 'Standaard';

  @override
  String get themeStyleCustom => 'Aangepast';

  @override
  String get fontTitle => 'Lettertype';

  @override
  String get fontStandard => 'Standaard';

  @override
  String get fontMono => 'Monospace';

  @override
  String get textSizeTitle => 'Tekstgrootte';

  @override
  String get textAlignTitle => 'Tekstuitlijning';

  @override
  String get alignLeft => 'Links';

  @override
  String get alignCenter => 'Midden';

  @override
  String get alignRight => 'Rechts';

  @override
  String get accentColor => 'Accentkleur';

  @override
  String get accentColorSubtitle =>
      'Tekst en achtergrond kleuren met de accentkleur van het systeem';

  @override
  String get terminalPrompt => 'Terminalprompt';

  @override
  String get terminalPromptSubtitle => 'Zoeken tonen als opdrachtregel';

  @override
  String get sectionEffects => 'Effecten';

  @override
  String get effectsDarkOnly => 'Alleen in donkere modus';

  @override
  String get glow => 'Gloed';

  @override
  String get scanlines => 'Scanlijnen';

  @override
  String get scanlinesOff => 'Uit';

  @override
  String get scanlinesLight => 'Licht';

  @override
  String get scanlinesMedium => 'Middel';

  @override
  String get scanlinesStrong => 'Sterk';

  @override
  String get animations => 'Animaties';

  @override
  String get animationsSubtitle =>
      'Bewegende scanlijnen, glitches en een knipperende cursor';

  @override
  String get hideStatusBar => 'Volledig scherm';

  @override
  String get hideStatusBarSubtitle => 'Statusbalk en navigatie verbergen';

  @override
  String get showHints => 'Tips tonen';

  @override
  String get showHintsSubtitle => 'Toon gebruikstips in de hele app';

  @override
  String get hidePinnedApps => 'Vastgemaakte apps verbergen';

  @override
  String get hidePinnedAppsSubtitle =>
      'Verberg vastgemaakte apps in de app-lade';

  @override
  String get includeHiddenInSearch => 'Verborgen in zoekresultaten';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Laat zoeken ook verborgen apps vinden';

  @override
  String get matchOriginalName => 'Originele naam matchen';

  @override
  String get matchOriginalNameSubtitle =>
      'Hernoemde apps vinden op hun originele naam';

  @override
  String get hiddenApps => 'Verborgen apps';

  @override
  String get hiddenAppsNone => 'Geen';

  @override
  String hiddenAppsCount(int count) {
    return '$count verborgen';
  }

  @override
  String get noHiddenApps => 'Geen verborgen apps';

  @override
  String get leftOfHome => 'Linkermodule';

  @override
  String get rightOfHome => 'Rechtermodule';

  @override
  String get panelNone => 'Geen';

  @override
  String get lockLayout => 'Lay-out vergrendelen';

  @override
  String get lockLayoutSubtitle =>
      'Vastmaken en lang indrukken op startscherm uitschakelen';

  @override
  String get doubleTapToSleep => 'Dubbeltikken om te slapen';

  @override
  String get doubleTapToSleepSubtitle =>
      'Vereist toegankelijkheidsservice ingeschakeld in systeeminstellingen';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Instellen als standaard startscherm-app';

  @override
  String get setAsDefaultSubtitle => 'Open de systeemkiezer';

  @override
  String get drawerMode => 'Lademodus';

  @override
  String get drawerModeList => 'Lijst';

  @override
  String get searchOnlyMode => 'Alleen zoeken';

  @override
  String get searchOnlyModeSubtitle =>
      'Appnamen verbergen, zoeken om te starten';

  @override
  String get prefixNoApp => 'Geen app kan dit openen';

  @override
  String get prefixTypeWork => 'Werk-apps';

  @override
  String get prefixTypePersonal => 'Persoonlijke apps';

  @override
  String get searchPrefixes => 'Zoekvoorvoegsels';

  @override
  String get searchPrefixesSubtitle =>
      'Zoek op het web, op een kaart of in een app vanuit het zoekveld';

  @override
  String get prefixAdd => 'Voorvoegsel toevoegen';

  @override
  String get prefixRestoreDefaults =>
      'Werk- en persoonlijk voorvoegsel terugzetten';

  @override
  String get prefixNeedsWorkProfile => 'Alleen met een werkprofiel';

  @override
  String get prefixTrigger => 'Voorvoegsel';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Weergegeven als $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Apps die met deze letters beginnen zijn niet te vinden zolang dit aan staat. Eindig met een spatie of begin met een symbool.';

  @override
  String get prefixName => 'Naam';

  @override
  String get prefixType => 'Actie';

  @override
  String get prefixTypeLink => 'Link openen';

  @override
  String get prefixTypeSearchInApp => 'Zoeken in een app';

  @override
  String get prefixTemplates => 'Beginnen met';

  @override
  String get prefixLink => 'Link';

  @override
  String get prefixLinkHelp => '%s is waar de zoekterm komt';

  @override
  String get prefixOpenWith => 'Openen met';

  @override
  String get prefixAnyApp => 'Elke app';

  @override
  String get prefixApp => 'App';

  @override
  String get prefixNoSearchApps => 'Geen app biedt een eigen zoekfunctie';

  @override
  String get prefixPersonalAppsOnly =>
      'Apps in het werkprofiel kunnen hier niet worden gebruikt';

  @override
  String get prefixErrorEmpty => 'Voer een voorvoegsel in';

  @override
  String get prefixErrorTaken => 'Een ander voorvoegsel gebruikt dit al';

  @override
  String get prefixErrorNoPlaceholder => 'Zet %s waar de zoekterm komt';

  @override
  String get prefixTemplateMaps => 'Kaarten';

  @override
  String get autoShowKeyboard => 'Toetsenbord tonen';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Toetsenbord openen wanneer lade opent';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Toetsenbord openen wanneer taken opent';

  @override
  String get autoLaunchOnMatch => 'Automatisch starten bij overeenkomst';

  @override
  String get autoLaunchOnMatchSubtitle => 'Starten wanneer één app overeenkomt';

  @override
  String get quickLaunchHints => 'Snelle start aanwijzingen';

  @override
  String get quickLaunchHintsSubtitle =>
      'Markeer kortste unieke tekens om te starten';

  @override
  String get extraChar => 'Extra teken';

  @override
  String get extraCharSubtitle =>
      'Een extra teken nodig voor automatisch starten';

  @override
  String get panelTasks => 'taken';

  @override
  String get panelLaunchApp => 'App openen';

  @override
  String get panelLaunchAppHint => 'een app';

  @override
  String get launchAppLeft => 'Linker-app';

  @override
  String get launchAppRight => 'Rechter-app';

  @override
  String get launchAppChoose => 'Kies een app';

  @override
  String get launchAppOnlyLeft => 'Alleen als dit de linkermodule is';

  @override
  String get launchAppOnlyRight => 'Alleen als dit de rechtermodule is';

  @override
  String get removeOnComplete => 'Verwijderen bij voltooiing';

  @override
  String get removeOnCompleteSubtitle =>
      'Taken verwijderen wanneer ze zijn afgerond';

  @override
  String get clearCompletedDaily => 'Voltooide dagelijks wissen';

  @override
  String get clearCompletedDailySubtitle =>
      'Voltooide taken aan het einde van de dag verwijderen';

  @override
  String get donate => 'Doneren';

  @override
  String get donateSubtitle => 'Ondersteun de ontwikkeling van Last Launcher';

  @override
  String get rateApp => 'Last Launcher beoordelen';

  @override
  String get rateAppSubtitle => 'Laat een recensie achter in de Play Store';

  @override
  String get sendFeedback => 'Feedback sturen';

  @override
  String get sendFeedbackSubtitle => 'Stuur de ontwikkelaar een e-mail';

  @override
  String get help => 'Help';

  @override
  String get helpSubtitle => 'Bekijk de projectpagina';

  @override
  String get version => 'Versie';

  @override
  String get license => 'Licentie';

  @override
  String get openSourceLicenses => 'Opensourcelicenties';

  @override
  String get aboutSubtitle => 'Versie en licenties';

  @override
  String get backupTitle => 'Back-up en herstel';

  @override
  String get backupExport => 'Back-up exporteren';

  @override
  String get backupExportSubtitle =>
      'Instellingen, namen en verborgen en vastgezette apps in een bestand opslaan';

  @override
  String get backupRestore => 'Back-up herstellen';

  @override
  String get backupRestoreSubtitle =>
      'Alles vervangen door een opgeslagen back-up';

  @override
  String get backupAlsoInclude => 'Ook meenemen';

  @override
  String get backupRestoreConfirm =>
      'Dit vervangt de huidige instellingen, namen en verborgen en vastgezette apps.';

  @override
  String get backupExportAction => 'Exporteren';

  @override
  String get backupRestoreAction => 'Herstellen';

  @override
  String get backupSaved => 'Back-up opgeslagen';

  @override
  String get backupRestored => 'Back-up hersteld';

  @override
  String get backupInvalid => 'Dit bestand is geen Last Launcher-back-up';

  @override
  String get backupTooNew =>
      'Deze back-up komt van een nieuwere versie van Last Launcher';

  @override
  String get backupFailed => 'Kan het bestand niet lezen of schrijven';

  @override
  String get hintSwipeUp => 'Veeg omhoog voor apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Veeg rechts voor $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Veeg links voor $module';
  }

  @override
  String get hintLongPress => 'Lang drukken voor instellingen';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get emptyTaskList => 'Typ om een taak toe te voegen';

  @override
  String get returnToAddTask => 'Druk op enter om een taak toe te voegen';

  @override
  String get actionRename => 'Hernoemen';

  @override
  String get actionUnpin => 'Losmaken';

  @override
  String get actionPin => 'Vastmaken';

  @override
  String get actionPinFull => 'Vol';

  @override
  String get actionHide => 'Verbergen';

  @override
  String get actionUnhide => 'Zichtbaar maken';

  @override
  String get actionRemove => 'Verwijderen';

  @override
  String get actionClose => 'Sluiten';

  @override
  String get actionAppInfo => 'App-info';

  @override
  String get actionEnable => 'Inschakelen';

  @override
  String get renameDialogTitle => 'Hernoemen';

  @override
  String get renameDialogCancel => 'Annuleren';

  @override
  String get renameDialogSave => 'Opslaan';

  @override
  String get showWorkAppDot => 'Werkprofiel stip tonen';

  @override
  String get showWorkAppDotSubtitle =>
      'Toon een kleine stip voor werkprofielapps';

  @override
  String get showWorkAppDotOnHome => 'Werkstip op startscherm tonen';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Toon werkprofielstip bij vastgezette apps op het startscherm';

  @override
  String get hidePersonalWhenWorkActive => 'Toon geen niet-werk apps';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Niet-werk apps verschijnen weer wanneer het werkprofiel wordt gepauzeerd';

  @override
  String get homeScreenFull => 'Startscherm is vol';
}
