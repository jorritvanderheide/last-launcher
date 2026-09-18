import 'package:flutter/material.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

class HomeSettingsScreen extends StatelessWidget {
  const HomeSettingsScreen({required this.settingsState, super.key});

  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = settingsState;

    return SettingsPage(
      title: l10n.sectionHome,
      listenable: s,
      children: (context) => [
        SettingSwitch(
          setting: s.locked,
          title: l10n.lockLayout,
          subtitle: l10n.lockLayoutSubtitle,
        ),
        SettingSwitch(
          setting: s.doubleTapToSleep,
          title: l10n.doubleTapToSleep,
          subtitle: l10n.doubleTapToSleepSubtitle,
        ),
        _PanelTile(
          title: l10n.leftOfHome,
          current: s.leftPanel.value,
          onChanged: s.setLeftPanel,
        ),
        _PanelTile(
          title: l10n.rightOfHome,
          current: s.rightPanel.value,
          onChanged: s.setRightPanel,
        ),
      ],
    );
  }
}

/// Picks by id: modules are identified by their id, not by instance.
class _PanelTile extends StatelessWidget {
  const _PanelTile({
    required this.title,
    required this.current,
    required this.onChanged,
  });

  final String title;
  final LauncherModule current;
  final ValueChanged<LauncherModule> onChanged;

  @override
  Widget build(BuildContext context) {
    return ChoiceTile<String>(
      title: title,
      value: current.id,
      options: [for (final module in launcherModules) module.id],
      label: (context, id) => moduleById(id).displayName(context),
      onChanged: (id) => onChanged(moduleById(id)),
    );
  }
}
