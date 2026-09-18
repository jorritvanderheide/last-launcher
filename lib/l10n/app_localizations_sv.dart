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
  String get sectionHome => 'Hem';

  @override
  String get sectionAppDrawer => 'Applåda';

  @override
  String get sectionTasks => 'Uppgifter';

  @override
  String get sectionModules => 'Moduler';

  @override
  String get sectionSupport => 'Stöd';

  @override
  String get sectionAbout => 'Om';

  @override
  String get sectionSearch => 'Sök';

  @override
  String get sectionWork => 'Arbetsprofil';

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
  String get themeStyleTitle => 'Stil';

  @override
  String get themeStyleStandard => 'Standard';

  @override
  String get themeStyleCustom => 'Anpassad';

  @override
  String get fontTitle => 'Typsnitt';

  @override
  String get fontStandard => 'Standard';

  @override
  String get fontMono => 'Monospace';

  @override
  String get terminalPrompt => 'Terminalprompt';

  @override
  String get terminalPromptSubtitle => 'Visa sökningen som en kommandorad';

  @override
  String get sectionEffects => 'Effekter';

  @override
  String get effectsDarkOnly => 'Endast i mörkt läge';

  @override
  String get glow => 'Glöd';

  @override
  String get scanlines => 'Sveplinjer';

  @override
  String get scanlinesOff => 'Av';

  @override
  String get scanlinesLight => 'Svaga';

  @override
  String get scanlinesMedium => 'Mellan';

  @override
  String get scanlinesStrong => 'Starka';

  @override
  String get animations => 'Animationer';

  @override
  String get animationsSubtitle =>
      'Rörliga sveplinjer, glitchar och blinkande markör';

  @override
  String get hideStatusBar => 'Helskärm';

  @override
  String get hideStatusBarSubtitle => 'Dölj statusfält och navigering';

  @override
  String get showHints => 'Visa tips';

  @override
  String get showHintsSubtitle => 'Visa användningstips i hela appen';

  @override
  String get hidePinnedApps => 'Dölj fästa appar';

  @override
  String get hidePinnedAppsSubtitle => 'Dölj fästa appar från app-lådan';

  @override
  String get includeHiddenInSearch => 'Inkludera dolda i sökning';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Låt sökningen även matcha dolda appar';

  @override
  String get matchOriginalName => 'Matcha originalnamn';

  @override
  String get matchOriginalNameSubtitle =>
      'Hitta omdöpta appar med deras originalnamn';

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
  String get leftOfHome => 'Vänster modul';

  @override
  String get rightOfHome => 'Höger modul';

  @override
  String get panelNone => 'Ingen';

  @override
  String get lockLayout => 'Lås layout';

  @override
  String get lockLayoutSubtitle =>
      'Inaktivera fästning och långtryckning på hemskärmen';

  @override
  String get doubleTapToSleep => 'Dubbeltryck för att låsa';

  @override
  String get doubleTapToSleepSubtitle =>
      'Kräver tillgänglighetstjänst aktiverad i systeminställningarna';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Ange som standard hem-app';

  @override
  String get setAsDefaultSubtitle => 'Öppna systemets väljare';

  @override
  String get drawerMode => 'Lådläge';

  @override
  String get drawerModeList => 'Lista';

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
  String get quickLaunchHints => 'Snabbstartledtrådar';

  @override
  String get quickLaunchHintsSubtitle =>
      'Markera kortaste unika tecknen för att starta';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'uppgifter';

  @override
  String get removeOnComplete => 'Ta bort vid slutförande';

  @override
  String get removeOnCompleteSubtitle =>
      'Ta bort uppgifter när de markeras som klara';

  @override
  String get clearCompletedDaily => 'Rensa klara dagligen';

  @override
  String get clearCompletedDailySubtitle =>
      'Ta bort klara uppgifter i slutet av dagen';

  @override
  String get donate => 'Donera';

  @override
  String get donateSubtitle => 'Stöd utvecklingen av Last Launcher';

  @override
  String get rateApp => 'Betygsätt Last Launcher';

  @override
  String get rateAppSubtitle => 'Lämna ett omdöme i Play Butik';

  @override
  String get sendFeedback => 'Skicka feedback';

  @override
  String get sendFeedbackSubtitle => 'Mejla utvecklaren';

  @override
  String get help => 'Hjälp';

  @override
  String get helpSubtitle => 'Visa projektsidan';

  @override
  String get version => 'Version';

  @override
  String get license => 'Licens';

  @override
  String get openSourceLicenses => 'Licenser för öppen källkod';

  @override
  String get aboutSubtitle => 'Version och licenser';

  @override
  String get hintSwipeUp => 'Svep uppåt för appar';

  @override
  String hintSwipeRightFor(String module) {
    return 'Svep höger för $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Svep vänster för $module';
  }

  @override
  String get hintLongPress => 'Tryck länge för inställningar';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get emptyTaskList => 'Skriv för att lägga till en uppgift';

  @override
  String get returnToAddTask => 'Tryck på Enter för att lägga till en uppgift';

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
  String get actionRemove => 'Ta bort';

  @override
  String get actionClose => 'Stäng';

  @override
  String get actionAppInfo => 'Appinfo';

  @override
  String get actionEnable => 'Aktivera';

  @override
  String get renameDialogTitle => 'Byt namn';

  @override
  String get renameDialogCancel => 'Avbryt';

  @override
  String get renameDialogSave => 'Spara';

  @override
  String get showWorkAppDot => 'Visa prick för arbetsprofil';

  @override
  String get showWorkAppDotSubtitle =>
      'Visa en liten prick framför appar från arbetsprofilen';

  @override
  String get showWorkAppDotOnHome => 'Visa prick på hemskärmen';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Visa arbetsprofilprick för fästa appar på hemskärmen';

  @override
  String get hidePersonalWhenWorkActive => 'Visa inte privata appar';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Privata appar visas igen när arbetsprofilen pausas';

  @override
  String get homeScreenFull => 'Hemskärmen är full';
}
