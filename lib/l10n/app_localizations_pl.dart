// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline =>
      'Ostatni launcher, jakiego kiedykolwiek będziesz potrzebować';

  @override
  String get settings => 'Ustawienia';

  @override
  String get sectionAppearance => 'Wygląd';

  @override
  String get sectionHome => 'Ekran główny';

  @override
  String get sectionAppDrawer => 'Szuflada aplikacji';

  @override
  String get sectionTasks => 'Zadania';

  @override
  String get sectionModules => 'Moduły';

  @override
  String get sectionSupport => 'Wsparcie';

  @override
  String get sectionAbout => 'O aplikacji';

  @override
  String get themeTitle => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Pełny ekran';

  @override
  String get hideStatusBarSubtitle => 'Ukryj pasek stanu i nawigację';

  @override
  String get showHints => 'Pokaż wskazówki';

  @override
  String get showHintsSubtitle =>
      'Pokaż wskazówki użytkowania w całej aplikacji';

  @override
  String get hidePinnedApps => 'Ukryj przypięte aplikacje';

  @override
  String get hidePinnedAppsSubtitle =>
      'Ukryj przypięte aplikacje z szuflady aplikacji';

  @override
  String get includeHiddenInSearch => 'Uwzględnij ukryte w wyszukiwaniu';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Pozwól wyszukiwaniu znajdować ukryte aplikacje';

  @override
  String get matchOriginalName => 'Dopasuj oryginalną nazwę';

  @override
  String get matchOriginalNameSubtitle =>
      'Znajdź zmienione aplikacje po ich oryginalnej nazwie';

  @override
  String get hiddenApps => 'Ukryte aplikacje';

  @override
  String get hiddenAppsNone => 'Brak';

  @override
  String hiddenAppsCount(int count) {
    return '$count ukrytych';
  }

  @override
  String get noHiddenApps => 'Brak ukrytych aplikacji';

  @override
  String get leftOfHome => 'Po lewej od ekranu głównego';

  @override
  String get rightOfHome => 'Po prawej od ekranu głównego';

  @override
  String get panelNone => 'Brak';

  @override
  String get lockLayout => 'Zablokuj układ';

  @override
  String get lockLayoutSubtitle =>
      'Wyłącz przypinanie i długie naciśnięcie na ekranie głównym';

  @override
  String get searchOnlyMode => 'Tylko wyszukiwanie';

  @override
  String get searchOnlyModeSubtitle =>
      'Ukryj nazwy aplikacji, uruchamiaj przez wyszukiwanie';

  @override
  String get autoShowKeyboard => 'Pokaż klawiaturę';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Otwórz klawiaturę przy otwarciu szuflady';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Otwórz klawiaturę przy otwarciu zadań';

  @override
  String get autoLaunchOnMatch => 'Automatyczne uruchamianie';

  @override
  String get autoLaunchOnMatchSubtitle => 'Uruchom, gdy pasuje jedna aplikacja';

  @override
  String get taskScreen => 'Ekran zadań';

  @override
  String get taskScreenSubtitle => 'Przesuń w prawo, aby zobaczyć zadania';

  @override
  String get removeOnComplete => 'Usuń po ukończeniu';

  @override
  String get removeOnCompleteSubtitle =>
      'Usuń zadania po oznaczeniu jako wykonane';

  @override
  String get clearCompletedDaily => 'Codziennie usuwaj ukończone';

  @override
  String get clearCompletedDailySubtitle =>
      'Usuń ukończone zadania pod koniec dnia';

  @override
  String get taskOptionDisabled => 'Włącz ekran zadań, aby skonfigurować';

  @override
  String get donate => 'Wspomóż';

  @override
  String get donateSubtitle => 'Wesprzyj rozwój Last Launchera';

  @override
  String get rateApp => 'Oceń Last Launcher';

  @override
  String get rateAppSubtitle => 'Zostaw recenzję w Sklepie Play';

  @override
  String get sendFeedback => 'Wyślij opinię';

  @override
  String get sendFeedbackSubtitle => 'Wyślij e-mail do dewelopera';

  @override
  String get help => 'Pomoc';

  @override
  String get helpSubtitle => 'Zobacz stronę projektu';

  @override
  String get version => 'Wersja';

  @override
  String get license => 'Licencja';

  @override
  String get openSourceLicenses => 'Licencje open source';

  @override
  String get aboutSubtitle => 'Wersja i licencje';

  @override
  String get hintSwipeUp => 'Przesuń w górę, aby szukać';

  @override
  String get hintSwipeRight => 'Przesuń w prawo, aby zobaczyć zadania';

  @override
  String get hintLongPress => 'Przytrzymaj, aby otworzyć ustawienia';

  @override
  String get noResults => 'Brak wyników';

  @override
  String get emptyTaskList => 'Wpisz, aby dodać zadanie';

  @override
  String get returnToAddTask => 'Naciśnij Enter, aby dodać zadanie';

  @override
  String get actionRename => 'Zmień nazwę';

  @override
  String get actionUnpin => 'Odepnij';

  @override
  String get actionPin => 'Przypnij';

  @override
  String get actionPinFull => 'Pełne';

  @override
  String get actionHide => 'Ukryj';

  @override
  String get actionUnhide => 'Pokaż';

  @override
  String get actionDone => 'Gotowe';

  @override
  String get actionUndo => 'Cofnij';

  @override
  String get actionRemove => 'Usuń';

  @override
  String get actionClose => 'Zamknij';

  @override
  String get actionAppInfo => 'Informacje o aplikacji';

  @override
  String get renameDialogTitle => 'Zmień nazwę';

  @override
  String get renameDialogCancel => 'Anuluj';

  @override
  String get renameDialogSave => 'Zapisz';

  @override
  String get homeScreenFull => 'Ekran główny jest pełny';
}
