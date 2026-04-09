import 'package:flutter/services.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppChannel {
  const AppChannel();

  static const _channel = MethodChannel('nl.bw20.last_launcher/apps');

  Future<List<AppInfo>> getInstalledApps() async {
    final result = await _channel.invokeListMethod<Map>('getInstalledApps');
    if (result == null) return [];

    return result.map((map) {
      return AppInfo(
        packageName: map['packageName'] as String,
        label: map['label'] as String,
      );
    }).toList();
  }

  Future<void> expandQuickSettings() async {
    await _channel.invokeMethod<void>('expandQuickSettings');
  }

  Future<void> launchApp(String packageName) async {
    await _channel.invokeMethod<void>('launchApp', {
      'packageName': packageName,
    });
  }
}
