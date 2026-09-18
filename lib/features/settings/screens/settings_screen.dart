import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/modules/launcher_module.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/features/settings/screens/about_screen.dart';
import 'package:last_launcher/features/settings/screens/appearance_settings_screen.dart';
import 'package:last_launcher/features/settings/screens/backup_settings_screen.dart';
import 'package:last_launcher/features/settings/screens/drawer_settings_screen.dart';
import 'package:last_launcher/features/settings/screens/home_settings_screen.dart';
import 'package:last_launcher/features/settings/screens/work_settings_screen.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _store = String.fromEnvironment('STORE', defaultValue: 'playstore');

/// The settings root: one row per category, each summarising what's set
/// inside it, then support and about.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.settingsState,
    required this.appListState,
    required this.homeState,
    required this.appChannel,
    required this.onRestored,
    super.key,
  });

  final SettingsState settingsState;
  final AppListState appListState;
  final HomeState homeState;
  final AppChannel appChannel;

  /// Re-reads every state after a backup was restored.
  final VoidCallback onRestored;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _isDefaultLauncher = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshDefault();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDefault();
  }

  Future<void> _refreshDefault() async {
    final value = await widget.appChannel.isDefaultLauncher();
    if (mounted) setState(() => _isDefaultLauncher = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = widget.settingsState;

    return SettingsPage(
      title: l10n.settings,
      listenable: Listenable.merge([s, widget.appListState, widget.homeState]),
      children: (context) => [
        if (!_isDefaultLauncher)
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            leading: const Icon(Icons.home_outlined),
            title: Text(l10n.setAsDefault),
            subtitle: Text(l10n.setAsDefaultSubtitle),
            onTap: widget.appChannel.requestDefaultLauncher,
          ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.sectionAppearance),
          subtitle: Text(appearanceSummary(context, s)),
          onTap: () => pushSettingsPage(
            context,
            AppearanceSettingsScreen(settingsState: s),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.grid_view_outlined),
          title: Text(l10n.sectionHome),
          onTap: () =>
              pushSettingsPage(context, HomeSettingsScreen(settingsState: s)),
        ),
        // The modules chosen on Home, right under it; one row per module,
        // even when it sits on both sides.
        for (final module in {
          for (final m in [s.leftPanel.value, s.rightPanel.value]) m.id: m,
        }.values)
          if (module.settingsPage(
                ModuleDeps(settingsState: s, appListState: widget.appListState),
              )
              case final page?)
            ListTile(
              leading: const Icon(Icons.view_sidebar_outlined),
              title: Text(module.displayName(context)),
              onTap: () => pushSettingsPage(context, page),
            ),
        ListTile(
          leading: const Icon(Icons.search),
          title: Text(l10n.sectionAppDrawer),
          subtitle: Text(
            hiddenAppSummary(
              context,
              hiddenAppCount(widget.appListState, widget.homeState, s),
            ),
          ),
          onTap: () => pushSettingsPage(
            context,
            DrawerSettingsScreen(
              settingsState: s,
              appListState: widget.appListState,
              homeState: widget.homeState,
              appChannel: widget.appChannel,
            ),
          ),
        ),
        if (widget.appListState.hasWorkProfile)
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(l10n.sectionWork),
            onTap: () =>
                pushSettingsPage(context, WorkSettingsScreen(settingsState: s)),
          ),
        ListTile(
          leading: const Icon(Icons.settings_backup_restore),
          title: Text(l10n.backupTitle),
          onTap: () => pushSettingsPage(
            context,
            BackupSettingsScreen(
              appChannel: widget.appChannel,
              onRestored: widget.onRestored,
            ),
          ),
        ),
        SettingsSectionHeader(title: l10n.sectionSupport),
        if (_store == 'playstore')
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(l10n.rateApp),
            subtitle: Text(l10n.rateAppSubtitle),
            onTap: () => launchUrl(
              Uri.parse(
                'https://play.google.com/store/apps/details?id=nl.bw20.last_launcher',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
        if (_store == 'fdroid')
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.donate),
            subtitle: Text(l10n.donateSubtitle),
            onTap: () => launchUrl(
              Uri.parse('https://liberapay.com/BW20'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(l10n.sendFeedback),
          subtitle: Text(l10n.sendFeedbackSubtitle),
          onTap: _launchFeedback,
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l10n.help),
          subtitle: Text(l10n.helpSubtitle),
          onTap: () => launchUrl(
            Uri.parse('https://codeberg.org/BW20/last-launcher'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        SettingsSectionHeader(title: l10n.sectionAbout),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.sectionAbout),
          subtitle: Text(l10n.aboutSubtitle),
          onTap: () => pushSettingsPage(context, const AboutScreen()),
        ),
      ],
    );
  }

  Future<void> _launchFeedback() async {
    final info = await PackageInfo.fromPlatform();
    final subject = Uri.encodeComponent(
      'Last Launcher feedback (v${info.version})',
    );
    await launchUrl(
      Uri.parse('mailto:jorrit@bw20.nl?subject=$subject'),
      mode: LaunchMode.externalApplication,
    );
  }
}
