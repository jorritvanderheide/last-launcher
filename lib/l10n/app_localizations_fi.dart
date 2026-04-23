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
  String get sectionGeneral => 'Yleiset';

  @override
  String get sectionAppDrawer => 'Sovellusvalikko';

  @override
  String get sectionTasks => 'Tehtävät';

  @override
  String get sectionSupport => 'Tuki';

  @override
  String get sectionAbout => 'Tietoja';

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
  String get lockLayout => 'Lukitse asettelu';

  @override
  String get lockLayoutSubtitle =>
      'Poista pitkä painallus käytöstä aloitus- ja tehtävänäytöltä';

  @override
  String get searchOnlyMode => 'Vain haku';

  @override
  String get searchOnlyModeSubtitle =>
      'Piilota sovellusten nimet, käynnistä hakemalla';

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
  String get taskScreen => 'Tehtävänäkymä';

  @override
  String get taskScreenSubtitle => 'Pyyhkäise oikealle nähdäksesi tehtävät';

  @override
  String get removeOnComplete => 'Poista valmistuttua';

  @override
  String get removeOnCompleteSubtitle =>
      'Poista tehtävät, kun ne merkitään valmiiksi';

  @override
  String get taskOptionDisabled => 'Ota tehtävänäyttö käyttöön määrittääksesi';

  @override
  String get donate => 'Lahjoita';

  @override
  String get donateSubtitle => 'Tue Last Launcherin kehitystä';

  @override
  String get version => 'Versio';

  @override
  String get license => 'Lisenssi';

  @override
  String get openSourceLicenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get aboutSubtitle => 'Versio ja lisenssit';

  @override
  String get hintSwipeUp => 'Pyyhkäise ylös hakeaksesi';

  @override
  String get hintSwipeRight => 'Pyyhkäise oikealle tehtäviin';

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
  String get actionDone => 'Valmis';

  @override
  String get actionUndo => 'Kumoa';

  @override
  String get actionRemove => 'Poista';

  @override
  String get actionClose => 'Sulje';

  @override
  String get actionAppInfo => 'Sovelluksen tiedot';

  @override
  String get renameDialogTitle => 'Nimeä uudelleen';

  @override
  String get renameDialogCancel => 'Peruuta';

  @override
  String get renameDialogSave => 'Tallenna';

  @override
  String get homeScreenFull => 'Aloitusnäyttö on täynnä';
}
