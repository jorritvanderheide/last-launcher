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
  String get sectionHome => 'Startbildschirm';

  @override
  String get sectionAppDrawer => 'App-Schublade';

  @override
  String get sectionTasks => 'Aufgaben';

  @override
  String get sectionModules => 'Module';

  @override
  String get sectionSupport => 'Unterstützung';

  @override
  String get sectionAbout => 'Über';

  @override
  String get sectionSearch => 'Suche';

  @override
  String get sectionWork => 'Arbeitsprofil';

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
  String get themeStyleTitle => 'Stil';

  @override
  String get themeStyleStandard => 'Standard';

  @override
  String get themeStyleCustom => 'Benutzerdefiniert';

  @override
  String get fontTitle => 'Schrift';

  @override
  String get fontStandard => 'Standard';

  @override
  String get fontMono => 'Monospace';

  @override
  String get textSizeTitle => 'Textgröße';

  @override
  String get textAlignTitle => 'Textausrichtung';

  @override
  String get alignLeft => 'Links';

  @override
  String get alignCenter => 'Mittig';

  @override
  String get alignRight => 'Rechts';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get accentColorSubtitle =>
      'Text und Hintergrund in der Akzentfarbe des Systems einfärben';

  @override
  String get terminalPrompt => 'Terminal-Eingabe';

  @override
  String get terminalPromptSubtitle => 'Suche als Befehlszeile anzeigen';

  @override
  String get sectionEffects => 'Effekte';

  @override
  String get effectsDarkOnly => 'Nur im dunklen Design';

  @override
  String get glow => 'Leuchten';

  @override
  String get scanlines => 'Scanlines';

  @override
  String get scanlinesOff => 'Aus';

  @override
  String get scanlinesLight => 'Leicht';

  @override
  String get scanlinesMedium => 'Mittel';

  @override
  String get scanlinesStrong => 'Stark';

  @override
  String get animations => 'Animationen';

  @override
  String get animationsSubtitle =>
      'Laufende Scanlines, Glitches und blinkender Cursor';

  @override
  String get hideStatusBar => 'Vollbild';

  @override
  String get hideStatusBarSubtitle => 'Statusleiste und Navigation ausblenden';

  @override
  String get showHints => 'Tipps anzeigen';

  @override
  String get showHintsSubtitle => 'Nutzungstipps in der gesamten App anzeigen';

  @override
  String get hidePinnedApps => 'Angeheftete Apps ausblenden';

  @override
  String get hidePinnedAppsSubtitle =>
      'Angeheftete Apps aus der App-Schublade ausblenden';

  @override
  String get includeHiddenInSearch => 'Versteckte in Suche einbeziehen';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Suche findet auch versteckte Apps';

  @override
  String get matchOriginalName => 'Originalnamen abgleichen';

  @override
  String get matchOriginalNameSubtitle =>
      'Umbenannte Apps am Originalnamen finden';

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
  String get leftOfHome => 'Linkes Modul';

  @override
  String get rightOfHome => 'Rechtes Modul';

  @override
  String get panelNone => 'Keiner';

  @override
  String get lockLayout => 'Layout sperren';

  @override
  String get lockLayoutSubtitle =>
      'Anheften und langes Drücken auf dem Startbildschirm deaktivieren';

  @override
  String get doubleTapToSleep => 'Doppeltippen zum Sperren';

  @override
  String get doubleTapToSleepSubtitle =>
      'Erfordert aktivierten Bedienungshilfe-Dienst in den Systemeinstellungen';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Als Standard-Home-App festlegen';

  @override
  String get setAsDefaultSubtitle => 'System-Auswahl öffnen';

  @override
  String get drawerMode => 'Schubladen-Modus';

  @override
  String get drawerModeList => 'Liste';

  @override
  String get searchOnlyMode => 'Nur Suche';

  @override
  String get searchOnlyModeSubtitle =>
      'App-Namen ausblenden, zum Starten suchen';

  @override
  String get prefixNoApp => 'Keine App kann das öffnen';

  @override
  String get prefixTypeWork => 'Arbeits-Apps';

  @override
  String get prefixTypePersonal => 'Private Apps';

  @override
  String get searchPrefixes => 'Suchpräfixe';

  @override
  String get searchPrefixesSubtitle =>
      'Im Web, in einer Karte oder in einer App direkt aus der Suche suchen';

  @override
  String get prefixAdd => 'Präfix hinzufügen';

  @override
  String get prefixRestoreDefaults =>
      'Arbeits- und Privat-Präfix wiederherstellen';

  @override
  String get prefixNeedsWorkProfile => 'Nur mit Arbeitsprofil';

  @override
  String get prefixTrigger => 'Präfix';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Angezeigt als $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Apps, die mit diesen Buchstaben beginnen, sind nicht auffindbar, solange dies aktiv ist. Mit einem Leerzeichen beenden oder mit einem Symbol beginnen.';

  @override
  String get prefixName => 'Name';

  @override
  String get prefixType => 'Aktion';

  @override
  String get prefixTypeLink => 'Link öffnen';

  @override
  String get prefixTypeSearchInApp => 'In einer App suchen';

  @override
  String get prefixTemplates => 'Vorlage';

  @override
  String get prefixLink => 'Link';

  @override
  String get prefixLinkHelp => '%s steht für den Suchbegriff';

  @override
  String get prefixOpenWith => 'Öffnen mit';

  @override
  String get prefixAnyApp => 'Beliebige App';

  @override
  String get prefixApp => 'App';

  @override
  String get prefixNoSearchApps => 'Keine App bietet eine eigene Suche';

  @override
  String get prefixPersonalAppsOnly =>
      'Apps im Arbeitsprofil sind hier nicht verfügbar';

  @override
  String get prefixErrorEmpty => 'Präfix eingeben';

  @override
  String get prefixErrorTaken => 'Ein anderes Präfix verwendet dies bereits';

  @override
  String get prefixErrorNoPlaceholder =>
      '%s an die Stelle des Suchbegriffs setzen';

  @override
  String get prefixTemplateMaps => 'Karten';

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
  String get quickLaunchHints => 'Schnellstarthinweise';

  @override
  String get quickLaunchHintsSubtitle =>
      'Kürzeste eindeutige Zeichen zum Starten hervorheben';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'Aufgaben';

  @override
  String get panelLaunchApp => 'App starten';

  @override
  String get panelLaunchAppHint => 'eine App';

  @override
  String get launchAppLeft => 'Linke App';

  @override
  String get launchAppRight => 'Rechte App';

  @override
  String get launchAppChoose => 'App auswählen';

  @override
  String get launchAppOnlyLeft => 'Nur wenn dies das linke Modul ist';

  @override
  String get launchAppOnlyRight => 'Nur wenn dies das rechte Modul ist';

  @override
  String get removeOnComplete => 'Bei Erledigung entfernen';

  @override
  String get removeOnCompleteSubtitle =>
      'Aufgaben entfernen, wenn sie als erledigt markiert werden';

  @override
  String get clearCompletedDaily => 'Erledigte täglich löschen';

  @override
  String get clearCompletedDailySubtitle =>
      'Erledigte Aufgaben am Tagesende entfernen';

  @override
  String get donate => 'Spenden';

  @override
  String get donateSubtitle => 'Unterstütze die Entwicklung von Last Launcher';

  @override
  String get rateApp => 'Last Launcher bewerten';

  @override
  String get rateAppSubtitle => 'Hinterlasse eine Bewertung im Play Store';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get sendFeedbackSubtitle => 'Sende eine E-Mail an den Entwickler';

  @override
  String get help => 'Hilfe';

  @override
  String get helpSubtitle => 'Projektseite anzeigen';

  @override
  String get version => 'Version';

  @override
  String get license => 'Lizenz';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get aboutSubtitle => 'Version und Lizenzen';

  @override
  String get backupTitle => 'Sichern und wiederherstellen';

  @override
  String get backupExport => 'Sicherung exportieren';

  @override
  String get backupExportSubtitle =>
      'Einstellungen, Namen, ausgeblendete und angeheftete Apps in einer Datei speichern';

  @override
  String get backupRestore => 'Sicherung wiederherstellen';

  @override
  String get backupRestoreSubtitle =>
      'Alles durch eine gespeicherte Sicherung ersetzen';

  @override
  String get backupAlsoInclude => 'Außerdem einschließen';

  @override
  String get backupRestoreConfirm =>
      'Dies ersetzt die aktuellen Einstellungen, Namen sowie ausgeblendete und angeheftete Apps.';

  @override
  String get backupExportAction => 'Exportieren';

  @override
  String get backupRestoreAction => 'Wiederherstellen';

  @override
  String get backupSaved => 'Sicherung gespeichert';

  @override
  String get backupRestored => 'Sicherung wiederhergestellt';

  @override
  String get backupInvalid => 'Diese Datei ist keine Last Launcher-Sicherung';

  @override
  String get backupTooNew =>
      'Diese Sicherung stammt aus einer neueren Version von Last Launcher';

  @override
  String get backupFailed =>
      'Datei konnte nicht gelesen oder geschrieben werden';

  @override
  String get hintSwipeUp => 'Nach oben wischen für Apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Nach rechts wischen für $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Nach links wischen für $module';
  }

  @override
  String get hintLongPress => 'Lange drücken für Einstellungen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get emptyTaskList => 'Tippe, um eine Aufgabe hinzuzufügen';

  @override
  String get returnToAddTask => 'Eingabe drücken, um eine Aufgabe hinzuzufügen';

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
  String get actionRemove => 'Entfernen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionAppInfo => 'App-Info';

  @override
  String get actionEnable => 'Aktivieren';

  @override
  String get renameDialogTitle => 'Umbenennen';

  @override
  String get renameDialogCancel => 'Abbrechen';

  @override
  String get renameDialogSave => 'Speichern';

  @override
  String get showWorkAppDot => 'Arbeitsprofil-Punkt anzeigen';

  @override
  String get showWorkAppDotSubtitle =>
      'Zeige einen kleinen Punkt vor Arbeitsprofil-Apps';

  @override
  String get showWorkAppDotOnHome => 'Punkt auf dem Startbildschirm anzeigen';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Arbeitsprofil-Punkt bei angehefteten Apps auf dem Startbildschirm anzeigen';

  @override
  String get hidePersonalWhenWorkActive => 'Private Apps ausblenden';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Private Apps werden wieder angezeigt, wenn das Arbeitsprofil pausiert wird';

  @override
  String get homeScreenFull => 'Startbildschirm ist voll';
}
