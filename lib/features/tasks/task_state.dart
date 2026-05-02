import 'package:flutter/foundation.dart';
import 'package:last_launcher/features/tasks/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskState extends ChangeNotifier {
  TaskState(this._prefs) {
    _load();
  }

  static const _key = 'tasks';
  static const _lastClearKey = 'tasks_last_clear_date';

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

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(done: !_tasks[index].done);
    notifyListeners();
    await _save();
  }

  Future<void> renameTask(String id, String title) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(title: title);
    notifyListeners();
    await _save();
  }

  Future<void> removeTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _save();
  }

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

  Future<void> reorderInGroup(
    int oldIndex,
    int newIndex, {
    required bool done,
  }) async {
    final incompletes = _tasks.where((t) => !t.done).toList();
    final dones = _tasks.where((t) => t.done).toList();
    final group = done ? dones : incompletes;
    if (oldIndex < 0 || oldIndex >= group.length) return;
    if (newIndex > group.length) newIndex = group.length;
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex == newIndex) return;
    final task = group.removeAt(oldIndex);
    group.insert(newIndex, task);
    _tasks = [...incompletes, ...dones];
    notifyListeners();
    await _save();
  }
}
