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
  String get sectionHome => 'Accueil';

  @override
  String get sectionAppDrawer => 'Tiroir d\'applications';

  @override
  String get sectionTasks => 'Tâches';

  @override
  String get sectionModules => 'Modules';

  @override
  String get sectionSupport => 'Soutien';

  @override
  String get sectionAbout => 'À propos';

  @override
  String get sectionSearch => 'Recherche';

  @override
  String get sectionWork => 'Profil professionnel';

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
  String get themeStyleTitle => 'Style';

  @override
  String get themeStyleStandard => 'Standard';

  @override
  String get themeStyleCustom => 'Personnalisé';

  @override
  String get fontTitle => 'Police';

  @override
  String get fontStandard => 'Standard';

  @override
  String get fontMono => 'Monospace';

  @override
  String get textSizeTitle => 'Taille du texte';

  @override
  String get textAlignTitle => 'Alignement du texte';

  @override
  String get alignLeft => 'Gauche';

  @override
  String get alignCenter => 'Centré';

  @override
  String get alignRight => 'Droite';

  @override
  String get accentColor => 'Couleur d\'accentuation';

  @override
  String get accentColorSubtitle =>
      'Teinter le texte et le fond avec la couleur d\'accentuation du système';

  @override
  String get terminalPrompt => 'Invite de commande';

  @override
  String get terminalPromptSubtitle =>
      'Afficher la recherche comme une ligne de commande';

  @override
  String get sectionEffects => 'Effets';

  @override
  String get effectsDarkOnly => 'En mode sombre uniquement';

  @override
  String get glow => 'Lueur';

  @override
  String get scanlines => 'Lignes de balayage';

  @override
  String get scanlinesOff => 'Désactivées';

  @override
  String get scanlinesLight => 'Légères';

  @override
  String get scanlinesMedium => 'Moyennes';

  @override
  String get scanlinesStrong => 'Fortes';

  @override
  String get animations => 'Animations';

  @override
  String get animationsSubtitle =>
      'Balayage animé, glitchs et curseur clignotant';

  @override
  String get hideStatusBar => 'Plein écran';

  @override
  String get hideStatusBarSubtitle =>
      'Masquer la barre d\'état et la navigation';

  @override
  String get showHints => 'Afficher les astuces';

  @override
  String get showHintsSubtitle =>
      'Afficher les astuces d\'utilisation dans toute l\'appli';

  @override
  String get hidePinnedApps => 'Masquer les apps épinglées';

  @override
  String get hidePinnedAppsSubtitle =>
      'Masquer les applications épinglées de la liste';

  @override
  String get includeHiddenInSearch => 'Inclure les masquées dans la recherche';

  @override
  String get includeHiddenInSearchSubtitle =>
      'La recherche correspond aussi aux applications masquées';

  @override
  String get matchOriginalName => 'Correspondre au nom d\'origine';

  @override
  String get matchOriginalNameSubtitle =>
      'Trouver les applications renommées par leur nom d\'origine';

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
  String get leftOfHome => 'Module gauche';

  @override
  String get rightOfHome => 'Module droit';

  @override
  String get panelNone => 'Aucun';

  @override
  String get lockLayout => 'Verrouiller la disposition';

  @override
  String get lockLayoutSubtitle =>
      'Désactiver l\'épinglage et l\'appui long sur l\'écran d\'accueil';

  @override
  String get doubleTapToSleep => 'Double appui pour verrouiller';

  @override
  String get doubleTapToSleepSubtitle =>
      'Nécessite le service d\'accessibilité activé dans les paramètres système';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Définir comme app d\'accueil par défaut';

  @override
  String get setAsDefaultSubtitle => 'Ouvrir le sélecteur système';

  @override
  String get drawerMode => 'Mode du tiroir';

  @override
  String get drawerModeList => 'Liste';

  @override
  String get searchOnlyMode => 'Recherche uniquement';

  @override
  String get searchOnlyModeSubtitle =>
      'Masquer les noms d\'apps, rechercher pour lancer';

  @override
  String get prefixNoApp => 'Aucune application ne peut ouvrir ceci';

  @override
  String get prefixTypeWork => 'Applications professionnelles';

  @override
  String get prefixTypePersonal => 'Applications personnelles';

  @override
  String get searchPrefixes => 'Préfixes de recherche';

  @override
  String get searchPrefixesSubtitle =>
      'Rechercher sur le web, sur une carte ou dans une application depuis le champ de recherche';

  @override
  String get prefixAdd => 'Ajouter un préfixe';

  @override
  String get prefixRestoreDefaults =>
      'Rétablir les préfixes professionnel et personnel';

  @override
  String get prefixTrigger => 'Préfixe';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Affiché comme $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'Les applications commençant par ces lettres sont introuvables tant que ceci est actif. Terminez-le par une espace ou commencez-le par un symbole.';

  @override
  String get prefixName => 'Nom';

  @override
  String get prefixType => 'Action';

  @override
  String get prefixTypeLink => 'Ouvrir un lien';

  @override
  String get prefixTypeSearchInApp => 'Rechercher dans une application';

  @override
  String get prefixTemplates => 'Partir de';

  @override
  String get prefixLink => 'Lien';

  @override
  String get prefixLinkHelp => '%s indique l\'emplacement de la recherche';

  @override
  String get prefixOpenWith => 'Ouvrir avec';

  @override
  String get prefixAnyApp => 'N\'importe quelle application';

  @override
  String get prefixApp => 'Application';

  @override
  String get prefixNoSearchApps =>
      'Aucune application ne propose sa propre recherche';

  @override
  String get prefixPersonalAppsOnly =>
      'Les applications du profil professionnel ne peuvent pas être utilisées ici';

  @override
  String get prefixErrorEmpty => 'Saisissez un préfixe';

  @override
  String get prefixErrorTaken => 'Un autre préfixe l\'utilise déjà';

  @override
  String get prefixErrorNoPlaceholder => 'Placez %s là où va la recherche';

  @override
  String get prefixTemplateMaps => 'Cartes';

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
  String get quickLaunchHints => 'Indicateurs de lancement rapide';

  @override
  String get quickLaunchHintsSubtitle =>
      'Mettre en évidence les caractères uniques les plus courts pour lancer';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'les tâches';

  @override
  String get panelLaunchApp => 'Lancer une application';

  @override
  String get panelLaunchAppHint => 'une application';

  @override
  String get launchAppLeft => 'Application de gauche';

  @override
  String get launchAppRight => 'Application de droite';

  @override
  String get launchAppChoose => 'Choisir une application';

  @override
  String get launchAppOnlyLeft => 'Seulement si c\'est le module gauche';

  @override
  String get launchAppOnlyRight => 'Seulement si c\'est le module droit';

  @override
  String get removeOnComplete => 'Supprimer à l\'achèvement';

  @override
  String get removeOnCompleteSubtitle =>
      'Supprimer les tâches quand elles sont terminées';

  @override
  String get clearCompletedDaily => 'Effacer les terminées chaque jour';

  @override
  String get clearCompletedDailySubtitle =>
      'Supprimer les tâches terminées à la fin de la journée';

  @override
  String get donate => 'Faire un don';

  @override
  String get donateSubtitle => 'Soutenir le développement de Last Launcher';

  @override
  String get rateApp => 'Noter Last Launcher';

  @override
  String get rateAppSubtitle => 'Laissez un avis sur le Play Store';

  @override
  String get sendFeedback => 'Envoyer un retour';

  @override
  String get sendFeedbackSubtitle => 'Envoyer un e-mail au développeur';

  @override
  String get help => 'Aide';

  @override
  String get helpSubtitle => 'Voir la page du projet';

  @override
  String get version => 'Version';

  @override
  String get license => 'Licence';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get aboutSubtitle => 'Version et licences';

  @override
  String get backupTitle => 'Sauvegarde et restauration';

  @override
  String get backupExport => 'Exporter une sauvegarde';

  @override
  String get backupExportSubtitle =>
      'Enregistrer paramètres, noms, applications masquées et épinglées dans un fichier';

  @override
  String get backupRestore => 'Restaurer une sauvegarde';

  @override
  String get backupRestoreSubtitle =>
      'Tout remplacer par une sauvegarde enregistrée';

  @override
  String get backupAlsoInclude => 'Inclure aussi';

  @override
  String get backupRestoreConfirm =>
      'Cela remplace les paramètres, noms, applications masquées et épinglées actuels.';

  @override
  String get backupExportAction => 'Exporter';

  @override
  String get backupRestoreAction => 'Restaurer';

  @override
  String get backupSaved => 'Sauvegarde enregistrée';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get backupInvalid =>
      'Ce fichier n\'est pas une sauvegarde Last Launcher';

  @override
  String get backupTooNew =>
      'Cette sauvegarde provient d\'une version plus récente de Last Launcher';

  @override
  String get backupFailed => 'Impossible de lire ou d\'écrire le fichier';

  @override
  String get hintSwipeUp => 'Glissez vers le haut pour les apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Glissez à droite pour $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Glissez à gauche pour $module';
  }

  @override
  String get hintLongPress => 'Appui long pour les paramètres';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get emptyTaskList => 'Tapez pour ajouter une tâche';

  @override
  String get returnToAddTask => 'Appuyez sur Entrée pour ajouter une tâche';

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
  String get actionRemove => 'Supprimer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionAppInfo => 'Infos sur l\'application';

  @override
  String get actionEnable => 'Activer';

  @override
  String get renameDialogTitle => 'Renommer';

  @override
  String get renameDialogCancel => 'Annuler';

  @override
  String get renameDialogSave => 'Enregistrer';

  @override
  String get showWorkAppDot => 'Point du profil professionnel';

  @override
  String get showWorkAppDotSubtitle =>
      'Afficher un petit point devant les applications du profil professionnel';

  @override
  String get showWorkAppDotOnHome =>
      'Afficher le point sur l\'écran d\'accueil';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Afficher le point du profil professionnel sur les applications épinglées de l\'écran d\'accueil';

  @override
  String get hidePersonalWhenWorkActive =>
      'Ne pas afficher les apps personnelles';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Les apps personnelles réapparaissent lorsque le profil professionnel est suspendu';

  @override
  String get homeScreenFull => 'L\'écran d\'accueil est plein';
}
