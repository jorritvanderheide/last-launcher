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
    _tasks.add(task);
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
