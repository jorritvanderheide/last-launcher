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
  String get sectionHome => 'Ecrã inicial';

  @override
  String get sectionAppDrawer => 'Gaveta de aplicações';

  @override
  String get sectionTasks => 'Tarefas';

  @override
  String get sectionModules => 'Módulos';

  @override
  String get sectionSupport => 'Apoio';

  @override
  String get sectionAbout => 'Acerca';

  @override
  String get sectionSearch => 'Pesquisa';

  @override
  String get sectionWork => 'Perfil de trabalho';

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
  String get themeStyleTitle => 'Estilo';

  @override
  String get themeStyleStandard => 'Padrão';

  @override
  String get themeStyleCustom => 'Personalizado';

  @override
  String get fontTitle => 'Tipo de letra';

  @override
  String get fontStandard => 'Padrão';

  @override
  String get fontMono => 'Monoespaçado';

  @override
  String get textSizeTitle => 'Tamanho do texto';

  @override
  String get textAlignTitle => 'Alinhamento do texto';

  @override
  String get alignLeft => 'Esquerda';

  @override
  String get alignCenter => 'Centro';

  @override
  String get alignRight => 'Direita';

  @override
  String get accentColor => 'Cor de destaque';

  @override
  String get accentColorSubtitle =>
      'Colorir o texto e o fundo com a cor de destaque do sistema';

  @override
  String get terminalPrompt => 'Linha de comandos';

  @override
  String get terminalPromptSubtitle =>
      'Mostrar a pesquisa como linha de comandos';

  @override
  String get sectionEffects => 'Efeitos';

  @override
  String get effectsDarkOnly => 'Só no modo escuro';

  @override
  String get glow => 'Brilho';

  @override
  String get scanlines => 'Linhas de varrimento';

  @override
  String get scanlinesOff => 'Desligadas';

  @override
  String get scanlinesLight => 'Leves';

  @override
  String get scanlinesMedium => 'Médias';

  @override
  String get scanlinesStrong => 'Fortes';

  @override
  String get animations => 'Animações';

  @override
  String get animationsSubtitle =>
      'Linhas em movimento, falhas e cursor intermitente';

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
  String get hidePinnedApps => 'Ocultar aplicações fixadas';

  @override
  String get hidePinnedAppsSubtitle => 'Ocultar aplicações fixadas da gaveta';

  @override
  String get includeHiddenInSearch => 'Incluir ocultas na pesquisa';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Permite que a pesquisa encontre aplicações ocultas';

  @override
  String get matchOriginalName => 'Corresponder nome original';

  @override
  String get matchOriginalNameSubtitle =>
      'Encontrar aplicações renomeadas pelo nome original';

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
  String get leftOfHome => 'Módulo esquerdo';

  @override
  String get rightOfHome => 'Módulo direito';

  @override
  String get panelNone => 'Nenhum';

  @override
  String get lockLayout => 'Bloquear disposição';

  @override
  String get lockLayoutSubtitle =>
      'Desativar fixar e o toque longo no ecrã inicial';

  @override
  String get doubleTapToSleep => 'Toque duplo para suspender';

  @override
  String get doubleTapToSleepSubtitle =>
      'Requer serviço de acessibilidade ativado nas configurações do sistema';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Definir como app inicial predefinida';

  @override
  String get setAsDefaultSubtitle => 'Abrir o seletor do sistema';

  @override
  String get drawerMode => 'Modo da gaveta';

  @override
  String get drawerModeList => 'Lista';

  @override
  String get searchOnlyMode => 'Apenas pesquisa';

  @override
  String get searchOnlyModeSubtitle =>
      'Ocultar nomes das aplicações, pesquisar para abrir';

  @override
  String get prefixNoApp => 'Nenhuma aplicação consegue abrir isto';

  @override
  String get prefixTypeWork => 'Aplicações de trabalho';

  @override
  String get prefixTypePersonal => 'Aplicações pessoais';

  @override
  String get searchPrefixes => 'Prefixos de pesquisa';

  @override
  String get searchPrefixesSubtitle =>
      'Pesquisa na web ou numa aplicação a partir do campo de pesquisa';

  @override
  String get prefixAdd => 'Adicionar prefixo';

  @override
  String get prefixRestoreDefaults => 'Repor os prefixos de trabalho e pessoal';

  @override
  String get prefixTrigger => 'Prefixo';

  @override
  String prefixTriggerShownAs(String trigger) {
    return 'Mostrado como $trigger';
  }

  @override
  String get prefixShadowWarning =>
      'As aplicações que começam por estas letras não podem ser encontradas enquanto isto estiver ativo. Termina com um espaço ou começa com um símbolo.';

  @override
  String get prefixName => 'Nome';

  @override
  String get prefixType => 'Ação';

  @override
  String get prefixTypeLink => 'Abrir uma ligação';

  @override
  String get prefixTypeSearchInApp => 'Pesquisar numa aplicação';

  @override
  String get prefixTemplates => 'Partir de';

  @override
  String get prefixLink => 'Ligação';

  @override
  String get prefixLinkHelp => '%s marca onde fica a pesquisa';

  @override
  String get prefixOpenWith => 'Abrir com';

  @override
  String get prefixAnyApp => 'Qualquer aplicação';

  @override
  String get prefixApp => 'Aplicação';

  @override
  String get prefixNoSearchApps => 'Nenhuma aplicação oferece pesquisa própria';

  @override
  String get prefixPersonalAppsOnly =>
      'As aplicações do perfil de trabalho não podem ser usadas aqui';

  @override
  String get prefixErrorEmpty => 'Introduz um prefixo';

  @override
  String get prefixErrorTaken => 'Outro prefixo já usa isto';

  @override
  String get prefixErrorNoPlaceholder => 'Coloca %s onde fica a pesquisa';

  @override
  String get prefixTemplateMaps => 'Mapas';

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
  String get quickLaunchHints => 'Dicas de abertura rápida';

  @override
  String get quickLaunchHintsSubtitle =>
      'Realçar os caracteres únicos mais curtos para abrir';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'tarefas';

  @override
  String get panelLaunchApp => 'Abrir aplicação';

  @override
  String get panelLaunchAppHint => 'uma aplicação';

  @override
  String get launchAppLeft => 'Aplicação esquerda';

  @override
  String get launchAppRight => 'Aplicação direita';

  @override
  String get launchAppChoose => 'Escolher uma aplicação';

  @override
  String get launchAppOnlyLeft => 'Só quando este é o módulo esquerdo';

  @override
  String get launchAppOnlyRight => 'Só quando este é o módulo direito';

  @override
  String get removeOnComplete => 'Remover ao concluir';

  @override
  String get removeOnCompleteSubtitle =>
      'Remover tarefas quando marcadas como concluídas';

  @override
  String get clearCompletedDaily => 'Limpar concluídas diariamente';

  @override
  String get clearCompletedDailySubtitle =>
      'Remover tarefas concluídas no fim do dia';

  @override
  String get donate => 'Doar';

  @override
  String get donateSubtitle => 'Apoia o desenvolvimento do Last Launcher';

  @override
  String get rateApp => 'Avaliar Last Launcher';

  @override
  String get rateAppSubtitle => 'Deixa uma avaliação na Play Store';

  @override
  String get sendFeedback => 'Enviar comentários';

  @override
  String get sendFeedbackSubtitle => 'Envia um e-mail ao programador';

  @override
  String get help => 'Ajuda';

  @override
  String get helpSubtitle => 'Ver a página do projeto';

  @override
  String get version => 'Versão';

  @override
  String get license => 'Licença';

  @override
  String get openSourceLicenses => 'Licenças de código aberto';

  @override
  String get aboutSubtitle => 'Versão e licenças';

  @override
  String get backupTitle => 'Cópia de segurança';

  @override
  String get backupExport => 'Exportar cópia';

  @override
  String get backupExportSubtitle =>
      'Guardar definições, nomes e aplicações ocultas e fixadas num ficheiro';

  @override
  String get backupRestore => 'Restaurar cópia';

  @override
  String get backupRestoreSubtitle => 'Substituir tudo por uma cópia guardada';

  @override
  String get backupAlsoInclude => 'Incluir também';

  @override
  String get backupRestoreConfirm =>
      'Isto substitui as definições, nomes e aplicações ocultas e fixadas atuais.';

  @override
  String get backupExportAction => 'Exportar';

  @override
  String get backupRestoreAction => 'Restaurar';

  @override
  String get backupSaved => 'Cópia guardada';

  @override
  String get backupRestored => 'Cópia restaurada';

  @override
  String get backupInvalid => 'Este ficheiro não é uma cópia do Last Launcher';

  @override
  String get backupTooNew =>
      'Esta cópia é de uma versão mais recente do Last Launcher';

  @override
  String get backupFailed => 'Não foi possível ler ou escrever o ficheiro';

  @override
  String get hintSwipeUp => 'Desliza para cima para apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Desliza à direita para $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Desliza à esquerda para $module';
  }

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
  String get actionRemove => 'Remover';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionAppInfo => 'Informações da aplicação';

  @override
  String get actionEnable => 'Ativar';

  @override
  String get renameDialogTitle => 'Renomear';

  @override
  String get renameDialogCancel => 'Cancelar';

  @override
  String get renameDialogSave => 'Guardar';

  @override
  String get showWorkAppDot => 'Ponto do perfil de trabalho';

  @override
  String get showWorkAppDotSubtitle =>
      'Mostrar um pequeno ponto antes dos apps do perfil de trabalho';

  @override
  String get showWorkAppDotOnHome => 'Mostrar ponto no ecrã inicial';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Mostrar ponto do perfil de trabalho nas apps fixadas do ecrã inicial';

  @override
  String get hidePersonalWhenWorkActive => 'Não mostrar apps pessoais';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'As apps pessoais reaparecem quando o perfil de trabalho é pausado';

  @override
  String get homeScreenFull => 'O ecrã inicial está cheio';
}
