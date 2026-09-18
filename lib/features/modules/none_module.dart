import 'package:flutter/widgets.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

/// Empty panel: nothing on this side of home.
class NoneModule extends LauncherModule {
  const NoneModule();

  @override
  String get id => 'none';

  @override
  String displayName(BuildContext context) =>
      AppLocalizations.of(context)!.panelNone;

  @override
  String hintName(BuildContext context, ModuleSide side, ModuleDeps deps) =>
      AppLocalizations.of(context)!.panelNone;

  @override
  Widget build(BuildContext context, LauncherModuleProps props) =>
      const SizedBox.shrink();
}
