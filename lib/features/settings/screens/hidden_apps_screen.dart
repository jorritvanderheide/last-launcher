import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_options_dialog.dart';
import 'package:last_launcher/features/home/home_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';

class HiddenAppsScreen extends StatelessWidget {
  const HiddenAppsScreen({
    required this.appListState,
    required this.homeState,
    required this.appChannel,
    super.key,
  });

  final AppListState appListState;
  final HomeState homeState;
  final AppChannel appChannel;

  void _onLongPress(BuildContext context, AppInfo app) {
    showAppOptionsDialog(
      context: context,
      app: app,
      appListState: appListState,
      homeState: homeState,
      isHiddenContext: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden apps'),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: appListState,
          builder: (context, _) {
            final apps = appListState.hiddenApps;
            if (apps.isEmpty) {
              return Center(
                child: Text(
                  'No hidden apps',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              );
            }
            return FadeOverflow(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return AppLabel(
                    label: appListState.displayLabel(app),
                    onTap: () => appChannel.launchApp(app.packageName),
                    onLongPress: () => _onLongPress(context, app),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
