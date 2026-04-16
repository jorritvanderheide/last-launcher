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
  String get appTagline => 'O último inicializador que você vai precisar';

  @override
  String get settings => 'Configurações';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get sectionApps => 'Apps';

  @override
  String get sectionBehavior => 'Comportamento';

  @override
  String get sectionTasks => 'Tarefas';

  @override
  String get sectionSupport => 'Apoio';

  @override
  String get sectionAbout => 'Sobre';

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
  String get hideStatusBar => 'Tela cheia';

  @override
  String get hideStatusBarSubtitle => 'Ocultar barra de status e navegação';

  @override
  String get homeScreenHints => 'Dicas da tela inicial';

  @override
  String get homeScreenHintsSubtitle =>
      'Mostrar dicas quando a tela inicial estiver vazia';

  @override
  String get hiddenApps => 'Apps ocultos';

  @override
  String get hiddenAppsNone => 'Nenhum';

  @override
  String hiddenAppsCount(int count) {
    return '$count ocultos';
  }

  @override
  String get noHiddenApps => 'Nenhum app oculto';

  @override
  String get searchOnlyMode => 'Apenas pesquisa';

  @override
  String get searchOnlyModeSubtitle =>
      'Ocultar nomes de apps, pesquisar para abrir';

  @override
  String get autoShowKeyboard => 'Mostrar teclado';

  @override
  String get autoShowKeyboardAppsSubtitle => 'Abrir teclado ao abrir a gaveta';

  @override
  String get autoShowKeyboardTasksSubtitle => 'Abrir teclado ao abrir tarefas';

  @override
  String get autoLaunchOnMatch => 'Abrir ao encontrar';

  @override
  String get autoLaunchOnMatchSubtitle =>
      'Abrir quando apenas um app corresponder';

  @override
  String get taskScreen => 'Tela de tarefas';

  @override
  String get taskScreenSubtitle => 'Deslize para a direita para ver tarefas';

  @override
  String get removeOnComplete => 'Remover ao concluir';

  @override
  String get removeOnCompleteSubtitle =>
      'Remover tarefas quando marcadas como concluídas';

  @override
  String get donate => 'Doar';

  @override
  String get donateSubtitle => 'Apoie o desenvolvimento do Last Launcher';

  @override
  String get version => 'Versão';

  @override
  String get license => 'Licença';

  @override
  String get openSourceLicenses => 'Licenças de código aberto';

  @override
  String get hintSwipeUp => 'Deslize para cima para pesquisar';

  @override
  String get hintSwipeRight => 'Deslize para a direita para tarefas';

  @override
  String get hintLongPress => 'Pressione longo para configurações';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get returnToAddTask => 'Digite para adicionar tarefa';

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
  String get actionUndo => 'Desfazer';

  @override
  String get actionRemove => 'Remover';

  @override
  String get renameDialogTitle => 'Renomear';

  @override
  String get renameDialogCancel => 'Cancelar';

  @override
  String get renameDialogSave => 'Salvar';

  @override
  String get homeScreenFull => 'A tela inicial está cheia';
}
