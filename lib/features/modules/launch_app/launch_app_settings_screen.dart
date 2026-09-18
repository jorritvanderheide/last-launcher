import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/modules/launch_app_module.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

/// Picks the app each side opens. A side's row only applies, and is only
/// enabled, while Launch app is the module on that side; its choice is kept
/// either way.
class LaunchAppSettingsScreen extends StatelessWidget {
  const LaunchAppSettingsScreen({required this.deps, super.key});

  final ModuleDeps deps;

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: AppLocalizations.of(context)!.panelLaunchApp,
      listenable: Listenable.merge([deps.settingsState, deps.appListState]),
      children: (context) => [
        for (final side in ModuleSide.values) _SideTile(side: side, deps: deps),
      ],
    );
  }
}

class _SideTile extends StatelessWidget {
  const _SideTile({required this.side, required this.deps});

  final ModuleSide side;
  final ModuleDeps deps;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final left = side == ModuleSide.left;
    final onThisSide =
        deps.settingsState.panel(side).value.id == LaunchAppModule.moduleId;
    final app = LaunchAppModule.appFor(side, deps);
    final setting = deps.settingsState.launchApp(side);

    return ListTile(
      leading: Icon(left ? Icons.west : Icons.east),
      title: Text(left ? l10n.launchAppLeft : l10n.launchAppRight),
      subtitle: Text(
        !onThisSide
            ? (left ? l10n.launchAppOnlyLeft : l10n.launchAppOnlyRight)
            : app == null
            ? l10n.launchAppChoose
            : deps.appListState.displayLabel(app),
      ),
      enabled: onThisSide,
      onTap: onThisSide
          ? () async {
              final picked = await showDialog<_Picked>(
                context: context,
                builder: (context) => _AppPicker(
                  title: left ? l10n.launchAppLeft : l10n.launchAppRight,
                  apps: deps.appListState,
                  currentKey: setting.value,
                ),
              );
              if (picked != null) setting.value = picked.key;
            }
          : null,
    );
  }
}

/// What the picker returns: an entry's key, or null for none. Wrapped so
/// that choosing none is distinguishable from cancelling.
class _Picked {
  const _Picked(this.key);

  final String? key;
}

/// Every drawer entry, hidden ones and shortcuts included, with a search
/// field, and None at the top.
class _AppPicker extends StatefulWidget {
  const _AppPicker({
    required this.title,
    required this.apps,
    required this.currentKey,
  });

  final String title;
  final AppListState apps;
  final String? currentKey;

  @override
  State<_AppPicker> createState() => _AppPickerState();
}

class _AppPickerState extends State<_AppPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = widget.apps.search(_query, includeHidden: true);
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.launchAppSearch,
                  isDense: true,
                ),
                onChanged: (query) => setState(() => _query = query),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (_query.isEmpty)
                    ListTile(
                      title: Text(l10n.panelNone),
                      selected: widget.currentKey == null,
                      onTap: () => Navigator.pop(context, const _Picked(null)),
                    ),
                  for (final app in entries)
                    ListTile(
                      title: Text(widget.apps.displayLabel(app)),
                      trailing: app.isWorkApp || app.isShortcut
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (app.isShortcut)
                                  const Icon(Icons.link, size: 18),
                                if (app.isWorkApp)
                                  const Icon(Icons.work_outline, size: 18),
                              ],
                            )
                          : null,
                      selected: app.key == widget.currentKey,
                      onTap: () => Navigator.pop(context, _Picked(app.key)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
