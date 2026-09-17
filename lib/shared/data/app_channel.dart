import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/shared/data/models.dart';

class AppChannel {
  AppChannel();

  static const _channel = MethodChannel('nl.bw20.last_launcher/apps');

  VoidCallback? onOpenSettings;
  VoidCallback? onGoHome;

  void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openSettings') {
        onOpenSettings?.call();
      } else if (call.method == 'goHome') {
        onGoHome?.call();
      }
      return null;
    });
  }

  Future<bool> consumePendingOpenSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'consumePendingOpenSettings',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to consume pending open settings: $e');
      return false;
    }
  }

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeListMethod<Map>('getInstalledApps');
      if (result == null) return [];

      return result.map((map) {
        return AppInfo(
          packageName: map['packageName'] as String,
          label: map['label'] as String,
          isWorkApp: map['isWorkApp'] as bool? ?? false,
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

  Future<void> launchApp(String packageName, {bool isWorkApp = false}) async {
    try {
      await _channel.invokeMethod<void>('launchApp', {
        'packageName': packageName,
        'isWorkApp': isWorkApp,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to launch $packageName: $e');
    }
  }

  Future<void> openAppInfo(String packageName) async {
    try {
      await _channel.invokeMethod<void>('openAppInfo', {
        'packageName': packageName,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to open app info for $packageName: $e');
    }
  }

  Future<bool> lockScreen() async {
    try {
      final result = await _channel.invokeMethod<bool>('lockScreen');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to lock screen: $e');
      return false;
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod<void>('openAccessibilitySettings');
    } on PlatformException catch (e) {
      debugPrint('Failed to open accessibility settings: $e');
    }
  }

  Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isAccessibilityServiceEnabled',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check accessibility service: $e');
      return false;
    }
  }

  Future<void> setFullscreen(bool enabled) async {
    try {
      await _channel.invokeMethod<void>('setFullscreen', {'enabled': enabled});
    } on PlatformException catch (e) {
      debugPrint('Failed to toggle fullscreen: $e');
    }
  }

  Future<bool> hasWorkProfile() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasWorkProfile');
      return result ?? false;
    } catch (e) {
      debugPrint('Failed to check work profile: $e');
      return false;
    }
  }

  Future<bool> isDefaultLauncher() async {
    try {
      final result = await _channel.invokeMethod<bool>('isDefaultLauncher');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check default launcher status: $e');
      return false;
    }
  }

  Future<void> requestDefaultLauncher() async {
    try {
      await _channel.invokeMethod<void>('requestDefaultLauncher');
    } on PlatformException catch (e) {
      debugPrint('Failed to request default launcher: $e');
    }
  }
}
