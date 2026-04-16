// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'Den sista launchern du någonsin behöver';

  @override
  String get settings => 'Inställningar';

  @override
  String get sectionAppearance => 'Utseende';

  @override
  String get sectionApps => 'Appar';

  @override
  String get sectionBehavior => 'Beteende';

  @override
  String get sectionTasks => 'Uppgifter';

  @override
  String get sectionSupport => 'Stöd';

  @override
  String get sectionAbout => 'Om';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Helskärm';

  @override
  String get hideStatusBarSubtitle => 'Dölj statusfält och navigering';

  @override
  String get homeScreenHints => 'Tips på hemskärmen';

  @override
  String get homeScreenHintsSubtitle => 'Visa tips när hemskärmen är tom';

  @override
  String get hiddenApps => 'Dolda appar';

  @override
  String get hiddenAppsNone => 'Inga';

  @override
  String hiddenAppsCount(int count) {
    return '$count dolda';
  }

  @override
  String get noHiddenApps => 'Inga dolda appar';

  @override
  String get searchOnlyMode => 'Enbart sökning';

  @override
  String get searchOnlyModeSubtitle => 'Dölj appnamn, sök för att starta';

  @override
  String get autoShowKeyboard => 'Visa tangentbord';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Öppna tangentbordet när lådan öppnas';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Öppna tangentbordet när uppgifter öppnas';

  @override
  String get autoLaunchOnMatch => 'Starta automatiskt vid träff';

  @override
  String get autoLaunchOnMatchSubtitle => 'Starta när en app matchar';

  @override
  String get taskScreen => 'Uppgiftsskärm';

  @override
  String get taskScreenSubtitle => 'Svep höger från hemskärmen för uppgifter';

  @override
  String get removeOnComplete => 'Ta bort vid slutförande';

  @override
  String get removeOnCompleteSubtitle =>
      'Ta bort uppgifter när de markeras som klara';

  @override
  String get donate => 'Donera';

  @override
  String get donateSubtitle => 'Stöd utvecklingen av Last Launcher';

  @override
  String get version => 'Version';

  @override
  String get license => 'Licens';

  @override
  String get openSourceLicenses => 'Licenser för öppen källkod';

  @override
  String get hintSwipeUp => 'Svep uppåt för att söka';

  @override
  String get hintSwipeRight => 'Svep höger för uppgifter';

  @override
  String get hintLongPress => 'Tryck länge för inställningar';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get returnToAddTask => 'Skriv för att lägga till uppgift';

  @override
  String get actionRename => 'Byt namn';

  @override
  String get actionUnpin => 'Lossa';

  @override
  String get actionPin => 'Fäst';

  @override
  String get actionPinFull => 'Fullt';

  @override
  String get actionHide => 'Dölj';

  @override
  String get actionUnhide => 'Visa';

  @override
  String get actionDone => 'Klar';

  @override
  String get actionUndo => 'Ångra';

  @override
  String get actionRemove => 'Ta bort';

  @override
  String get renameDialogTitle => 'Byt namn';

  @override
  String get renameDialogCancel => 'Avbryt';

  @override
  String get renameDialogSave => 'Spara';

  @override
  String get homeScreenFull => 'Hemskärmen är full';
}
