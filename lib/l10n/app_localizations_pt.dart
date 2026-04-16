// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'O último launcher de que vais precisar';

  @override
  String get settings => 'Definições';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get sectionApps => 'Aplicações';

  @override
  String get sectionBehavior => 'Comportamento';

  @override
  String get sectionTasks => 'Tarefas';

  @override
  String get sectionSupport => 'Apoio';

  @override
  String get sectionAbout => 'Acerca';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'Ecrã inteiro';

  @override
  String get hideStatusBarSubtitle => 'Ocultar barra de estado e de navegação';

  @override
  String get showHints => 'Mostrar dicas';

  @override
  String get showHintsSubtitle =>
      'Mostrar dicas de utilização em toda a aplicação';

  @override
  String get hiddenApps => 'Aplicações ocultas';

  @override
  String get hiddenAppsNone => 'Nenhuma';

  @override
  String hiddenAppsCount(int count) {
    return '$count ocultas';
  }

  @override
  String get noHiddenApps => 'Nenhuma aplicação oculta';

  @override
  String get searchOnlyMode => 'Apenas pesquisa';

  @override
  String get searchOnlyModeSubtitle =>
      'Ocultar nomes das aplicações, pesquisar para abrir';

  @override
  String get autoShowKeyboard => 'Mostrar teclado';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Abrir o teclado ao abrir a gaveta';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Abrir o teclado ao abrir as tarefas';

  @override
  String get autoLaunchOnMatch => 'Abrir ao corresponder';

  @override
  String get autoLaunchOnMatchSubtitle =>
      'Abrir quando apenas uma aplicação corresponder';

  @override
  String get taskScreen => 'Ecrã de tarefas';

  @override
  String get taskScreenSubtitle => 'Desliza para a direita para ver as tarefas';

  @override
  String get removeOnComplete => 'Remover ao concluir';

  @override
  String get removeOnCompleteSubtitle =>
      'Remover tarefas quando marcadas como concluídas';

  @override
  String get donate => 'Doar';

  @override
  String get donateSubtitle => 'Apoia o desenvolvimento do Last Launcher';

  @override
  String get version => 'Versão';

  @override
  String get license => 'Licença';

  @override
  String get openSourceLicenses => 'Licenças de código aberto';

  @override
  String get aboutSubtitle => 'Versão e licenças';

  @override
  String get hintSwipeUp => 'Desliza para cima para pesquisar';

  @override
  String get hintSwipeRight => 'Desliza para a direita para as tarefas';

  @override
  String get hintLongPress => 'Prime longamente para as definições';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get emptyTaskList => 'Escreve para adicionar uma tarefa';

  @override
  String get returnToAddTask => 'Prime Enter para adicionar uma tarefa';

  @override
  String get actionRename => 'Renomear';

  @override
  String get actionUnpin => 'Desafixar';

  @override
  String get actionPin => 'Fixar';

  @override
  String get actionPinFull => 'Cheio';

  @override
  String get actionHide => 'Ocultar';

  @override
  String get actionUnhide => 'Mostrar';

  @override
  String get actionDone => 'Concluído';

  @override
  String get actionUndo => 'Anular';

  @override
  String get actionRemove => 'Remover';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionAppInfo => 'Informações da aplicação';

  @override
  String get renameDialogTitle => 'Renomear';

  @override
  String get renameDialogCancel => 'Cancelar';

  @override
  String get renameDialogSave => 'Guardar';

  @override
  String get homeScreenFull => 'O ecrã inicial está cheio';
}
