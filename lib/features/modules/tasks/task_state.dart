import 'package:flutter/foundation.dart';
import 'package:last_launcher/features/modules/tasks/subtasks.dart' as subtasks;
import 'package:last_launcher/features/modules/tasks/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskState extends ChangeNotifier {
  TaskState(this._prefs) {
    _load();
  }

  static const _key = 'tasks';
  static const _lastClearKey = 'tasks_last_clear_date';

  /// Every key this state stores under, so a backup can include or leave
  /// out the task list as a whole.
  static const storageKeys = [_key, _lastClearKey];

  final SharedPreferences _prefs;
  List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void _load() {
    final json = _prefs.getString(_key);
    if (json == null) return;
    try {
      _tasks = Task.decodeList(json);
    } on FormatException {
      debugPrint('Corrupt tasks JSON, resetting');
      _prefs.remove(_key);
    }
  }

  /// Re-reads tasks after storage was replaced wholesale, e.g. by restoring
  /// a backup.
  void reload() {
    _tasks = [];
    _load();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs.setString(_key, Task.encodeList(_tasks));
  }

  Future<void> addTask(String title) async {
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );
    _tasks.insert(0, task);
    notifyListeners();
    await _save();
  }

  Future<void> toggleTask(String id) => _apply(subtasks.toggleTask(_tasks, id));

  Future<void> renameTask(String id, String title) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(title: title);
    notifyListeners();
    await _save();
  }

  /// Removes [id], and its subtasks if it has any.
  Future<void> removeTask(String id) => _apply(subtasks.removeTask(_tasks, id));

  Future<void> clearCompletedIfNewDay() async {
    final today = _todayKey();
    if (_prefs.getString(_lastClearKey) == today) return;
    await _prefs.setString(_lastClearKey, today);
    if (_tasks.any((t) => t.done)) {
      _tasks.removeWhere((t) => t.done);
      notifyListeners();
      await _save();
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// Moves [id] to just below [after] in its group, or to the top of it, and
  /// makes it a subtask when [indent] is set; see [subtasks.moveTask].
  Future<void> moveTask(
    String id, {
    required String? after,
    required bool indent,
  }) => _apply(subtasks.moveTask(_tasks, id, after: after, indent: indent));

  /// Makes [id] a subtask of the task above it, or a task of its own, where
  /// it is; see [subtasks.indentTask].
  Future<void> indentTask(String id, {required bool indent}) =>
      _apply(subtasks.indentTask(_tasks, id, indent: indent));

  Future<void> _apply(List<Task> tasks) async {
    if (identical(tasks, _tasks)) return;
    _tasks = tasks;
    notifyListeners();
    await _save();
  }
}
