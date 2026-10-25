import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:last_launcher/features/modules/tasks/subtasks.dart' as subtasks;
import 'package:last_launcher/features/modules/tasks/synced_tasks.dart';
import 'package:last_launcher/features/modules/tasks/task.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where a synced list stands. A list on the phone is always [local].
enum TaskSyncStatus {
  local,
  loading,
  ready,

  /// The tasks app isn't installed (any more).
  appMissing,

  /// The launcher may not read or write the tasks app.
  noPermission,

  /// The list isn't in the tasks app (any more).
  listGone,

  /// Reading or writing failed for another reason.
  failed,

  /// The tasks app turned a change down, though the list can be read: it
  /// shows what the tasks app has.
  notSaved,
}

class TaskState extends ChangeNotifier {
  /// Without [channel] and [settings] (as in most tests), the list is always
  /// the one on the phone.
  TaskState(this._prefs, {AppChannel? channel, SettingsState? settings})
    : _channel = channel,
      _settings = settings {
    _load();
    if (channel != null && settings != null) {
      channel.onTasksChanged = _providerChanged;
      settings.taskSource.addListener(_sourceChanged);
      _sourceChanged();
    }
  }

  static const _key = 'tasks';
  static const _lastClearKey = 'tasks_last_clear_date';

  /// The order and hidden tasks of the synced list: never backed up.
  static const _syncedViewKey = 'synced_task_view';

  /// Every key this state stores under, so a backup can include or leave
  /// out the task list as a whole.
  static const storageKeys = [_key, _lastClearKey];

  final SharedPreferences _prefs;
  final AppChannel? _channel;
  final SettingsState? _settings;

  /// The list on the phone, kept while a synced list is shown.
  List<Task> _local = [];

  /// The synced list, hidden tasks included.
  List<Task> _synced = [];
  Set<String> _hidden = {};

  /// The ids tasks added here got from the tasks app, by the ones they had
  /// first, for changes made before the answer came.
  final _realIds = <String, String>{};

  /// The order stored for the synced list, until it's first read.
  List<String> _storedOrder = [];

  /// Whether the synced list was read before, so it has a view stored.
  bool _viewKnown = false;

  /// Whether the synced list is watched for changes made elsewhere.
  bool _watching = false;

  /// Changes made to the synced list so far, so a read that ran while one
  /// was made knows its rows are from before.
  var _changeCount = 0;
  TaskSource? _source;
  TaskSyncStatus _status = TaskSyncStatus.local;

  /// Changes and reads of the synced list, one after the other.
  Future<void> _queue = Future.value();
  Timer? _refreshSoon;

  List<Task> get tasks => List.unmodifiable(
    _source == null ? _local : visibleTasks(_synced, _hidden),
  );

  /// The synced list's tasks app and list, or null for the phone's.
  TaskSource? get source => _source;
  TaskSyncStatus get status => _status;

  /// Whether the list takes changes: always on the phone, and for a synced
  /// list only once it's read and fine. Until then they'd be lost.
  bool get canChange => _source == null || _status == TaskSyncStatus.ready;

  List<Task> get _current => _source == null ? _local : _synced;
  String _real(String id) => _realIds[id] ?? id;
  bool get _deleteSyncedDone => _settings?.deleteSyncedDone.value ?? false;

  void _load() {
    final json = _prefs.getString(_key);
    if (json == null) return;
    try {
      _local = Task.decodeList(json);
    } on FormatException {
      debugPrint('Corrupt tasks JSON, resetting');
      _prefs.remove(_key);
    }
  }

  /// Re-reads tasks after storage was replaced wholesale, e.g. by restoring
  /// a backup.
  void reload() {
    _local = [];
    _load();
    notifyListeners();
    unawaited(refresh());
  }

  // --- Changes -------------------------------------------------------------

  Future<void> addTask(String title) => _apply([
    Task(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title),
    ..._current,
  ]);

  Future<void> toggleTask(String id) =>
      _apply(subtasks.toggleTask(_current, _real(id)));

  /// Ticks [id] off or back on. With [remove], ticking off removes it: from
  /// the phone, or from a synced list when Delete done tasks is on. Otherwise
  /// a synced task is ticked off there and hidden here.
  Future<void> completeTask(String id, {required bool remove}) async {
    id = _real(id);
    final task = _current.where((t) => t.id == id).firstOrNull;
    if (task == null) return;
    if (!remove || task.done) return toggleTask(id);
    if (_source == null || _deleteSyncedDone) return removeTask(id);
    return _apply(subtasks.toggleTask(_current, id), hide: [id]);
  }

  Future<void> renameTask(String id, String title) => _apply([
    for (final task in _current)
      task.id == _real(id) ? task.copyWith(title: title) : task,
  ]);

  /// Removes [id], and its subtasks if it has any.
  Future<void> removeTask(String id) =>
      _apply(subtasks.removeTask(_current, _real(id)));

  /// Moves [id] to just below [after] in its group, or to the top of it, and
  /// makes it a subtask when [indent] is set; see [subtasks.moveTask].
  Future<void> moveTask(
    String id, {
    required String? after,
    required bool indent,
  }) => _apply(
    subtasks.moveTask(
      _current,
      _real(id),
      after: after == null ? null : _real(after),
      indent: indent,
    ),
  );

  /// Makes [id] a subtask of the task above it, or a task of its own, where
  /// it is; see [subtasks.indentTask].
  Future<void> indentTask(String id, {required bool indent}) => _apply(
    subtasks.indentTask(_current, _real(id), indent: indent, shown: tasks),
  );

  /// Clears done tasks once a day: removes them, or for a synced list
  /// without Delete done tasks, hides them.
  Future<void> clearCompletedIfNewDay() async {
    // Until a synced list is read there's nothing to clear yet; it's
    // tried again once it is.
    if (_source != null && _status != TaskSyncStatus.ready) return;
    final today = _todayKey();
    if (_prefs.getString(_lastClearKey) == today) return;
    await _prefs.setString(_lastClearKey, today);
    final done = [
      for (final task in _current)
        if (task.done) task.id,
    ];
    if (done.isEmpty) return;
    if (_source != null && !_deleteSyncedDone) {
      await _apply(_current, hide: done);
    } else {
      // Only what's shown: never the history hidden when a list was
      // first read, which the launcher didn't show.
      final shown = {for (final task in tasks) task.id};
      await _apply(
        subtasks.withoutDone(_current, keep: (t) => !shown.contains(t.id)),
      );
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// Makes [next] the list, hiding the tasks in [hide], and stores it: on
  /// the phone, or as changes to the synced list.
  Future<void> _apply(
    List<Task> next, {
    Iterable<String> hide = const [],
  }) async {
    if (!canChange) return;
    final before = _current;
    if (identical(next, before) && hide.isEmpty) return;
    final source = _source;
    if (source == null) {
      _local = next;
      notifyListeners();
      await _prefs.setString(_key, Task.encodeList(_local));
      return;
    }
    _changeCount++;
    _synced = next;
    _hidden = pruneHidden({..._hidden, ...hide}, next);
    notifyListeners();
    final changes = syncedChanges(before, next);
    // Queued before anything is awaited, so a read asked for meanwhile
    // comes after it.
    final sent = changes.isEmpty
        ? null
        : _enqueue(() => _send(source, changes));
    await _saveSyncedView();
    await sent;
  }

  Future<void> _send(TaskSource source, List<TaskChange> changes) async {
    final Map<String, String> ids;
    try {
      ids = await _channel!.applyTaskChanges(source, [
        for (final change in changes) change.withIds(_realIds),
      ]);
    } on TasksUnavailable catch (e) {
      debugPrint('Failed to change synced tasks: $e');
      // What's there is what counts; reading it says what went wrong.
      await _read();
      if (_status == TaskSyncStatus.ready) {
        _status = TaskSyncStatus.notSaved;
        notifyListeners();
      }
      return;
    }
    _realIds.addAll(ids);
    if (ids.isEmpty || _source != source) return;
    // Tasks added here get the ids the tasks app gave them.
    _synced = [
      for (final task in _synced)
        if (ids[task.id] case final id?)
          Task(
            id: id,
            title: task.title,
            done: task.done,
            indented: task.indented,
            repeats: task.repeats,
          )
        else
          task,
    ];
    _hidden = {for (final id in _hidden) ids[id] ?? id};
    await _saveSyncedView();
  }

  // --- The synced list -------------------------------------------------------

  /// Reads the synced list again, after any changes on their way. Nothing
  /// for the list on the phone.
  Future<void> refresh() {
    if (_source == null) return Future.value();
    return _enqueue(_read);
  }

  /// Asks for the synced list's tasks app's permission, then reads the list.
  Future<void> requestPermission() async {
    final source = _source;
    if (source == null) return;
    await askPermission(source.authority);
    await refresh();
  }

  /// Asks for the permission of the tasks app at [authority]. When Android
  /// no longer asks, opens Last Launcher's App info, where it can still be
  /// allowed.
  Future<bool> askPermission(String authority) async {
    final channel = _channel;
    if (channel == null) return false;
    final answer = await channel.requestTaskPermission(authority);
    if (answer == TaskPermission.blocked) await channel.openOwnAppInfo();
    return answer == TaskPermission.granted;
  }

  /// Opens the synced list's tasks app: a repeating task is ticked off
  /// there.
  Future<void> openTasksApp() async {
    final source = _source;
    if (source == null) return;
    await _channel?.launchApp(taskAppPackages[source.authority]!);
  }

  /// The tasks apps the launcher could take a list from.
  Future<List<TaskApp>> taskApps() async => await _channel?.taskApps() ?? [];

  /// The task lists of [app], once the launcher may read them.
  Future<List<TaskList>> taskLists(TaskApp app) async {
    final channel = _channel;
    if (channel == null || !app.granted) return [];
    try {
      return await channel.taskLists(app.authority);
    } on TasksUnavailable catch (e) {
      debugPrint('Failed to list task lists: $e');
      return [];
    }
  }

  /// The synced list's name, when the launcher may read it.
  Future<String?> sourceListName() async {
    final (source, channel) = (_source, _channel);
    if (source == null || channel == null) return null;
    try {
      final lists = await channel.taskLists(source.authority);
      return lists.where((list) => list.id == source.listId).firstOrNull?.name;
    } on TasksUnavailable {
      return null;
    }
  }

  Future<void> _enqueue(Future<void> Function() run) =>
      _queue = _queue.then((_) => run()).catchError((Object e) {
        debugPrint('Synced tasks failed: $e');
      });

  void _sourceChanged() {
    final source = parseTaskSource(_settings!.taskSource.value);
    if (source == _source) return;
    _source = source;
    _watching = false;
    unawaited(_channel!.watchTasks(source?.authority));
    if (source == null) {
      _status = TaskSyncStatus.local;
      notifyListeners();
      return;
    }
    final view = _readSyncedView(source);
    _synced = [];
    _storedOrder = view?.order ?? [];
    _hidden = view?.hidden ?? {};
    _viewKnown = view != null;
    _status = TaskSyncStatus.loading;
    notifyListeners();
    unawaited(refresh());
  }

  /// The tasks app tells about every change, its own and the launcher's,
  /// often several at once.
  void _providerChanged() {
    _refreshSoon?.cancel();
    _refreshSoon = Timer(const Duration(milliseconds: 300), refresh);
  }

  Future<void> _read() async {
    final source = _source;
    if (source == null) return;
    final channel = _channel!;
    final changesBefore = _changeCount;
    final app = (await channel.taskApps())
        .where((app) => app.authority == source.authority)
        .firstOrNull;
    TaskSyncStatus status;
    List<ProviderTask>? rows;
    if (app == null) {
      status = TaskSyncStatus.appMissing;
    } else if (!app.granted) {
      status = TaskSyncStatus.noPermission;
    } else {
      try {
        final lists = await channel.taskLists(source.authority);
        if (lists.any((list) => list.id == source.listId)) {
          rows = await channel.syncedTasks(source);
          status = TaskSyncStatus.ready;
        } else {
          status = TaskSyncStatus.listGone;
        }
      } on TasksUnavailable catch (e) {
        debugPrint('Failed to read synced tasks: $e');
        status = TaskSyncStatus.failed;
      }
    }
    if (_source != source) return;
    if (_changeCount != changesBefore) {
      // Changed while this was read, so the rows are from before: read
      // again once the change is on its way.
      _providerChanged();
      return;
    }
    if (rows != null) {
      final order = _synced.isEmpty
          ? _storedOrder
          : [for (final task in _synced) task.id];
      _synced = arrangeSynced(rows, order);
      // A list read for the first time starts without its history.
      if (!_viewKnown) {
        _hidden = {
          for (final task in _synced)
            if (task.done) task.id,
        };
        _viewKnown = true;
      }
      _hidden = pruneHidden(_hidden, _synced);
      await _saveSyncedView();
    }
    _status = status;
    notifyListeners();
    if (status == TaskSyncStatus.ready && !_watching) {
      // Watching needs the permission, so it may only work from now on.
      _watching = true;
      unawaited(channel.watchTasks(source.authority));
    }
    if (status == TaskSyncStatus.ready &&
        (_settings?.clearCompletedDaily.value ?? false)) {
      unawaited(clearCompletedIfNewDay());
    }
  }

  /// The stored views of synced lists, by [storeTaskSource]: each list keeps
  /// its own order and hidden tasks.
  Map<String, Object?> _syncedViews() {
    final json = _prefs.get(_syncedViewKey);
    if (json is! String) return {};
    try {
      final views = jsonDecode(json);
      return views is Map<String, Object?> ? views : {};
    } on FormatException {
      return {};
    }
  }

  /// [source]'s order and hidden tasks; null for a list not read before.
  ({List<String> order, Set<String> hidden})? _readSyncedView(
    TaskSource source,
  ) {
    final view = _syncedViews()[storeTaskSource(source)];
    if (view is! Map || view['order'] is! List || view['hidden'] is! List) {
      return null;
    }
    return (
      order: (view['order'] as List).whereType<String>().toList(),
      hidden: (view['hidden'] as List).whereType<String>().toSet(),
    );
  }

  Future<void> _saveSyncedView() async {
    final source = _source;
    if (source == null) return;
    final views = _syncedViews();
    views[storeTaskSource(source)] = {
      // Before the first read, the order from before still holds.
      'order': _synced.isEmpty
          ? _storedOrder
          : [for (final task in _synced) task.id],
      'hidden': _hidden.toList(),
    };
    await _prefs.setString(_syncedViewKey, jsonEncode(views));
  }

  @override
  void dispose() {
    _refreshSoon?.cancel();
    _settings?.taskSource.removeListener(_sourceChanged);
    super.dispose();
  }
}
