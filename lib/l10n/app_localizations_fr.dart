// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'Le dernier lanceur dont vous aurez besoin';

  @override
  String get settings => 'Paramètres';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get sectionApps => 'Applications';

  @override
  String get sectionBehavior => 'Comportement';

  @override
  String get sectionTasks => 'Tâches';

  @override
  String get sectionSupport => 'Soutien';

  @override
  String get sectionAbout => 'À propos';

  @override
  String get themeTitle => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Plein écran';

  @override
  String get hideStatusBarSubtitle =>
      'Masquer la barre d\'état et la navigation';

  @override
  String get homeScreenHints => 'Astuces de l\'écran d\'accueil';

  @override
  String get homeScreenHintsSubtitle =>
      'Afficher des astuces quand l\'écran d\'accueil est vide';

  @override
  String get hiddenApps => 'Applications masquées';

  @override
  String get hiddenAppsNone => 'Aucune';

  @override
  String hiddenAppsCount(int count) {
    return '$count masquées';
  }

  @override
  String get noHiddenApps => 'Aucune application masquée';

  @override
  String get searchOnlyMode => 'Recherche uniquement';

  @override
  String get searchOnlyModeSubtitle =>
      'Masquer les noms d\'apps, rechercher pour lancer';

  @override
  String get autoShowKeyboard => 'Afficher le clavier';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Ouvrir le clavier quand le tiroir s\'ouvre';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Ouvrir le clavier quand les tâches s\'ouvrent';

  @override
  String get autoLaunchOnMatch => 'Lancement auto à la correspondance';

  @override
  String get autoLaunchOnMatchSubtitle =>
      'Lancer quand une seule app correspond';

  @override
  String get taskScreen => 'Écran des tâches';

  @override
  String get taskScreenSubtitle =>
      'Glisser vers la droite depuis l\'accueil pour voir les tâches';

  @override
  String get removeOnComplete => 'Supprimer à l\'achèvement';

  @override
  String get removeOnCompleteSubtitle =>
      'Supprimer les tâches quand elles sont terminées';

  @override
  String get donate => 'Faire un don';

  @override
  String get donateSubtitle => 'Soutenir le développement de Last Launcher';

  @override
  String get version => 'Version';

  @override
  String get license => 'Licence';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get aboutSubtitle => 'Version et licences';

  @override
  String get hintSwipeUp => 'Glisser vers le haut pour rechercher';

  @override
  String get hintSwipeRight => 'Glisser vers la droite pour les tâches';

  @override
  String get hintLongPress => 'Appui long pour les paramètres';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get emptyTaskList => 'Tapez pour ajouter une nouvelle tâche';

  @override
  String get returnToAddTask => 'Appuyez sur Entrée pour ajouter';

  @override
  String get actionRename => 'Renommer';

  @override
  String get actionUnpin => 'Désépingler';

  @override
  String get actionPin => 'Épingler';

  @override
  String get actionPinFull => 'Plein';

  @override
  String get actionHide => 'Masquer';

  @override
  String get actionUnhide => 'Afficher';

  @override
  String get actionDone => 'Terminé';

  @override
  String get actionUndo => 'Annuler';

  @override
  String get actionRemove => 'Supprimer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionAppInfo => 'Infos sur l\'application';

  @override
  String get renameDialogTitle => 'Renommer';

  @override
  String get renameDialogCancel => 'Annuler';

  @override
  String get renameDialogSave => 'Enregistrer';

  @override
  String get homeScreenFull => 'L\'écran d\'accueil est plein';
}
