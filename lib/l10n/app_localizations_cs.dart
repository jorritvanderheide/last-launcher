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
  String get sectionApps => 'Aplikace';

  @override
  String get sectionBehavior => 'Chování';

  @override
  String get sectionTasks => 'Úkoly';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get sectionAbout => 'O aplikaci';

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
  String get hideStatusBar => 'Celá obrazovka';

  @override
  String get hideStatusBarSubtitle => 'Skrýt stavový řádek a navigaci';

  @override
  String get homeScreenHints => 'Nápověda na domovské obrazovce';

  @override
  String get homeScreenHintsSubtitle =>
      'Zobrazit tipy, když je domovská obrazovka prázdná';

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
  String get taskScreen => 'Obrazovka úkolů';

  @override
  String get taskScreenSubtitle => 'Přejetím doprava zobrazíte úkoly';

  @override
  String get removeOnComplete => 'Odstranit po dokončení';

  @override
  String get removeOnCompleteSubtitle =>
      'Odstranit úkoly po označení jako hotové';

  @override
  String get donate => 'Přispět';

  @override
  String get donateSubtitle => 'Podpořte vývoj Last Launcheru';

  @override
  String get version => 'Verze';

  @override
  String get license => 'Licence';

  @override
  String get openSourceLicenses => 'Open source licence';

  @override
  String get hintSwipeUp => 'Přejetím nahoru vyhledávejte';

  @override
  String get hintSwipeRight => 'Přejetím doprava zobrazíte úkoly';

  @override
  String get hintLongPress => 'Dlouhým stiskem otevřete nastavení';

  @override
  String get noResults => 'Žádné výsledky';

  @override
  String get returnToAddTask => 'Zadejte text pro přidání úkolu';

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
  String get actionDone => 'Hotovo';

  @override
  String get actionUndo => 'Zpět';

  @override
  String get actionRemove => 'Odstranit';

  @override
  String get renameDialogTitle => 'Přejmenovat';

  @override
  String get renameDialogCancel => 'Zrušit';

  @override
  String get renameDialogSave => 'Uložit';

  @override
  String get homeScreenFull => 'Domovská obrazovka je plná';
}
