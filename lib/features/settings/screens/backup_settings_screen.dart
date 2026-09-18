import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/settings/backup.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupSettingsScreen extends StatelessWidget {
  const BackupSettingsScreen({
    required this.appChannel,
    required this.onRestored,
    super.key,
  });

  final AppChannel appChannel;

  /// Called once a restore has replaced what's stored, so every state can
  /// re-read it.
  final VoidCallback onRestored;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingsPage(
      title: l10n.backupTitle,
      children: (context) => [
        ListTile(
          leading: const Icon(Icons.upload_outlined),
          title: Text(l10n.backupExport),
          subtitle: Text(l10n.backupExportSubtitle),
          onTap: () => _export(context),
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: Text(l10n.backupRestore),
          subtitle: Text(l10n.backupRestoreSubtitle),
          onTap: () => _restore(context),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    // Module data is in unless the user leaves it out.
    var include = <String>{};
    final withData = Backup.modulesWithData(prefs, launcherModules);
    if (withData.isNotEmpty) {
      if (!context.mounted) return;
      final chosen = await showDialog<Set<String>>(
        context: context,
        builder: (context) => _BackupDialog(
          title: l10n.backupExport,
          modules: withData,
          confirmLabel: l10n.backupExportAction,
        ),
      );
      if (chosen == null) return;
      include = chosen;
    }

    final backup = Backup.capture(
      prefs,
      modules: launcherModules,
      includeModules: include,
    );
    try {
      final saved = await appChannel.saveBackup(_fileName(), backup.encode());
      if (saved && context.mounted) _say(context, l10n.backupSaved);
    } on PlatformException {
      if (context.mounted) _say(context, l10n.backupFailed);
    }
  }

  Future<void> _restore(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final String? text;
    try {
      text = await appChannel.openBackup();
    } on PlatformException {
      if (context.mounted) _say(context, l10n.backupFailed);
      return;
    }
    if (text == null || !context.mounted) return;

    final Backup backup;
    try {
      backup = Backup.decode(text);
    } on BackupTooNewException {
      _say(context, l10n.backupTooNew);
      return;
    } on FormatException {
      _say(context, l10n.backupInvalid);
      return;
    }

    final chosen = await showDialog<Set<String>>(
      context: context,
      builder: (context) => _BackupDialog(
        title: l10n.backupRestore,
        message: l10n.backupRestoreConfirm,
        modules: [
          for (final module in launcherModules)
            if (backup.modules.contains(module.id)) module,
        ],
        confirmLabel: l10n.backupRestoreAction,
      ),
    );
    if (chosen == null) return;

    await backup.restore(
      await SharedPreferences.getInstance(),
      modules: launcherModules,
      restoreModules: chosen,
    );
    onRestored();
    if (context.mounted) _say(context, l10n.backupRestored);
  }

  static String _fileName() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'last-launcher-${now.year}-${two(now.month)}-${two(now.day)}.json';
  }

  static void _say(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Confirms an export or restore, with a checkbox per module whose data can
/// be left out. Pops the ids of the modules to include, or null on cancel.
class _BackupDialog extends StatefulWidget {
  const _BackupDialog({
    required this.title,
    required this.modules,
    required this.confirmLabel,
    this.message,
  });

  final String title;
  final String? message;
  final List<LauncherModule> modules;
  final String confirmLabel;

  @override
  State<_BackupDialog> createState() => _BackupDialogState();
}

class _BackupDialogState extends State<_BackupDialog> {
  late final Set<String> _included = {
    for (final module in widget.modules) module.id,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message case final message?)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(message),
            ),
          if (widget.modules.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text(
                l10n.backupAlsoInclude,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            for (final module in widget.modules)
              CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(module.displayName(context)),
                value: _included.contains(module.id),
                onChanged: (on) => setState(
                  () => on == true
                      ? _included.add(module.id)
                      : _included.remove(module.id),
                ),
              ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.renameDialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, Set.of(_included)),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
