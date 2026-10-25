import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:last_launcher/features/modules/tasks/synced_tasks.dart';
import 'package:last_launcher/shared/data/models.dart';

/// An app offered in a picker: its package and its name.
typedef AppChoice = ({String packageName, String label});

/// The system accent (Material You) in the tones the launcher draws with. A
/// record, so two reads of the same accent compare equal.
typedef AccentColors = ({Color onDark, Color onLight, Color tint});

/// A tasks app the launcher can read lists from, and whether it may.
typedef TaskApp = ({String authority, String label, bool granted});

/// A list in a tasks app, with the account (the CalDAV server) it syncs to.
typedef TaskList = ({String id, String name, String? account});

/// What asking for a tasks app's permission came to: [blocked] when it was
/// denied for good, so Android doesn't ask any more.
enum TaskPermission { granted, denied, blocked }

/// The tasks app is gone, or the launcher may no longer use it.
class TasksUnavailable implements Exception {
  const TasksUnavailable(this.message);

  final String? message;

  @override
  String toString() => 'TasksUnavailable: $message';
}

class AppChannel {
  AppChannel();

  static const _channel = MethodChannel('nl.bw20.last_launcher/apps');

  VoidCallback? onOpenSettings;
  VoidCallback? onGoHome;

  /// The tasks in a watched tasks app changed, here or elsewhere.
  VoidCallback? onTasksChanged;

  int _awaitingResults = 0;

  /// True while another app (a file picker) is open on the launcher's behalf
  /// and will hand its answer back. Leaving for it isn't leaving the
  /// launcher, so the usual reset to home on pause must not happen.
  bool get awaitingResult => _awaitingResults > 0;

  Future<T> _awaitResult<T>(Future<T> Function() run) async {
    _awaitingResults++;
    try {
      return await run();
    } finally {
      _awaitingResults--;
    }
  }

  void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openSettings') {
        onOpenSettings?.call();
      } else if (call.method == 'goHome') {
        onGoHome?.call();
      } else if (call.method == 'tasksChanged') {
        onTasksChanged?.call();
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
          shortcutId: map['shortcutId'] as String?,
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

  /// Opens an app, or a pinned shortcut when [shortcutId] is given.
  Future<void> launchApp(
    String packageName, {
    bool isWorkApp = false,
    String? shortcutId,
  }) async {
    try {
      await _channel.invokeMethod<void>('launchApp', {
        'packageName': packageName,
        'isWorkApp': isWorkApp,
        'shortcutId': ?shortcutId,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to launch $packageName: $e');
    }
  }

  /// Opens [uri] like any link, in [package] if given. False when no app
  /// can open it.
  Future<bool> openLink(String uri, {String? package}) async {
    try {
      final opened = await _channel.invokeMethod<bool>('openLink', {
        'uri': uri,
        'package': ?package,
      });
      return opened ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to open $uri: $e');
      return false;
    }
  }

  /// The apps that can open links like [uri], for choosing one to open a
  /// prefix's links in.
  Future<List<AppChoice>> appsForLink(String uri) =>
      _appChoices('appsForLink', {'uri': uri});

  /// The apps that offer their own search.
  Future<List<AppChoice>> appsWithSearch() => _appChoices('appsWithSearch');

  Future<List<AppChoice>> _appChoices(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    try {
      final apps = await _channel.invokeListMethod<Map>(method, arguments);
      return [
        for (final app in apps ?? const <Map>[])
          (
            packageName: app['packageName'] as String,
            label: app['label'] as String,
          ),
      ];
    } on PlatformException catch (e) {
      debugPrint('Failed to list apps for $method: $e');
      return const [];
    }
  }

  /// Hands [query] to [package]'s own search. False when it has none.
  Future<bool> searchInApp(String package, String query) async {
    try {
      final opened = await _channel.invokeMethod<bool>('searchInApp', {
        'package': package,
        'query': query,
      });
      return opened ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to search in $package: $e');
      return false;
    }
  }

  /// Unpins a shortcut from the launcher; the app that made it keeps it.
  Future<void> removeShortcut(AppInfo shortcut) async {
    try {
      await _channel.invokeMethod<void>('removeShortcut', {
        'packageName': shortcut.packageName,
        'shortcutId': shortcut.shortcutId,
        'isWorkApp': shortcut.isWorkApp,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to remove shortcut ${shortcut.key}: $e');
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

  /// Asks the user where to save a backup and writes [content] there.
  /// Returns false if they cancelled; throws [PlatformException] if writing
  /// failed.
  Future<bool> saveBackup(String fileName, String content) =>
      _awaitResult(() async {
        final saved = await _channel.invokeMethod<bool>('saveBackup', {
          'fileName': fileName,
          'content': content,
        });
        return saved ?? false;
      });

  /// Asks the user for a backup file and returns its text, or null if they
  /// cancelled. Throws [PlatformException] if reading failed.
  Future<String?> openBackup() =>
      _awaitResult(() => _channel.invokeMethod<String>('openBackup'));

  /// Null where the system has no accent (before Android 12).
  Future<AccentColors?> getAccentColors() async {
    try {
      final tones = await _channel.invokeMapMethod<String, int>(
        'getAccentColors',
      );
      if (tones == null) return null;
      return (
        onDark: Color(tones['onDark']!),
        onLight: Color(tones['onLight']!),
        tint: Color(tones['tint']!),
      );
    } on PlatformException catch (e) {
      debugPrint('Failed to read accent colors: $e');
      return null;
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

  // --- Synced tasks -----------------------------------------------------

  /// The installed tasks apps with a list the launcher could use.
  Future<List<TaskApp>> taskApps() async {
    try {
      final apps = await _channel.invokeListMethod<Map>('taskApps') ?? [];
      return [
        for (final app in apps)
          (
            authority: app['authority'] as String,
            label: app['label'] as String,
            granted: app['granted'] as bool,
          ),
      ];
    } on PlatformException catch (e) {
      debugPrint('Failed to list task apps: $e');
      return [];
    }
  }

  /// Asks for permission to read and write the tasks app at [authority].
  /// True once granted.
  Future<TaskPermission> requestTaskPermission(String authority) =>
      _awaitResult(() async {
        try {
          final answer = await _channel.invokeMethod<String>(
            'requestTaskPermission',
            {'authority': authority},
          );
          return TaskPermission.values.asNameMap()[answer] ??
              TaskPermission.denied;
        } on PlatformException catch (e) {
          debugPrint('Failed to ask for the task permission: $e');
          return TaskPermission.denied;
        }
      });

  /// Opens Last Launcher's own App info, where a permission Android no
  /// longer asks for can still be allowed.
  Future<void> openOwnAppInfo() async {
    try {
      await _channel.invokeMethod<void>('openOwnAppInfo');
    } on PlatformException catch (e) {
      debugPrint('Failed to open App info: $e');
    }
  }

  /// Throws [TasksUnavailable].
  Future<List<TaskList>> taskLists(String authority) async {
    final lists = await _tasksCall<List<Object?>>('taskLists', {
      'authority': authority,
    });
    return [
      for (final list in lists.cast<Map>())
        (
          id: list['id'] as String,
          name: list['name'] as String? ?? '',
          account: list['account'] as String?,
        ),
    ];
  }

  /// Throws [TasksUnavailable].
  Future<List<ProviderTask>> syncedTasks(TaskSource source) async {
    final tasks = await _tasksCall<List<Object?>>('syncedTasks', {
      'authority': source.authority,
      'listId': source.listId,
    });
    return [
      for (final task in tasks.cast<Map>())
        (
          id: task['id'] as String,
          title: task['title'] as String,
          status: task['status'] as int,
          parentId: task['parentId'] as String?,
          created: task['created'] as int,
          repeats: task['repeats'] as bool? ?? false,
        ),
    ];
  }

  /// Makes [changes] in [source], in order. Returns the id each insert got,
  /// by the id it was sent with. Throws [TasksUnavailable].
  Future<Map<String, String>> applyTaskChanges(
    TaskSource source,
    List<TaskChange> changes,
  ) async {
    final ids = await _tasksCall<Map<Object?, Object?>>('applyTaskChanges', {
      'authority': source.authority,
      'listId': source.listId,
      'changes': [for (final change in changes) change.toMap()],
    });
    return ids.cast<String, String>();
  }

  /// Calls [onTasksChanged] when the tasks at [authority] change; null
  /// stops.
  Future<void> watchTasks(String? authority) async {
    try {
      await _channel.invokeMethod<void>('watchTasks', {'authority': authority});
    } on PlatformException catch (e) {
      debugPrint('Failed to watch tasks: $e');
    }
  }

  Future<T> _tasksCall<T>(String method, Map<String, Object?> arguments) async {
    try {
      final result = await _channel.invokeMethod<T>(method, arguments);
      if (result == null) throw const TasksUnavailable('No answer');
      return result;
    } on PlatformException catch (e) {
      throw TasksUnavailable(e.message);
    }
  }
}
