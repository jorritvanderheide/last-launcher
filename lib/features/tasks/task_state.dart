import 'package:flutter/foundation.dart';
import 'package:last_launcher/features/tasks/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskState extends ChangeNotifier {
  TaskState(this._prefs) {
    _load();
  }

  static const _key = 'tasks';

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

  void addTask(String title) {
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );
    _tasks.insert(0, task);
    notifyListeners();
    _save();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(done: !_tasks[index].done);
    notifyListeners();
    _save();
  }

  void renameTask(String id, String title) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(title: title);
    notifyListeners();
    _save();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    _save();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex == newIndex) return;
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    notifyListeners();
    _save();
  }
}
