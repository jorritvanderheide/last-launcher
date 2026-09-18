// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'Poslední spouštěč, který kdy budete potřebovat';

  @override
  String get settings => 'Nastavení';

  @override
  String get sectionAppearance => 'Vzhled';

  @override
  String get sectionHome => 'Domovská';

  @override
  String get sectionAppDrawer => 'Šuplík aplikací';

  @override
  String get sectionTasks => 'Úkoly';

  @override
  String get sectionModules => 'Moduly';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get sectionAbout => 'O aplikaci';

  @override
  String get sectionSearch => 'Vyhledávání';

  @override
  String get sectionWork => 'Pracovní profil';

  @override
  String get themeTitle => 'Motiv';

  @override
  String get themeSystem => 'Systém';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => 'Styl';

  @override
  String get themeStyleStandard => 'Standardní';

  @override
  String get themeExtraAlwaysDark => 'Extra je vždy tmavý';

  @override
  String get hideStatusBar => 'Celá obrazovka';

  @override
  String get hideStatusBarSubtitle => 'Skrýt stavový řádek a navigaci';

  @override
  String get showHints => 'Zobrazit nápovědu';

  @override
  String get showHintsSubtitle => 'Zobrazit tipy k používání v celé aplikaci';

  @override
  String get hidePinnedApps => 'Skrýt připnuté aplikace';

  @override
  String get hidePinnedAppsSubtitle =>
      'Skrýt připnuté aplikace z šuplíku aplikací';

  @override
  String get includeHiddenInSearch => 'Zahrnout skryté do vyhledávání';

  @override
  String get includeHiddenInSearchSubtitle => 'Hledání najde i skryté aplikace';

  @override
  String get matchOriginalName => 'Odpovídat původnímu názvu';

  @override
  String get matchOriginalNameSubtitle =>
      'Hledat přejmenované aplikace podle jejich původního názvu';

  @override
  String get hiddenApps => 'Skryté aplikace';

  @override
  String get hiddenAppsNone => 'Žádné';

  @override
  String hiddenAppsCount(int count) {
    return '$count skryto';
  }

  @override
  String get noHiddenApps => 'Žádné skryté aplikace';

  @override
  String get leftOfHome => 'Levý modul';

  @override
  String get rightOfHome => 'Pravý modul';

  @override
  String get panelNone => 'Žádný';

  @override
  String get lockLayout => 'Uzamknout rozložení';

  @override
  String get lockLayoutSubtitle =>
      'Zakázat připínání a dlouhé stisknutí na domovské obrazovce';

  @override
  String get doubleTapToSleep => 'Dvojitým klepnutím uspat';

  @override
  String get doubleTapToSleepSubtitle =>
      'Vyžaduje službu usnadnění povolenou v nastavení systému';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Nastavit jako výchozí domovskou aplikaci';

  @override
  String get setAsDefaultSubtitle => 'Otevřít systémový výběr';

  @override
  String get searchOnlyMode => 'Pouze hledání';

  @override
  String get searchOnlyModeSubtitle =>
      'Skrýt názvy aplikací, spustit vyhledáváním';

  @override
  String get autoShowKeyboard => 'Zobrazit klávesnici';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Otevřít klávesnici při otevření zásuvky';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Otevřít klávesnici při otevření úkolů';

  @override
  String get autoLaunchOnMatch => 'Automatické spuštění při shodě';

  @override
  String get autoLaunchOnMatchSubtitle =>
      'Spustit, když odpovídá jedna aplikace';

  @override
  String get quickLaunchHints => 'Rychlé nápovědy';

  @override
  String get quickLaunchHintsSubtitle =>
      'Zvýraznit nejkratší jedinečné znaky pro spuštění';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'úkoly';

  @override
  String get removeOnComplete => 'Odstranit po dokončení';

  @override
  String get removeOnCompleteSubtitle =>
      'Odstranit úkoly po označení jako hotové';

  @override
  String get clearCompletedDaily => 'Denně mazat dokončené';

  @override
  String get clearCompletedDailySubtitle =>
      'Odstranit dokončené úkoly na konci dne';

  @override
  String get donate => 'Přispět';

  @override
  String get donateSubtitle => 'Podpořte vývoj Last Launcheru';

  @override
  String get rateApp => 'Ohodnotit Last Launcher';

  @override
  String get rateAppSubtitle => 'Zanechte recenzi v Obchodě Play';

  @override
  String get sendFeedback => 'Poslat zpětnou vazbu';

  @override
  String get sendFeedbackSubtitle => 'Napsat vývojáři e-mail';

  @override
  String get help => 'Nápověda';

  @override
  String get helpSubtitle => 'Zobrazit stránku projektu';

  @override
  String get version => 'Verze';

  @override
  String get license => 'Licence';

  @override
  String get openSourceLicenses => 'Open source licence';

  @override
  String get aboutSubtitle => 'Verze a licence';

  @override
  String get hintSwipeUp => 'Přejeďte nahoru pro aplikace';

  @override
  String hintSwipeRightFor(String module) {
    return 'Přejeďte vpravo pro $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Přejeďte vlevo pro $module';
  }

  @override
  String get hintLongPress => 'Dlouhým stiskem otevřete nastavení';

  @override
  String get noResults => 'Žádné výsledky';

  @override
  String get emptyTaskList => 'Pište pro přidání úkolu';

  @override
  String get returnToAddTask => 'Stisknutím Enter přidáte úkol';

  @override
  String get actionRename => 'Přejmenovat';

  @override
  String get actionUnpin => 'Odepnout';

  @override
  String get actionPin => 'Připnout';

  @override
  String get actionPinFull => 'Plné';

  @override
  String get actionHide => 'Skrýt';

  @override
  String get actionUnhide => 'Zobrazit';

  @override
  String get actionRemove => 'Odstranit';

  @override
  String get actionClose => 'Zavřít';

  @override
  String get actionAppInfo => 'Informace o aplikaci';

  @override
  String get actionEnable => 'Povolit';

  @override
  String get renameDialogTitle => 'Přejmenovat';

  @override
  String get renameDialogCancel => 'Zrušit';

  @override
  String get renameDialogSave => 'Uložit';

  @override
  String get showWorkAppDot => 'Tečka pracovního profilu';

  @override
  String get showWorkAppDotSubtitle =>
      'Zobrazit malou tečku před aplikacemi z pracovního profilu';

  @override
  String get showWorkAppDotOnHome => 'Zobrazit tečku na domovské obrazovce';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Zobrazit tečku pracovního profilu u připnutých aplikací na domovské obrazovce';

  @override
  String get hidePersonalWhenWorkActive => 'Nezobrazovat osobní aplikace';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Osobní aplikace se znovu zobrazí po pozastavení pracovního profilu';

  @override
  String get homeScreenFull => 'Domovská obrazovka je plná';
}
