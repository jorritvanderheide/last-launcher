import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppChannel {
  const AppChannel();

  static const _channel = MethodChannel('nl.bw20.last_launcher/apps');

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeListMethod<Map>('getInstalledApps');
      if (result == null) return [];

      return result.map((map) {
        return AppInfo(
          packageName: map['packageName'] as String,
          label: map['label'] as String,
        );
      }).toList();
    } on PlatformException catch (e) {
      debugPrint('Failed to get installed apps: $e');
      return [];
    }
  }

  Future<void> expandQuickSettings() async {
    try {
      await _channel.invokeMethod<void>('expandQuickSettings');
    } on PlatformException catch (e) {
      debugPrint('Failed to expand quick settings: $e');
    }
  }

  Future<void> launchApp(String packageName) async {
    try {
      await _channel.invokeMethod<void>('launchApp', {
        'packageName': packageName,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to launch $packageName: $e');
    }
  }
}
