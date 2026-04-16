// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'Der letzte Launcher, den du je brauchst';

  @override
  String get settings => 'Einstellungen';

  @override
  String get sectionAppearance => 'Darstellung';

  @override
  String get sectionApps => 'Apps';

  @override
  String get sectionBehavior => 'Verhalten';

  @override
  String get sectionTasks => 'Aufgaben';

  @override
  String get sectionSupport => 'Unterstützung';

  @override
  String get sectionAbout => 'Über';

  @override
  String get themeTitle => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Vollbild';

  @override
  String get hideStatusBarSubtitle => 'Statusleiste und Navigation ausblenden';

  @override
  String get homeScreenHints => 'Startbildschirm-Tipps';

  @override
  String get homeScreenHintsSubtitle =>
      'Tipps anzeigen, wenn der Startbildschirm leer ist';

  @override
  String get hiddenApps => 'Versteckte Apps';

  @override
  String get hiddenAppsNone => 'Keine';

  @override
  String hiddenAppsCount(int count) {
    return '$count versteckt';
  }

  @override
  String get noHiddenApps => 'Keine versteckten Apps';

  @override
  String get searchOnlyMode => 'Nur Suche';

  @override
  String get searchOnlyModeSubtitle =>
      'App-Namen ausblenden, zum Starten suchen';

  @override
  String get autoShowKeyboard => 'Tastatur anzeigen';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Tastatur öffnen, wenn die Schublade geöffnet wird';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Tastatur öffnen, wenn Aufgaben geöffnet werden';

  @override
  String get autoLaunchOnMatch => 'Automatisch starten bei Treffer';

  @override
  String get autoLaunchOnMatchSubtitle =>
      'Starten, wenn eine App übereinstimmt';

  @override
  String get taskScreen => 'Aufgabenbildschirm';

  @override
  String get taskScreenSubtitle =>
      'Vom Startbildschirm nach rechts wischen, um Aufgaben anzuzeigen';

  @override
  String get removeOnComplete => 'Bei Erledigung entfernen';

  @override
  String get removeOnCompleteSubtitle =>
      'Aufgaben entfernen, wenn sie als erledigt markiert werden';

  @override
  String get donate => 'Spenden';

  @override
  String get donateSubtitle => 'Unterstütze die Entwicklung von Last Launcher';

  @override
  String get version => 'Version';

  @override
  String get license => 'Lizenz';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get hintSwipeUp => 'Nach oben wischen zum Suchen';

  @override
  String get hintSwipeRight => 'Nach rechts wischen für Aufgaben';

  @override
  String get hintLongPress => 'Lange drücken für Einstellungen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get returnToAddTask => 'Tippen, um Aufgabe hinzuzufügen';

  @override
  String get actionRename => 'Umbenennen';

  @override
  String get actionUnpin => 'Lösen';

  @override
  String get actionPin => 'Anheften';

  @override
  String get actionPinFull => 'Voll';

  @override
  String get actionHide => 'Ausblenden';

  @override
  String get actionUnhide => 'Einblenden';

  @override
  String get actionDone => 'Fertig';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get renameDialogTitle => 'Umbenennen';

  @override
  String get renameDialogCancel => 'Abbrechen';

  @override
  String get renameDialogSave => 'Speichern';

  @override
  String get homeScreenFull => 'Startbildschirm ist voll';
}
