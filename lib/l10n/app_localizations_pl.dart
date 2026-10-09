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
  String get sectionSupport => 'Wsparcie';

  @override
  String get sectionAbout => 'O aplikacji';

  @override
  String get sectionSearch => 'Szukaj';

  @override
  String get sectionWork => 'Profil pracy';

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
  String get themeStyleTitle => 'Styl';

  @override
  String get themeStyleStandard => 'Standardowy';

  @override
  String get themeStyleCustom => 'Własny';

  @override
  String get fontTitle => 'Czcionka';

  @override
  String get fontStandard => 'Standardowa';

  @override
  String get fontMono => 'Stałej szerokości';

  @override
  String get textSizeTitle => 'Rozmiar tekstu';

  @override
  String get textAlignTitle => 'Wyrównanie tekstu';

  @override
  String get alignLeft => 'Do lewej';

  @override
  String get alignCenter => 'Do środka';

  @override
  String get alignRight => 'Do prawej';

  @override
  String get accentColor => 'Kolor akcentu';

  @override
  String get accentColorSubtitle =>
      'Zabarw tekst i tło systemowym kolorem akcentu';

  @override
  String get terminalPrompt => 'Wiersz poleceń';

  @override
  String get terminalPromptSubtitle => 'Pokaż wyszukiwanie jako wiersz poleceń';

  @override
  String get sectionEffects => 'Efekty';

  @override
  String get effectsDarkOnly => 'Tylko w trybie ciemnym';

  @override
  String get glow => 'Poświata';

  @override
  String get scanlines => 'Linie skanowania';

  @override
  String get scanlinesOff => 'Wyłączone';

  @override
  String get scanlinesLight => 'Słabe';

  @override
  String get scanlinesMedium => 'Średnie';

  @override
  String get scanlinesStrong => 'Mocne';

  @override
  String get animations => 'Animacje';

  @override
  String get animationsSubtitle =>
      'Ruchome linie, zakłócenia i migający kursor';

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
  String get leftOfHome => 'Lewy moduł';

  @override
  String get rightOfHome => 'Prawy moduł';

  @override
  String get panelNone => 'Brak';

  @override
  String get lockLayout => 'Zablokuj układ';

  @override
  String get lockLayoutSubtitle =>
      'Wyłącz przypinanie i długie naciśnięcie na ekranie głównym';

  @override
  String get doubleTapToSleep => 'Podwójne dotknięcie, aby uśpić';

  @override
  String get doubleTapToSleepSubtitle =>
      'Wymaga włączenia usługi dostępności w ustawieniach systemu';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get setAsDefault => 'Ustaw jako domyślną aplikację domową';

  @override
  String get setAsDefaultSubtitle => 'Otwórz systemowy selektor';

  @override
  String get drawerMode => 'Tryb szuflady';

  @override
  String get drawerModeList => 'Lista';

  @override
  String get searchOnlyMode => 'Tylko wyszukiwanie';

  @override
  String get prefixNoApp => 'Żadna aplikacja nie może tego otworzyć';

  @override
  String get prefixTypeWork => 'Aplikacje służbowe';

  @override
  String get prefixTypePersonal => 'Aplikacje osobiste';

  @override
  String get searchPrefixes => 'Prefiksy wyszukiwania';

  @override
  String get searchPrefixesSubtitle =>
      'Szukaj w sieci lub w aplikacji z pola wyszukiwania';

  @override
  String get prefixAdd => 'Dodaj prefiks';

  @override
  String get prefixRestoreDefaults => 'Przywróć prefiksy służbowy i osobisty';

  @override
  String get prefixTrigger => 'Prefiks';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Wyświetlany jako $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Aplikacji zaczynających się od tych liter nie da się znaleźć, gdy to jest włączone. Zakończ spacją lub zacznij symbolem.';

  @override
  String get prefixName => 'Nazwa';

  @override
  String get prefixType => 'Akcja';

  @override
  String get prefixTypeLink => 'Otwórz link';

  @override
  String get prefixTypeSearchInApp => 'Szukaj w aplikacji';

  @override
  String get prefixTemplates => 'Zacznij od';

  @override
  String get prefixLink => 'Link';

  @override
  String get prefixLinkHelp => '%s oznacza miejsce wyszukiwanej frazy';

  @override
  String get prefixOpenWith => 'Otwórz w';

  @override
  String get prefixAnyApp => 'Dowolna aplikacja';

  @override
  String get prefixApp => 'Aplikacja';

  @override
  String get prefixNoSearchApps =>
      'Żadna aplikacja nie oferuje własnego wyszukiwania';

  @override
  String get prefixPersonalAppsOnly =>
      'Aplikacji z profilu służbowego nie można tu użyć';

  @override
  String get prefixErrorEmpty => 'Wpisz prefiks';

  @override
  String get prefixErrorTaken => 'Inny prefiks już tego używa';

  @override
  String get prefixErrorNoPlaceholder =>
      'Wstaw %s w miejsce wyszukiwanej frazy';

  @override
  String get prefixTemplateMaps => 'Mapy';

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
  String get quickLaunchHints => 'Szybkie podpowiedzi uruchamiania';

  @override
  String get quickLaunchHintsSubtitle =>
      'Podświetl najkrótsze unikalne znaki do uruchomienia';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'zadania';

  @override
  String get panelLaunchApp => 'Uruchom aplikację';

  @override
  String get panelLaunchAppHint => 'aplikacji';

  @override
  String get launchAppLeft => 'Lewa aplikacja';

  @override
  String get launchAppRight => 'Prawa aplikacja';

  @override
  String get launchAppChoose => 'Wybierz aplikację';

  @override
  String get launchAppOnlyLeft => 'Tylko gdy to jest lewy moduł';

  @override
  String get launchAppOnlyRight => 'Tylko gdy to jest prawy moduł';

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
  String get helpSubtitle => 'Odpowiedzi na częste pytania';

  @override
  String get version => 'Wersja';

  @override
  String get license => 'Licencja';

  @override
  String get openSourceLicenses => 'Licencje open source';

  @override
  String get aboutSubtitle => 'Wersja i licencje';

  @override
  String get backupTitle => 'Kopia zapasowa';

  @override
  String get backupExport => 'Eksportuj kopię';

  @override
  String get backupExportSubtitle =>
      'Zapisz ustawienia, nazwy oraz ukryte i przypięte aplikacje w pliku';

  @override
  String get backupRestore => 'Przywróć kopię';

  @override
  String get backupRestoreSubtitle => 'Zastąp wszystko zapisaną kopią';

  @override
  String get backupAlsoInclude => 'Uwzględnij też';

  @override
  String get backupRestoreConfirm =>
      'Spowoduje to zastąpienie obecnych ustawień, nazw oraz ukrytych i przypiętych aplikacji.';

  @override
  String get backupExportAction => 'Eksportuj';

  @override
  String get backupRestoreAction => 'Przywróć';

  @override
  String get backupSaved => 'Kopia zapisana';

  @override
  String get backupRestored => 'Kopia przywrócona';

  @override
  String get backupInvalid => 'Ten plik nie jest kopią Last Launcher';

  @override
  String get backupTooNew => 'Ta kopia pochodzi z nowszej wersji Last Launcher';

  @override
  String get backupFailed => 'Nie można odczytać ani zapisać pliku';

  @override
  String get hintSwipeUp => 'Przesuń w górę dla aplikacji';

  @override
  String hintSwipeRightFor(String module) {
    return 'Przesuń w prawo dla $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Przesuń w lewo dla $module';
  }

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
  String get actionRemove => 'Usuń';

  @override
  String get actionClose => 'Zamknij';

  @override
  String get actionAppInfo => 'Informacje o aplikacji';

  @override
  String get actionEnable => 'Włącz';

  @override
  String get renameDialogTitle => 'Zmień nazwę';

  @override
  String get renameDialogCancel => 'Anuluj';

  @override
  String get renameDialogSave => 'Zapisz';

  @override
  String get showWorkAppDot => 'Pokaż kropkę profilu pracy';

  @override
  String get showWorkAppDotSubtitle =>
      'Pokaż małą kropkę przed aplikacjami profilu pracy';

  @override
  String get showWorkAppDotOnHome => 'Pokaż kropkę na ekranie głównym';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Pokaż kropkę profilu pracy w przypiętych aplikacjach na ekranie głównym';

  @override
  String get hidePersonalWhenWorkActive => 'Nie pokazuj aplikacji osobistych';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Aplikacje osobiste pojawią się ponownie po wstrzymaniu profilu pracy';

  @override
  String get homeScreenFull => 'Ekran główny jest pełny';
}
