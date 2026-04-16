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
  String get sectionApps => 'Aplicaciones';

  @override
  String get sectionBehavior => 'Comportamiento';

  @override
  String get sectionTasks => 'Tareas';

  @override
  String get sectionSupport => 'Apoyo';

  @override
  String get sectionAbout => 'Acerca de';

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
  String get hideStatusBar => 'Pantalla completa';

  @override
  String get hideStatusBarSubtitle => 'Ocultar barra de estado y navegación';

  @override
  String get homeScreenHints => 'Consejos de pantalla de inicio';

  @override
  String get homeScreenHintsSubtitle =>
      'Mostrar consejos cuando la pantalla de inicio está vacía';

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
  String get taskScreen => 'Pantalla de tareas';

  @override
  String get taskScreenSubtitle =>
      'Deslizar a la derecha desde el inicio para ver tareas';

  @override
  String get removeOnComplete => 'Eliminar al completar';

  @override
  String get removeOnCompleteSubtitle =>
      'Eliminar tareas cuando se marcan como hechas';

  @override
  String get donate => 'Donar';

  @override
  String get donateSubtitle => 'Apoya el desarrollo de Last Launcher';

  @override
  String get version => 'Versión';

  @override
  String get license => 'Licencia';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get hintSwipeUp => 'Deslizar hacia arriba para buscar';

  @override
  String get hintSwipeRight => 'Deslizar a la derecha para tareas';

  @override
  String get hintLongPress => 'Mantener pulsado para ajustes';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get returnToAddTask => 'Escribe para añadir tarea';

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
  String get actionDone => 'Hecho';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionRemove => 'Eliminar';

  @override
  String get renameDialogTitle => 'Renombrar';

  @override
  String get renameDialogCancel => 'Cancelar';

  @override
  String get renameDialogSave => 'Guardar';

  @override
  String get homeScreenFull => 'La pantalla de inicio está llena';
}
