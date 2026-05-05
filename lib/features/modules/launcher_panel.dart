import 'package:flutter/widgets.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

enum LauncherPanel {
  none,
  tasks;

  static LauncherPanel parse(String? id) {
    return values.firstWhere(
      (e) => e.name == id,
      orElse: () => LauncherPanel.none,
    );
  }

  /// Title-case name shown in pickers and section headers.
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      LauncherPanel.none => l10n.panelNone,
      LauncherPanel.tasks => l10n.sectionTasks,
    };
  }

  /// In-sentence form used inside hint strings (lowercase in English,
  /// follows the language's grammar in others).
  String hintName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      LauncherPanel.none => l10n.panelNone,
      LauncherPanel.tasks => l10n.panelTasks,
    };
  }
}
