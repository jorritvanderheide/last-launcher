import 'package:flutter/widgets.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

/// How a prefix is named where the user sees it: its own name, or when that
/// was left empty, what it does.
String prefixName(
  BuildContext context,
  SearchPrefix prefix,
  AppListState apps,
) {
  if (prefix.name.isNotEmpty) return prefix.name;
  final l10n = AppLocalizations.of(context)!;
  return switch (prefix.action) {
    FilterApps(:final work) =>
      work ? l10n.prefixTypeWork : l10n.prefixTypePersonal,
    OpenLink(:final template) => _linkName(template),
    SearchInApp(:final package) => apps.labelForPackage(package) ?? package,
  };
}

/// A link's site ("duckduckgo.com"), or the template itself for links
/// without one, like geo:.
String _linkName(String template) {
  final host =
      Uri.tryParse(template.replaceAll(OpenLink.placeholder, 'x'))?.host ?? '';
  if (host.isEmpty) return template;
  return host.startsWith('www.') ? host.substring(4) : host;
}

/// A trigger as shown in lists, with spaces made visible: "g " reads "g␣".
String visibleTrigger(String trigger) => trigger.replaceAll(' ', '␣');
