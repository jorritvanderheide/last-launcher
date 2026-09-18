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
  String get themeStyleCustom => 'Vlastní';

  @override
  String get fontTitle => 'Písmo';

  @override
  String get fontStandard => 'Standardní';

  @override
  String get fontMono => 'Neproporcionální';

  @override
  String get textSizeTitle => 'Velikost textu';

  @override
  String get textAlignTitle => 'Zarovnání textu';

  @override
  String get alignLeft => 'Vlevo';

  @override
  String get alignCenter => 'Na střed';

  @override
  String get alignRight => 'Vpravo';

  @override
  String get accentColor => 'Barva zvýraznění';

  @override
  String get accentColorSubtitle =>
      'Obarvit text a pozadí systémovou barvou zvýraznění';

  @override
  String get terminalPrompt => 'Příkazový řádek';

  @override
  String get terminalPromptSubtitle => 'Zobrazit hledání jako příkazový řádek';

  @override
  String get sectionEffects => 'Efekty';

  @override
  String get effectsDarkOnly => 'Pouze v tmavém režimu';

  @override
  String get glow => 'Záře';

  @override
  String get scanlines => 'Skenovací linky';

  @override
  String get scanlinesOff => 'Vypnuto';

  @override
  String get scanlinesLight => 'Slabé';

  @override
  String get scanlinesMedium => 'Střední';

  @override
  String get scanlinesStrong => 'Silné';

  @override
  String get animations => 'Animace';

  @override
  String get animationsSubtitle =>
      'Pohyblivé linky, glitche a blikající kurzor';

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
  String get drawerMode => 'Režim šuplíku';

  @override
  String get drawerModeList => 'Seznam';

  @override
  String get searchOnlyMode => 'Pouze hledání';

  @override
  String get searchOnlyModeSubtitle =>
      'Skrýt názvy aplikací, spustit vyhledáváním';

  @override
  String get prefixNoApp => 'Žádná aplikace to neotevře';

  @override
  String get prefixTypeWork => 'Pracovní aplikace';

  @override
  String get prefixTypePersonal => 'Osobní aplikace';

  @override
  String get searchPrefixes => 'Vyhledávací předpony';

  @override
  String get searchPrefixesSubtitle =>
      'Hledat na webu nebo v aplikaci přímo z vyhledávání';

  @override
  String get prefixAdd => 'Přidat předponu';

  @override
  String get prefixRestoreDefaults => 'Obnovit pracovní a osobní předponu';

  @override
  String get prefixTrigger => 'Předpona';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Zobrazeno jako $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Aplikace začínající těmito písmeny nelze najít, dokud je tato předpona zapnutá. Zakončete ji mezerou nebo ji začněte symbolem.';

  @override
  String get prefixName => 'Název';

  @override
  String get prefixType => 'Akce';

  @override
  String get prefixTypeLink => 'Otevřít odkaz';

  @override
  String get prefixTypeSearchInApp => 'Hledat v aplikaci';

  @override
  String get prefixTemplates => 'Vycházet z';

  @override
  String get prefixLink => 'Odkaz';

  @override
  String get prefixLinkHelp => '%s označuje místo pro hledaný text';

  @override
  String get prefixOpenWith => 'Otevřít v';

  @override
  String get prefixAnyApp => 'Libovolná aplikace';

  @override
  String get prefixApp => 'Aplikace';

  @override
  String get prefixNoSearchApps =>
      'Žádná aplikace nenabízí vlastní vyhledávání';

  @override
  String get prefixPersonalAppsOnly =>
      'Aplikace v pracovním profilu zde nelze použít';

  @override
  String get prefixErrorEmpty => 'Zadejte předponu';

  @override
  String get prefixErrorTaken => 'Tuto předponu už používá jiná';

  @override
  String get prefixErrorNoPlaceholder =>
      'Vložte %s tam, kam patří hledaný text';

  @override
  String get prefixTemplateMaps => 'Mapy';

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
  String get panelLaunchApp => 'Spustit aplikaci';

  @override
  String get panelLaunchAppHint => 'aplikaci';

  @override
  String get launchAppLeft => 'Levá aplikace';

  @override
  String get launchAppRight => 'Pravá aplikace';

  @override
  String get launchAppChoose => 'Vybrat aplikaci';

  @override
  String get launchAppOnlyLeft => 'Jen pokud je toto levý modul';

  @override
  String get launchAppOnlyRight => 'Jen pokud je toto pravý modul';

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
  String get backupTitle => 'Záloha a obnovení';

  @override
  String get backupExport => 'Exportovat zálohu';

  @override
  String get backupExportSubtitle =>
      'Uložit nastavení, názvy, skryté a připnuté aplikace do souboru';

  @override
  String get backupRestore => 'Obnovit zálohu';

  @override
  String get backupRestoreSubtitle => 'Nahradit vše uloženou zálohou';

  @override
  String get backupAlsoInclude => 'Zahrnout také';

  @override
  String get backupRestoreConfirm =>
      'Tímto se nahradí současná nastavení, názvy, skryté a připnuté aplikace.';

  @override
  String get backupExportAction => 'Exportovat';

  @override
  String get backupRestoreAction => 'Obnovit';

  @override
  String get backupSaved => 'Záloha uložena';

  @override
  String get backupRestored => 'Záloha obnovena';

  @override
  String get backupInvalid => 'Tento soubor není záloha Last Launcher';

  @override
  String get backupTooNew =>
      'Tato záloha pochází z novější verze Last Launcher';

  @override
  String get backupFailed => 'Soubor nelze přečíst ani zapsat';

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
