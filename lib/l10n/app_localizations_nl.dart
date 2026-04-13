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
  String get settings => 'Instellingen';

  @override
  String get sectionAppearance => 'Uiterlijk';

  @override
  String get sectionApps => 'Apps';

  @override
  String get sectionBehavior => 'Gedrag';

  @override
  String get sectionTasks => 'Taken';

  @override
  String get sectionSupport => 'Ondersteuning';

  @override
  String get sectionAbout => 'Over';

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
  String get hideStatusBar => 'Volledig scherm';

  @override
  String get hideStatusBarSubtitle => 'Statusbalk en navigatie verbergen';

  @override
  String get homeScreenHints => 'Startschermtips';

  @override
  String get homeScreenHintsSubtitle =>
      'Toon tips wanneer het startscherm leeg is';

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
  String get searchOnlyMode => 'Alleen zoeken';

  @override
  String get searchOnlyModeSubtitle =>
      'Appnamen verbergen, zoeken om te starten';

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
  String get taskScreen => 'Takenscherm';

  @override
  String get taskScreenSubtitle =>
      'Veeg naar rechts vanaf het startscherm om taken te bekijken';

  @override
  String get removeOnComplete => 'Verwijderen bij voltooiing';

  @override
  String get removeOnCompleteSubtitle =>
      'Taken verwijderen wanneer ze zijn afgerond';

  @override
  String get donate => 'Doneren';

  @override
  String get donateSubtitle => 'Ondersteun de ontwikkeling op Liberapay';

  @override
  String get version => 'Versie';

  @override
  String get license => 'Licentie';

  @override
  String get openSourceLicenses => 'Opensourcelicenties';

  @override
  String get hintSwipeUp => 'Veeg omhoog om te zoeken';

  @override
  String get hintSwipeRight => 'Veeg naar rechts voor taken';

  @override
  String get hintLongPress => 'Lang drukken voor instellingen';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get returnToAddTask => 'Typ om een taak toe te voegen';

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
  String get actionDone => 'Klaar';

  @override
  String get actionUndo => 'Ongedaan maken';

  @override
  String get actionRemove => 'Verwijderen';

  @override
  String get renameDialogTitle => 'Hernoemen';

  @override
  String get renameDialogCancel => 'Annuleren';

  @override
  String get renameDialogSave => 'Opslaan';

  @override
  String get homeScreenFull => 'Startscherm is vol';
}
