// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'Viimeinen laukaisija, jonka koskaan tarvitset';

  @override
  String get settings => 'Asetukset';

  @override
  String get sectionAppearance => 'Ulkoasu';

  @override
  String get sectionHome => 'Aloitusnäyttö';

  @override
  String get sectionAppDrawer => 'Sovellusvalikko';

  @override
  String get sectionTasks => 'Tehtävät';

  @override
  String get sectionSupport => 'Tuki';

  @override
  String get sectionAbout => 'Tietoja';

  @override
  String get sectionSearch => 'Haku';

  @override
  String get sectionWork => 'Työprofiili';

  @override
  String get themeTitle => 'Teema';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => 'Tyyli';

  @override
  String get themeStyleStandard => 'Vakio';

  @override
  String get themeStyleCustom => 'Mukautettu';

  @override
  String get fontTitle => 'Fontti';

  @override
  String get fontStandard => 'Vakio';

  @override
  String get fontMono => 'Tasavälinen';

  @override
  String get textSizeTitle => 'Tekstin koko';

  @override
  String get textAlignTitle => 'Tekstin tasaus';

  @override
  String get alignLeft => 'Vasen';

  @override
  String get alignCenter => 'Keskitetty';

  @override
  String get alignRight => 'Oikea';

  @override
  String get accentColor => 'Korostusväri';

  @override
  String get accentColorSubtitle =>
      'Sävytä teksti ja tausta järjestelmän korostusvärillä';

  @override
  String get terminalPrompt => 'Komentorivi';

  @override
  String get terminalPromptSubtitle => 'Näytä haku komentorivinä';

  @override
  String get sectionEffects => 'Tehosteet';

  @override
  String get effectsDarkOnly => 'Vain tummassa tilassa';

  @override
  String get glow => 'Hehku';

  @override
  String get scanlines => 'Juovat';

  @override
  String get scanlinesOff => 'Pois';

  @override
  String get scanlinesLight => 'Kevyt';

  @override
  String get scanlinesMedium => 'Keskitaso';

  @override
  String get scanlinesStrong => 'Voimakas';

  @override
  String get animations => 'Animaatiot';

  @override
  String get animationsSubtitle =>
      'Liikkuvat juovat, häiriöt ja vilkkuva kohdistin';

  @override
  String get hideStatusBar => 'Koko näyttö';

  @override
  String get hideStatusBarSubtitle => 'Piilota tilarivi ja navigointi';

  @override
  String get showHints => 'Näytä vinkit';

  @override
  String get showHintsSubtitle => 'Näytä käyttövinkit koko sovelluksessa';

  @override
  String get hidePinnedApps => 'Piilota kiinnitetyt sovellukset';

  @override
  String get hidePinnedAppsSubtitle =>
      'Piilota kiinnitetyt sovellukset sovellusvalikosta';

  @override
  String get includeHiddenInSearch => 'Sisällytä piilotetut hakuun';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Anna haun löytää myös piilotetut sovellukset';

  @override
  String get matchOriginalName => 'Vastaa alkuperäistä nimeä';

  @override
  String get matchOriginalNameSubtitle =>
      'Löydä uudelleennimetyt sovellukset alkuperäisellä nimellä';

  @override
  String get hiddenApps => 'Piilotetut sovellukset';

  @override
  String get hiddenAppsNone => 'Ei mitään';

  @override
  String hiddenAppsCount(int count) {
    return '$count piilotettu';
  }

  @override
  String get noHiddenApps => 'Ei piilotettuja sovelluksia';

  @override
  String get leftOfHome => 'Vasen moduuli';

  @override
  String get rightOfHome => 'Oikea moduuli';

  @override
  String get panelNone => 'Ei mitään';

  @override
  String get lockLayout => 'Lukitse asettelu';

  @override
  String get lockLayoutSubtitle =>
      'Poista kiinnittäminen ja pitkä painallus käytöstä aloitusnäytöllä';

  @override
  String get doubleTapToSleep => 'Kaksoisnapautus sammuttaaksesi näytön';

  @override
  String get doubleTapToSleepSubtitle =>
      'Vaatii esteettömyyspalvelun käyttöönottoa järjestelmäasetuksissa';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get setAsDefault => 'Aseta oletusaloitussovellukseksi';

  @override
  String get setAsDefaultSubtitle => 'Avaa järjestelmän valitsin';

  @override
  String get drawerMode => 'Valikon tila';

  @override
  String get drawerModeList => 'Luettelo';

  @override
  String get searchOnlyMode => 'Vain haku';

  @override
  String get prefixNoApp => 'Mikään sovellus ei voi avata tätä';

  @override
  String get prefixTypeWork => 'Työsovellukset';

  @override
  String get prefixTypePersonal => 'Henkilökohtaiset sovellukset';

  @override
  String get searchPrefixes => 'Hakuetuliitteet';

  @override
  String get searchPrefixesSubtitle =>
      'Hae verkosta tai sovelluksesta hakukentän kautta';

  @override
  String get prefixAdd => 'Lisää etuliite';

  @override
  String get prefixRestoreDefaults =>
      'Palauta työ- ja henkilökohtainen etuliite';

  @override
  String get prefixTrigger => 'Etuliite';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Näkyy muodossa $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Näillä kirjaimilla alkavia sovelluksia ei löydy, kun tämä on käytössä. Lopeta se välilyöntiin tai aloita se symbolilla.';

  @override
  String get prefixName => 'Nimi';

  @override
  String get prefixType => 'Toiminto';

  @override
  String get prefixTypeLink => 'Avaa linkki';

  @override
  String get prefixTypeSearchInApp => 'Hae sovelluksesta';

  @override
  String get prefixTemplates => 'Pohja';

  @override
  String get prefixLink => 'Linkki';

  @override
  String get prefixLinkHelp => '%s on hakusanan paikka';

  @override
  String get prefixOpenWith => 'Avaa sovelluksella';

  @override
  String get prefixAnyApp => 'Mikä tahansa sovellus';

  @override
  String get prefixApp => 'Sovellus';

  @override
  String get prefixNoSearchApps => 'Mikään sovellus ei tarjoa omaa hakua';

  @override
  String get prefixPersonalAppsOnly =>
      'Työprofiilin sovelluksia ei voi käyttää tässä';

  @override
  String get prefixErrorEmpty => 'Anna etuliite';

  @override
  String get prefixErrorTaken => 'Toinen etuliite käyttää jo tätä';

  @override
  String get prefixErrorNoPlaceholder => 'Lisää %s hakusanan kohdalle';

  @override
  String get prefixTemplateMaps => 'Kartat';

  @override
  String get autoShowKeyboard => 'Näytä näppäimistö';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Avaa näppäimistö, kun laatikko avautuu';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Avaa näppäimistö, kun tehtävät avautuvat';

  @override
  String get autoLaunchOnMatch => 'Käynnistä automaattisesti';

  @override
  String get autoLaunchOnMatchSubtitle => 'Käynnistä, kun yksi sovellus täsmää';

  @override
  String get quickLaunchHints => 'Pikakäynnistysvinkit';

  @override
  String get quickLaunchHintsSubtitle =>
      'Korosta lyhyimmät ainutlaatuiset merkit käynnistystä varten';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'tehtävät';

  @override
  String get panelLaunchApp => 'Käynnistä sovellus';

  @override
  String get panelLaunchAppHint => 'sovellus';

  @override
  String get launchAppLeft => 'Vasen sovellus';

  @override
  String get launchAppRight => 'Oikea sovellus';

  @override
  String get launchAppChoose => 'Valitse sovellus';

  @override
  String get launchAppOnlyLeft => 'Vain kun tämä on vasen moduuli';

  @override
  String get launchAppOnlyRight => 'Vain kun tämä on oikea moduuli';

  @override
  String get removeOnComplete => 'Poista valmistuttua';

  @override
  String get removeOnCompleteSubtitle =>
      'Poista tehtävät, kun ne merkitään valmiiksi';

  @override
  String get clearCompletedDaily => 'Tyhjennä valmiit päivittäin';

  @override
  String get clearCompletedDailySubtitle =>
      'Poista valmiit tehtävät päivän päätteeksi';

  @override
  String get donate => 'Lahjoita';

  @override
  String get donateSubtitle => 'Tue Last Launcherin kehitystä';

  @override
  String get rateApp => 'Arvostele Last Launcher';

  @override
  String get rateAppSubtitle => 'Jätä arvio Play Kauppaan';

  @override
  String get sendFeedback => 'Lähetä palautetta';

  @override
  String get sendFeedbackSubtitle => 'Lähetä sähköpostia kehittäjälle';

  @override
  String get help => 'Ohje';

  @override
  String get helpSubtitle => 'Vastauksia usein kysyttyihin kysymyksiin';

  @override
  String get version => 'Versio';

  @override
  String get license => 'Lisenssi';

  @override
  String get openSourceLicenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get aboutSubtitle => 'Versio ja lisenssit';

  @override
  String get backupTitle => 'Varmuuskopiointi';

  @override
  String get backupExport => 'Vie varmuuskopio';

  @override
  String get backupExportSubtitle =>
      'Tallenna asetukset, nimet sekä piilotetut ja kiinnitetyt sovellukset tiedostoon';

  @override
  String get backupRestore => 'Palauta varmuuskopio';

  @override
  String get backupRestoreSubtitle =>
      'Korvaa kaikki tallennetulla varmuuskopiolla';

  @override
  String get backupAlsoInclude => 'Sisällytä myös';

  @override
  String get backupRestoreConfirm =>
      'Tämä korvaa nykyiset asetukset, nimet sekä piilotetut ja kiinnitetyt sovellukset.';

  @override
  String get backupExportAction => 'Vie';

  @override
  String get backupRestoreAction => 'Palauta';

  @override
  String get backupSaved => 'Varmuuskopio tallennettu';

  @override
  String get backupRestored => 'Varmuuskopio palautettu';

  @override
  String get backupInvalid =>
      'Tämä tiedosto ei ole Last Launcherin varmuuskopio';

  @override
  String get backupTooNew =>
      'Tämä varmuuskopio on Last Launcherin uudemmasta versiosta';

  @override
  String get backupFailed => 'Tiedostoa ei voitu lukea tai kirjoittaa';

  @override
  String get hintSwipeUp => 'Pyyhkäise ylös sovelluksiin';

  @override
  String hintSwipeRightFor(String module) {
    return 'Pyyhkäise oikealle: $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Pyyhkäise vasemmalle: $module';
  }

  @override
  String get hintLongPress => 'Paina pitkään asetuksiin';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get emptyTaskList => 'Kirjoita lisätäksesi tehtävän';

  @override
  String get returnToAddTask => 'Paina Enter lisätäksesi tehtävän';

  @override
  String get actionRename => 'Nimeä uudelleen';

  @override
  String get actionUnpin => 'Irrota';

  @override
  String get actionPin => 'Kiinnitä';

  @override
  String get actionPinFull => 'Täynnä';

  @override
  String get actionHide => 'Piilota';

  @override
  String get actionUnhide => 'Näytä';

  @override
  String get actionRemove => 'Poista';

  @override
  String get actionClose => 'Sulje';

  @override
  String get actionAppInfo => 'Sovelluksen tiedot';

  @override
  String get actionEnable => 'Käytä';

  @override
  String get renameDialogTitle => 'Nimeä uudelleen';

  @override
  String get renameDialogCancel => 'Peruuta';

  @override
  String get renameDialogSave => 'Tallenna';

  @override
  String get showWorkAppDot => 'Näytä työprofiilin piste';

  @override
  String get showWorkAppDotSubtitle =>
      'Näytä pieni piste työprofiilin sovellusten edessä';

  @override
  String get showWorkAppDotOnHome => 'Näytä piste aloitusnäytöllä';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Näytä työprofiilin piste kiinnitetyissä aloitusnäytön sovelluksissa';

  @override
  String get hidePersonalWhenWorkActive =>
      'Älä näytä henkilökohtaisia sovelluksia';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Henkilökohtaiset sovellukset tulevat takaisin, kun työprofiili on tauolla';

  @override
  String get homeScreenFull => 'Aloitusnäyttö on täynnä';
}
