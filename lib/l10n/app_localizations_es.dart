// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'El último lanzador que necesitarás';

  @override
  String get settings => 'Ajustes';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionHome => 'Inicio';

  @override
  String get sectionAppDrawer => 'Cajón de aplicaciones';

  @override
  String get sectionTasks => 'Tareas';

  @override
  String get sectionModules => 'Módulos';

  @override
  String get sectionSupport => 'Apoyo';

  @override
  String get sectionAbout => 'Acerca de';

  @override
  String get sectionSearch => 'Búsqueda';

  @override
  String get sectionWork => 'Perfil de trabajo';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => 'Estilo';

  @override
  String get themeStyleStandard => 'Estándar';

  @override
  String get themeStyleCustom => 'Personalizado';

  @override
  String get fontTitle => 'Fuente';

  @override
  String get fontStandard => 'Estándar';

  @override
  String get fontMono => 'Monoespaciada';

  @override
  String get textSizeTitle => 'Tamaño del texto';

  @override
  String get textSizeSmall => 'Pequeño';

  @override
  String get textSizeMedium => 'Mediano';

  @override
  String get textSizeLarge => 'Grande';

  @override
  String get textAlignTitle => 'Alineación del texto';

  @override
  String get alignLeft => 'Izquierda';

  @override
  String get alignCenter => 'Centro';

  @override
  String get alignRight => 'Derecha';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get accentColorSubtitle =>
      'Teñir el texto y el fondo con el color de acento del sistema';

  @override
  String get terminalPrompt => 'Línea de comandos';

  @override
  String get terminalPromptSubtitle =>
      'Mostrar la búsqueda como línea de comandos';

  @override
  String get sectionEffects => 'Efectos';

  @override
  String get effectsDarkOnly => 'Solo en modo oscuro';

  @override
  String get glow => 'Brillo';

  @override
  String get scanlines => 'Líneas de escaneo';

  @override
  String get scanlinesOff => 'Desactivadas';

  @override
  String get scanlinesLight => 'Suaves';

  @override
  String get scanlinesMedium => 'Medias';

  @override
  String get scanlinesStrong => 'Intensas';

  @override
  String get animations => 'Animaciones';

  @override
  String get animationsSubtitle =>
      'Líneas en movimiento, fallos visuales y cursor parpadeante';

  @override
  String get hideStatusBar => 'Pantalla completa';

  @override
  String get hideStatusBarSubtitle => 'Ocultar barra de estado y navegación';

  @override
  String get showHints => 'Mostrar consejos';

  @override
  String get showHintsSubtitle =>
      'Mostrar consejos de uso en toda la aplicación';

  @override
  String get hidePinnedApps => 'Ocultar apps fijadas';

  @override
  String get hidePinnedAppsSubtitle =>
      'Ocultar apps fijadas del cajón de aplicaciones';

  @override
  String get includeHiddenInSearch => 'Incluir ocultas en búsqueda';

  @override
  String get includeHiddenInSearchSubtitle =>
      'Permite que la búsqueda encuentre apps ocultas';

  @override
  String get matchOriginalName => 'Coincidir nombre original';

  @override
  String get matchOriginalNameSubtitle =>
      'Encontrar apps renombradas por su nombre original';

  @override
  String get hiddenApps => 'Aplicaciones ocultas';

  @override
  String get hiddenAppsNone => 'Ninguna';

  @override
  String hiddenAppsCount(int count) {
    return '$count ocultas';
  }

  @override
  String get noHiddenApps => 'No hay aplicaciones ocultas';

  @override
  String get leftOfHome => 'Módulo izquierdo';

  @override
  String get rightOfHome => 'Módulo derecho';

  @override
  String get panelNone => 'Ninguno';

  @override
  String get lockLayout => 'Bloquear diseño';

  @override
  String get lockLayoutSubtitle =>
      'Desactivar fijar apps y la pulsación larga en la pantalla de inicio';

  @override
  String get doubleTapToSleep => 'Doble toque para suspender';

  @override
  String get doubleTapToSleepSubtitle =>
      'Requiere el servicio de accesibilidad activado en la configuración del sistema';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'Establecer como app de inicio';

  @override
  String get setAsDefaultSubtitle => 'Abrir el selector del sistema';

  @override
  String get drawerMode => 'Modo del cajón';

  @override
  String get drawerModeList => 'Lista';

  @override
  String get searchOnlyMode => 'Solo búsqueda';

  @override
  String get searchOnlyModeSubtitle =>
      'Ocultar nombres de apps, buscar para abrir';

  @override
  String get autoShowKeyboard => 'Mostrar teclado';

  @override
  String get autoShowKeyboardAppsSubtitle =>
      'Abrir teclado cuando se abre el cajón';

  @override
  String get autoShowKeyboardTasksSubtitle =>
      'Abrir teclado cuando se abren las tareas';

  @override
  String get autoLaunchOnMatch => 'Abrir automáticamente al coincidir';

  @override
  String get autoLaunchOnMatchSubtitle => 'Abrir cuando solo una app coincide';

  @override
  String get quickLaunchHints => 'Indicadores rápidos';

  @override
  String get quickLaunchHintsSubtitle =>
      'Resaltar los caracteres únicos más cortos para abrir';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'tareas';

  @override
  String get removeOnComplete => 'Eliminar al completar';

  @override
  String get removeOnCompleteSubtitle =>
      'Eliminar tareas cuando se marcan como hechas';

  @override
  String get clearCompletedDaily => 'Borrar completadas a diario';

  @override
  String get clearCompletedDailySubtitle =>
      'Eliminar las tareas completadas al final del día';

  @override
  String get donate => 'Donar';

  @override
  String get donateSubtitle => 'Apoya el desarrollo de Last Launcher';

  @override
  String get rateApp => 'Valorar Last Launcher';

  @override
  String get rateAppSubtitle => 'Deja una reseña en Play Store';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get sendFeedbackSubtitle => 'Enviar correo al desarrollador';

  @override
  String get help => 'Ayuda';

  @override
  String get helpSubtitle => 'Ver la página del proyecto';

  @override
  String get version => 'Versión';

  @override
  String get license => 'Licencia';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get aboutSubtitle => 'Versión y licencias';

  @override
  String get backupTitle => 'Copia de seguridad';

  @override
  String get backupExport => 'Exportar copia';

  @override
  String get backupExportSubtitle =>
      'Guardar ajustes, nombres y apps ocultas y fijadas en un archivo';

  @override
  String get backupRestore => 'Restaurar copia';

  @override
  String get backupRestoreSubtitle => 'Reemplazar todo con una copia guardada';

  @override
  String get backupAlsoInclude => 'Incluir también';

  @override
  String get backupRestoreConfirm =>
      'Esto reemplaza los ajustes, nombres y apps ocultas y fijadas actuales.';

  @override
  String get backupExportAction => 'Exportar';

  @override
  String get backupRestoreAction => 'Restaurar';

  @override
  String get backupSaved => 'Copia guardada';

  @override
  String get backupRestored => 'Copia restaurada';

  @override
  String get backupInvalid => 'Este archivo no es una copia de Last Launcher';

  @override
  String get backupTooNew =>
      'Esta copia es de una versión más reciente de Last Launcher';

  @override
  String get backupFailed => 'No se pudo leer ni escribir el archivo';

  @override
  String get hintSwipeUp => 'Desliza arriba para apps';

  @override
  String hintSwipeRightFor(String module) {
    return 'Desliza derecha para $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return 'Desliza izquierda para $module';
  }

  @override
  String get hintLongPress => 'Mantener pulsado para ajustes';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get emptyTaskList => 'Escribe para añadir una tarea';

  @override
  String get returnToAddTask => 'Pulsa Enter para añadir una tarea';

  @override
  String get actionRename => 'Renombrar';

  @override
  String get actionUnpin => 'Desanclar';

  @override
  String get actionPin => 'Anclar';

  @override
  String get actionPinFull => 'Lleno';

  @override
  String get actionHide => 'Ocultar';

  @override
  String get actionUnhide => 'Mostrar';

  @override
  String get actionRemove => 'Eliminar';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionAppInfo => 'Información de la app';

  @override
  String get actionEnable => 'Activar';

  @override
  String get renameDialogTitle => 'Renombrar';

  @override
  String get renameDialogCancel => 'Cancelar';

  @override
  String get renameDialogSave => 'Guardar';

  @override
  String get showWorkAppDot => 'Mostrar punto de perfil de trabajo';

  @override
  String get showWorkAppDotSubtitle =>
      'Mostrar un pequeño punto delante de las aplicaciones del perfil de trabajo';

  @override
  String get showWorkAppDotOnHome => 'Mostrar punto en la pantalla de inicio';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'Mostrar punto del perfil de trabajo en las apps fijadas de la pantalla de inicio';

  @override
  String get hidePersonalWhenWorkActive => 'No mostrar apps personales';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'Las apps personales reaparecen cuando se pausa el perfil de trabajo';

  @override
  String get homeScreenFull => 'La pantalla de inicio está llena';
}
