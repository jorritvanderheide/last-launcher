import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/prefix_names.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/features/settings/screens/prefix_editor_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

/// Every search prefix, each switchable, with ways to add one and to bring
/// back the work and personal ones.
class PrefixesSettingsScreen extends StatelessWidget {
  const PrefixesSettingsScreen({
    required this.settingsState,
    required this.appListState,
    required this.appChannel,
    super.key,
  });

  final SettingsState settingsState;
  final AppListState appListState;
  final AppChannel appChannel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final setting = settingsState.searchPrefixes;

    return SettingsPage(
      title: l10n.searchPrefixes,
      listenable: Listenable.merge([setting, appListState]),
      children: (context) {
        final prefixes = setting.value;
        // Profile filters are a work-profile feature: without one they're
        // left out entirely (and kept, for if one is added). With one but
        // personal apps hidden, they can't apply, so they show as off.
        final hasWorkProfile = appListState.hasWorkProfile;
        final filtersApply = appListState.profilePrefixEnabled;
        final missingDefaults = hasWorkProfile
            ? defaultPrefixes.where(
                (d) => !prefixes.any((p) => _sameAction(p.action, d.action)),
              )
            : const <SearchPrefix>[];
        return [
          for (final (index, prefix) in prefixes.indexed)
            if (prefix.action is! FilterApps || hasWorkProfile)
              _PrefixRow(
                prefix: prefix,
                name: prefixName(context, prefix, appListState),
                summary: _summary(context, prefix),
                forcedOff: prefix.action is FilterApps && !filtersApply,
                onEnabled: (enabled) => setting.value = [
                  for (final (i, p) in prefixes.indexed)
                    i == index ? p.copyWith(enabled: enabled) : p,
                ],
                onTap: () => _edit(context, index),
              ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l10n.prefixAdd),
            onTap: () => _edit(context, null),
          ),
          if (missingDefaults.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.restore),
              title: Text(l10n.prefixRestoreDefaults),
              onTap: () => setting.value = [...prefixes, ...missingDefaults],
            ),
        ];
      },
    );
  }

  String _summary(BuildContext context, SearchPrefix prefix) {
    final l10n = AppLocalizations.of(context)!;
    return switch (prefix.action) {
      FilterApps(:final work) =>
        work ? l10n.prefixTypeWork : l10n.prefixTypePersonal,
      OpenLink(:final template) => template,
      SearchInApp() => l10n.prefixTypeSearchInApp,
    };
  }

  void _edit(BuildContext context, int? index) => pushSettingsPage(
    context,
    PrefixEditorScreen(
      settingsState: settingsState,
      appListState: appListState,
      appChannel: appChannel,
      index: index,
    ),
  );
}

/// One prefix: its trigger, name and what it does, with a switch. A
/// [forcedOff] prefix can't apply right now: it shows as off and dimmed, and
/// its own setting is kept.
class _PrefixRow extends StatelessWidget {
  const _PrefixRow({
    required this.prefix,
    required this.name,
    required this.summary,
    required this.forcedOff,
    required this.onEnabled,
    required this.onTap,
  });

  final SearchPrefix prefix;
  final String name;
  final String summary;
  final bool forcedOff;
  final ValueChanged<bool> onEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: !forcedOff,
      leading: SizedBox(
        width: 40,
        child: Text(visibleTrigger(prefix.trigger), style: triggerStyle),
      ),
      title: Text(name),
      subtitle: Text(summary),
      trailing: Switch(
        value: prefix.enabled && !forcedOff,
        onChanged: forcedOff ? null : onEnabled,
      ),
      onTap: onTap,
    );
  }
}

bool _sameAction(PrefixAction a, PrefixAction b) => switch ((a, b)) {
  (FilterApps(work: final x), FilterApps(work: final y)) => x == y,
  _ => false,
};
