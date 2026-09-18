import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/prefix_names.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _mono = TextStyle(fontFamily: 'JetBrainsMono');

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
        child: Text(visibleTrigger(prefix.trigger), style: _mono),
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

/// Starting points for a link prefix.
List<({String name, String template})> _linkTemplates(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final language = Localizations.localeOf(context).languageCode;
  return [
    (name: 'DuckDuckGo', template: 'https://duckduckgo.com/?q=%s'),
    (name: 'Google', template: 'https://www.google.com/search?q=%s'),
    (
      name: 'Wikipedia',
      template: 'https://$language.wikipedia.org/w/index.php?search=%s',
    ),
    (
      name: 'YouTube',
      template: 'https://www.youtube.com/results?search_query=%s',
    ),
    (name: l10n.prefixTemplateMaps, template: 'geo:0,0?q=%s'),
    (name: 'Play Store', template: 'market://search?q=%s'),
  ];
}

enum _Kind { link, appSearch, work, personal }

/// Adds a prefix ([index] null) or edits the one at [index], writing the
/// list back on save.
class PrefixEditorScreen extends StatefulWidget {
  const PrefixEditorScreen({
    required this.settingsState,
    required this.appListState,
    required this.appChannel,
    required this.index,
    super.key,
  });

  final SettingsState settingsState;
  final AppListState appListState;
  final AppChannel appChannel;
  final int? index;

  @override
  State<PrefixEditorScreen> createState() => _PrefixEditorScreenState();
}

class _PrefixEditorScreenState extends State<PrefixEditorScreen> {
  late final SearchPrefix? _original = widget.index == null
      ? null
      : widget.settingsState.searchPrefixes.value[widget.index!];

  late final _trigger = TextEditingController(text: _original?.trigger);
  late final _name = TextEditingController(text: _original?.name);
  late final _template = TextEditingController(
    text: switch (_original?.action) {
      OpenLink(:final template) => template,
      _ => '',
    },
  );
  late _Kind _kind = switch (_original?.action) {
    null || OpenLink() => _Kind.link,
    SearchInApp() => _Kind.appSearch,
    FilterApps(:final work) => work ? _Kind.work : _Kind.personal,
  };
  late String? _openWith = switch (_original?.action) {
    OpenLink(:final openWith) => openWith,
    _ => null,
  };
  late String? _appPackage = switch (_original?.action) {
    SearchInApp(:final package) => package,
    _ => null,
  };

  /// Errors only show once the user has tried to save.
  bool _triedSaving = false;

  @override
  void initState() {
    super.initState();
    _trigger.addListener(_rebuild);
    _template.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _trigger.dispose();
    _name.dispose();
    _template.dispose();
    super.dispose();
  }

  String? _triggerError(AppLocalizations l10n) {
    final trigger = _trigger.text;
    if (trigger.isEmpty) return l10n.prefixErrorEmpty;
    final prefixes = widget.settingsState.searchPrefixes.value;
    final taken = prefixes.indexed.any(
      (entry) =>
          entry.$1 != widget.index &&
          entry.$2.trigger.toLowerCase() == trigger.toLowerCase(),
    );
    return taken ? l10n.prefixErrorTaken : null;
  }

  String? _actionError(AppLocalizations l10n) => switch (_kind) {
    _Kind.link when !_template.text.contains(OpenLink.placeholder) =>
      l10n.prefixErrorNoPlaceholder,
    _Kind.appSearch when _appPackage == null => l10n.launchAppChoose,
    _ => null,
  };

  /// Letters alone, with no space after them, hide the apps they start.
  bool get _shadowsApps {
    final trigger = _trigger.text;
    return trigger.isNotEmpty &&
        RegExp(r'^[\p{L}\p{N}]+$', unicode: true).hasMatch(trigger);
  }

  PrefixAction get _action => switch (_kind) {
    _Kind.link => OpenLink(_template.text.trim(), openWith: _openWith),
    _Kind.appSearch => SearchInApp(_appPackage!),
    _Kind.work => const FilterApps(work: true),
    _Kind.personal => const FilterApps(work: false),
  };

  void _save(AppLocalizations l10n) {
    if (_triggerError(l10n) != null || _actionError(l10n) != null) {
      setState(() => _triedSaving = true);
      return;
    }
    final prefix = SearchPrefix(
      trigger: _trigger.text,
      name: _name.text.trim(),
      action: _action,
      enabled: _original?.enabled ?? true,
    );
    final setting = widget.settingsState.searchPrefixes;
    setting.value = widget.index == null
        ? [...setting.value, prefix]
        : [
            for (final (i, p) in setting.value.indexed)
              i == widget.index ? prefix : p,
          ];
    Navigator.pop(context);
  }

  void _delete() {
    final setting = widget.settingsState.searchPrefixes;
    setting.value = [
      for (final (i, p) in setting.value.indexed)
        if (i != widget.index) p,
    ];
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final original = _original;
    final triggerError = _triedSaving ? _triggerError(l10n) : null;
    final actionError = _triedSaving ? _actionError(l10n) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          original == null
              ? l10n.prefixAdd
              : prefixName(context, original, widget.appListState),
        ),
        actions: [
          if (original != null)
            IconButton(
              tooltip: l10n.actionRemove,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(
            onPressed: () => _save(l10n),
            child: Text(l10n.renameDialogSave),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _field(
            TextField(
              controller: _trigger,
              style: _mono,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.prefixTrigger,
                errorText: triggerError,
                helperText: _trigger.text.isEmpty
                    ? null
                    : l10n.prefixTriggerShownAs(visibleTrigger(_trigger.text)),
              ),
            ),
          ),
          if (_shadowsApps)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                l10n.prefixShadowWarning,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          _field(
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.prefixName),
            ),
          ),
          ChoiceTile<_Kind>(
            title: l10n.prefixType,
            value: _kind,
            options: [
              _Kind.link,
              _Kind.appSearch,
              if (widget.appListState.hasWorkProfile) ...[
                _Kind.work,
                _Kind.personal,
              ],
            ],
            label: (context, kind) => switch (kind) {
              _Kind.link => l10n.prefixTypeLink,
              _Kind.appSearch => l10n.prefixTypeSearchInApp,
              _Kind.work => l10n.prefixTypeWork,
              _Kind.personal => l10n.prefixTypePersonal,
            },
            onChanged: (kind) => setState(() => _kind = kind),
          ),
          if (_kind == _Kind.link) ...[
            ListTile(
              title: Text(l10n.prefixTemplates),
              trailing: const Icon(Icons.expand_more),
              onTap: _pickTemplate,
            ),
            _field(
              TextField(
                controller: _template,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: l10n.prefixLink,
                  helperText: l10n.prefixLinkHelp,
                  errorText: actionError,
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.prefixOpenWith),
              subtitle: Text(
                _openWith == null
                    ? l10n.prefixAnyApp
                    : widget.appListState.labelForPackage(_openWith!) ??
                          _openWith!,
              ),
              enabled: _template.text.contains(OpenLink.placeholder),
              onTap: _pickOpenWith,
            ),
          ],
          if (_kind == _Kind.appSearch)
            ListTile(
              title: Text(l10n.prefixApp),
              subtitle: Text(
                actionError ??
                    (_appPackage == null
                        ? l10n.launchAppChoose
                        : widget.appListState.labelForPackage(_appPackage!) ??
                              _appPackage!),
                style: actionError == null
                    ? null
                    : TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: _pickSearchApp,
            ),
          if ((_kind == _Kind.link || _kind == _Kind.appSearch) &&
              widget.appListState.hasWorkProfile)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                l10n.prefixPersonalAppsOnly,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _field(Widget child) =>
      Padding(padding: const EdgeInsets.fromLTRB(24, 0, 24, 16), child: child);

  Future<void> _pickTemplate() async {
    final templates = _linkTemplates(context);
    final picked = await showDialog<({String name, String template})>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppLocalizations.of(context)!.prefixTemplates),
        children: [
          for (final template in templates)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, template),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(template.name),
                subtitle: Text(template.template),
              ),
            ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() {
      _template.text = picked.template;
      if (_name.text.trim().isEmpty) _name.text = picked.name;
      _openWith = null;
    });
  }

  Future<void> _pickOpenWith() async {
    final sample = OpenLink(_template.text.trim()).linkFor('test');
    final apps = await widget.appChannel.appsForLink(sample);
    if (!mounted) return;
    final picked = await _pickApp(
      AppLocalizations.of(context)!.prefixOpenWith,
      apps,
      allowAny: true,
    );
    if (picked != null) setState(() => _openWith = picked.package);
  }

  Future<void> _pickSearchApp() async {
    final apps = await widget.appChannel.appsWithSearch();
    if (!mounted) return;
    final picked = await _pickApp(
      AppLocalizations.of(context)!.prefixApp,
      apps,
      allowAny: false,
    );
    if (picked != null) setState(() => _appPackage = picked.package);
  }

  /// A list of [apps] to choose from, with "Any app" first when [allowAny].
  /// Returns the choice (a null package for any app), or null on cancel.
  Future<({String? package})?> _pickApp(
    String title,
    List<AppChoice> apps, {
    required bool allowAny,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<({String? package})>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          if (allowAny)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, (package: null)),
              child: Text(l10n.prefixAnyApp),
            ),
          if (apps.isEmpty && !allowAny)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(l10n.prefixNoSearchApps),
            ),
          for (final app in apps)
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, (package: app.packageName)),
              child: Text(app.label),
            ),
        ],
      ),
    );
  }
}
