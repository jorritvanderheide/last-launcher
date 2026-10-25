import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/tasks/synced_tasks.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authority = 'org.tasks.opentasks';
const _source = '$_authority/7';

/// A tasks app with one list, keeping its tasks the way a provider does.
class _FakeTasksApp extends AppChannel {
  bool installed = true;
  bool granted = true;
  List<TaskList> lists = [(id: '7', name: 'Personal', account: 'radicale')];
  final rows = <String, ProviderTask>{};
  final sent = <List<TaskChange>>[];
  String? watching;

  /// Holds every write until completed.
  Completer<void>? gate;

  /// Turns writes down, the way a read-only list would.
  bool refuseWrites = false;
  var _nextId = 100;

  /// Android no longer asks for the permission, and answers at once.
  bool blocked = false;
  var appInfoOpened = 0;
  var watchCalls = 0;
  String? launched;

  /// Holds every read of the tasks until completed.
  Completer<void>? readGate;

  void add(
    String id,
    String title, {
    String? parent,
    int status = 0,
    bool repeats = false,
  }) => rows[id] = (
    id: id,
    title: title,
    status: status,
    parentId: parent,
    created: rows.length,
    repeats: repeats,
  );

  @override
  Future<List<TaskApp>> taskApps() async => [
    if (installed)
      (authority: _authority, label: 'Tasks.org', granted: granted),
  ];

  @override
  Future<TaskPermission> requestTaskPermission(String authority) async {
    if (blocked) return TaskPermission.blocked;
    granted = true;
    return TaskPermission.granted;
  }

  @override
  Future<void> openOwnAppInfo() async => appInfoOpened++;

  @override
  Future<void> launchApp(
    String packageName, {
    bool isWorkApp = false,
    String? shortcutId,
  }) async => launched = packageName;

  @override
  Future<List<TaskList>> taskLists(String authority) async {
    if (!granted) throw const TasksUnavailable('No permission');
    return lists;
  }

  @override
  Future<List<ProviderTask>> syncedTasks(TaskSource source) async {
    await readGate?.future;
    return rows.values.toList();
  }

  @override
  Future<Map<String, String>> applyTaskChanges(
    TaskSource source,
    List<TaskChange> changes,
  ) async {
    await gate?.future;
    if (refuseWrites) throw const TasksUnavailable('Read-only');
    sent.add(changes);
    final ids = <String, String>{};
    for (final change in changes) {
      final id = ids[change.id] ?? change.id;
      final parent = ids[change.parentId] ?? change.parentId;
      switch (change.op) {
        case 'insert':
          final newId = '${_nextId++}';
          ids[change.id] = newId;
          add(
            newId,
            change.title!,
            parent: parent,
            status: change.done! ? 2 : 0,
          );
        case 'update':
          // Like the provider: an id it doesn't have updates nothing.
          final row = rows[id];
          if (row == null) continue;
          rows[id] = (
            id: id,
            title: change.title ?? row.title,
            status: change.done == null ? row.status : (change.done! ? 2 : 0),
            parentId: change.setsParent ? parent : row.parentId,
            created: row.created,
            repeats: row.repeats,
          );
        case 'delete':
          rows.remove(id);
      }
    }
    return ids;
  }

  @override
  Future<void> watchTasks(String? authority) async {
    watchCalls++;
    watching = authority;
  }
}

void main() {
  late _FakeTasksApp app;
  late SettingsState settings;
  late TaskState state;

  Future<void> start({Map<String, Object> stored = const {}}) async {
    SharedPreferences.setMockInitialValues(stored);
    final prefs = await SharedPreferences.getInstance();
    settings = SettingsState(prefs);
    state = TaskState(prefs, channel: app, settings: settings);
    await pumpEventQueue();
  }

  Future<void> useList() async {
    settings.taskSource.value = _source;
    await pumpEventQueue();
  }

  List<String> titles() => [for (final t in state.tasks) t.title];

  setUp(() {
    app = _FakeTasksApp()
      ..add('1', 'Shop')
      ..add('2', 'Milk', parent: '1')
      ..add('3', 'Call');
  });

  test('reads the chosen list, and watches it', () async {
    await start();
    expect(state.status, TaskSyncStatus.local);
    await useList();
    expect(state.status, TaskSyncStatus.ready);
    expect(app.watching, _authority);
    // Tasks it hasn't seen yet come first, newest first.
    expect(titles(), ['Call', 'Shop', 'Milk']);
    expect(state.tasks[2].indented, isTrue);
  });

  test('the list on the phone comes back untouched', () async {
    await start(
      stored: {'tasks': '[{"id":"9","title":"Water plants","done":false}]'},
    );
    await useList();
    expect(titles(), isNot(contains('Water plants')));
    settings.taskSource.value = null;
    await pumpEventQueue();
    expect(titles(), ['Water plants']);
    expect(app.watching, isNull);
  });

  test('ticking off a task is sent to the tasks app', () async {
    await start();
    await useList();
    await state.toggleTask('1');
    await pumpEventQueue();
    expect(app.sent.last, [
      const TaskChange.update('1', done: true),
      const TaskChange.update('2', done: true),
    ]);
    expect(app.rows['1']!.status, 2);
  });

  test('a task added here gets the id the tasks app gave it', () async {
    await start();
    await useList();
    await state.addTask('Post');
    await pumpEventQueue();
    expect(state.tasks.first.title, 'Post');
    expect(state.tasks.first.id, '100');
    expect(app.rows['100']!.title, 'Post');
  });

  test('a subtask made here gets its parent there', () async {
    await start();
    await useList();
    await state.moveTask('1', after: '3', indent: true);
    await pumpEventQueue();
    expect(app.rows['1']!.parentId, '3');
  });

  test('the order is kept on the phone', () async {
    await start();
    await useList();
    await state.moveTask('3', after: '2', indent: false);
    await state.refresh();
    expect(titles(), ['Shop', 'Milk', 'Call']);

    // And survives a restart.
    final prefs = await SharedPreferences.getInstance();
    final again = TaskState(prefs, channel: app, settings: settings);
    await pumpEventQueue();
    expect([for (final t in again.tasks) t.title], ['Shop', 'Milk', 'Call']);
  });

  group('done tasks', () {
    test('remove on complete hides them, unless deleting is on', () async {
      await start();
      await useList();
      await state.completeTask('3', remove: true);
      await pumpEventQueue();
      expect(titles(), ['Shop', 'Milk']);
      expect(app.rows['3']!.status, 2);

      settings.deleteSyncedDone.value = true;
      await state.completeTask('1', remove: true);
      await pumpEventQueue();
      expect(titles(), isEmpty);
      expect(app.rows.keys, ['3']);
    });

    test('clear completed daily hides them, unless deleting is on', () async {
      await start();
      await useList();
      // Done since the list was first read, so in view until cleared.
      app.add('4', 'Post', status: 2);
      await state.refresh();
      expect(titles(), contains('Post'));
      await state.clearCompletedIfNewDay();
      await pumpEventQueue();
      expect(titles(), isNot(contains('Post')));
      expect(app.rows, contains('4'));
    });

    test('clear completed daily waits until the list is read', () async {
      app.add('4', 'Post', status: 2);
      // Read before, without Post hidden.
      await start(
        stored: {
          'task_source': _source,
          'synced_task_view': '{"$_source":{"order":[],"hidden":[]}}',
        },
      );
      settings.clearCompletedDaily.value = true;
      // On a cold start this runs before the list is read.
      final early = state.clearCompletedIfNewDay();
      await early;
      await state.refresh();
      await pumpEventQueue();
      expect(titles(), isNot(contains('Post')));
    });

    test('a hidden task ticked back on elsewhere shows again', () async {
      await start();
      await useList();
      await state.completeTask('3', remove: true);
      await pumpEventQueue();
      app.add('3', 'Call');
      await state.refresh();
      expect(titles(), contains('Call'));
    });
  });

  group('problems', () {
    test('the tasks app missing', () async {
      app.installed = false;
      await start();
      await useList();
      expect(state.status, TaskSyncStatus.appMissing);
      expect(state.tasks, isEmpty);
    });

    test('no permission, until it is given', () async {
      app.granted = false;
      await start();
      await useList();
      expect(state.status, TaskSyncStatus.noPermission);
      await state.requestPermission();
      expect(state.status, TaskSyncStatus.ready);
      expect(state.tasks, hasLength(3));
    });

    test('the list gone', () async {
      app.lists = [];
      await start();
      await useList();
      expect(state.status, TaskSyncStatus.listGone);
    });
  });
  group('a task just added', () {
    test('can be ticked off before the tasks app gave it its id', () async {
      await start();
      await useList();
      app.gate = Completer();
      unawaited(state.addTask('Post'));
      await pumpEventQueue();
      final early = state.tasks.first.id;
      unawaited(state.toggleTask(early));
      app.gate!.complete();
      await pumpEventQueue();
      expect(app.rows['100']!.status, 2);

      // And changed by the id it had, once it has another.
      await state.renameTask(early, 'Post office');
      await pumpEventQueue();
      expect(app.rows['100']!.title, 'Post office');
    });

    test('can get a subtask before it has its id', () async {
      await start();
      await useList();
      app.gate = Completer();
      unawaited(state.addTask('Errands'));
      await pumpEventQueue();
      unawaited(state.moveTask('3', after: state.tasks.first.id, indent: true));
      app.gate!.complete();
      await pumpEventQueue();
      expect(app.rows['3']!.parentId, '100');
    });
  });

  group('an open subtask of a done task', () {
    setUp(() {
      app = _FakeTasksApp()
        ..add('1', 'Other')
        ..add('2', 'Move house', status: 2)
        ..add('3', 'Cancel internet', parent: '2');
    });

    test('keeps its task when done tasks are cleared', () async {
      await start();
      await useList();
      settings.deleteSyncedDone.value = true;
      await state.clearCompletedIfNewDay();
      await pumpEventQueue();
      expect(app.rows.keys, containsAll(['1', '2', '3']));
      expect(app.rows['3']!.parentId, '2');
    });

    test('stays in view when done tasks are hidden', () async {
      await start();
      await useList();
      await state.clearCompletedIfNewDay();
      await pumpEventQueue();
      expect(titles(), containsAll(['Cancel internet', 'Move house']));
    });
  });

  group('while the list has a problem', () {
    test('nothing is added, so nothing vanishes later', () async {
      app.granted = false;
      await start();
      await useList();
      expect(state.canChange, isFalse);
      await state.addTask('Post');
      expect(titles(), isEmpty);
      await state.requestPermission();
      expect(state.canChange, isTrue);
      expect(titles(), isNot(contains('Post')));
    });

    test('a change the tasks app turns down says so', () async {
      await start();
      await useList();
      app.refuseWrites = true;
      await state.toggleTask('3');
      await pumpEventQueue();
      expect(state.status, TaskSyncStatus.notSaved);
      expect(state.tasks.firstWhere((t) => t.id == '3').done, isFalse);

      app.refuseWrites = false;
      await state.refresh();
      expect(state.status, TaskSyncStatus.ready);
    });
  });
  group('each list', () {
    test('starts without the tasks done before it was chosen', () async {
      app.add('4', 'Post', status: 2);
      await start();
      await useList();
      expect(titles(), isNot(contains('Post')));

      // Done since, it's there until cleared.
      app.add('5', 'Bake', status: 2);
      await state.refresh();
      expect(titles(), contains('Bake'));
    });

    test('keeps its own order and hidden tasks', () async {
      app.lists = [...app.lists, (id: '8', name: 'Work', account: 'radicale')];
      await start();
      await useList();
      await state.moveTask('3', after: '2', indent: false);
      await state.completeTask('1', remove: true);
      await pumpEventQueue();
      expect(titles(), ['Call']);

      settings.taskSource.value = '$_authority/8';
      await pumpEventQueue();
      settings.taskSource.value = _source;
      await pumpEventQueue();
      expect(titles(), ['Call']);
    });
  });

  test('a read that ran while a task was ticked off keeps the tick', () async {
    await start();
    await useList();
    app.readGate = Completer();
    unawaited(state.refresh());
    await pumpEventQueue();
    app.gate = Completer();
    unawaited(state.toggleTask('3'));
    app.readGate!.complete();
    await pumpEventQueue();
    expect(state.tasks.firstWhere((t) => t.id == '3').done, isTrue);
    app.gate!.complete();
    await pumpEventQueue();
    expect(app.rows['3']!.status, 2);
  });

  group('a repeating task', () {
    setUp(() {
      app = _FakeTasksApp()
        ..add('1', 'Plants')
        ..add('2', 'Water', parent: '1', repeats: true);
    });

    test('is ticked off in its own app', () async {
      await start();
      await useList();
      await state.toggleTask('2');
      await pumpEventQueue();
      expect(app.rows['2']!.status, 0);
      await state.openTasksApp();
      expect(app.launched, 'org.tasks');
    });

    test('stays as it is when its task is ticked off', () async {
      await start();
      await useList();
      await state.toggleTask('1');
      await pumpEventQueue();
      expect(app.rows['1']!.status, 2);
      expect(app.rows['2']!.status, 0);
    });
  });

  group('the permission', () {
    test('is only asked for an app that is picked', () async {
      app.granted = false;
      await start();
      final apps = await state.taskApps();
      expect(await state.taskLists(apps.single), isEmpty);
      expect(app.granted, isFalse);
      expect(await state.askPermission(_authority), isTrue);
    });

    test('opens App info once Android no longer asks', () async {
      app
        ..granted = false
        ..blocked = true;
      await start();
      await useList();
      await state.requestPermission();
      expect(app.appInfoOpened, 1);
      expect(state.status, TaskSyncStatus.noPermission);
    });

    test('once given, the list is watched again', () async {
      app.granted = false;
      await start();
      await useList();
      final before = app.watchCalls;
      await state.requestPermission();
      expect(app.watchCalls, before + 1);
      expect(app.watching, _authority);
    });
  });
  group('found before 1.4.0', () {
    test('clearing never deletes the history hidden at the start', () async {
      app.add('4', 'Post', status: 2);
      await start();
      await useList();
      settings.deleteSyncedDone.value = true;
      // Done since the list was chosen, and shown.
      app.add('5', 'Bake', status: 2);
      await state.refresh();
      await state.clearCompletedIfNewDay();
      await pumpEventQueue();
      expect(app.rows, contains('4'));
      expect(app.rows, isNot(contains('5')));
    });

    test('a subtask goes under the task shown above it', () async {
      app = _FakeTasksApp()
        ..add('T', 'Today')
        ..add('A', 'Shop', status: 2)
        ..add('B', 'Old', status: 2)
        ..add('C', 'Call', status: 2);
      await start(
        stored: {
          'synced_task_view':
              '{"$_source":{"order":["T","A","B","C"],"hidden":["B"]}}',
        },
      );
      await useList();
      expect(titles(), ['Today', 'Shop', 'Call']);
      await state.indentTask('C', indent: true);
      await pumpEventQueue();
      expect(app.rows['C']!.parentId, 'A');
    });

    test('a refresh asked for during a change reads it afterwards', () async {
      await start();
      await useList();
      final removing = state.removeTask('3');
      unawaited(state.refresh());
      await removing;
      await pumpEventQueue();
      expect(app.rows, isNot(contains('3')));
      expect(titles(), isNot(contains('Call')));
    });
  });
}
