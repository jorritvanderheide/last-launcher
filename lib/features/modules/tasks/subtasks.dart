import 'package:last_launcher/features/modules/tasks/task.dart';

/// The rules of subtasks, one level deep.
///
/// The task list is stored flat. A task marked [Task.indented] is a subtask
/// of the nearest top-level task above it, and the two go together: they're
/// listed, ticked off, removed and moved as one. The first task is always
/// top level, whatever it says.

/// How far a subtask is indented, in logical pixels.
const subtaskIndent = 36.0;

/// How far a lifted row has to be dragged sideways to change its indent.
const indentDragThreshold = 24.0;

/// Whether the task at [index] heads a family: it's top level, or it's first.
bool _isHead(List<Task> tasks, int index) =>
    index == 0 || !tasks[index].indented;

/// The index of the task heading the family [index] is in.
int _headOf(List<Task> tasks, int index) {
  var head = index;
  while (!_isHead(tasks, head)) {
    head--;
  }
  return head;
}

/// The index just past the subtasks of the head at [head].
int _familyEnd(List<Task> tasks, int head) {
  var end = head + 1;
  while (end < tasks.length && tasks[end].indented) {
    end++;
  }
  return end;
}

/// The tasks still to do and the ones done, each in list order. A family is
/// done when its top-level task is, and its subtasks stay with it either way.
/// A subtask without a task above it is shown at the top level.
({List<Task> todo, List<Task> done}) taskGroups(List<Task> tasks) {
  final todo = <Task>[];
  final done = <Task>[];
  var head = 0;
  while (head < tasks.length) {
    final end = _familyEnd(tasks, head);
    (tasks[head].done ? done : todo).addAll([
      tasks[head].indented
          ? tasks[head].copyWith(indented: false)
          : tasks[head],
      ...tasks.sublist(head + 1, end),
    ]);
    head = end;
  }
  return (todo: todo, done: done);
}

/// [tasks] with [id] ticked off, or back on. A top-level task takes its
/// subtasks along; a subtask put back on puts its top-level task back too.
/// A repeating task is left alone, along or by itself: its own app ticks it
/// off, and knows the next time. The same list when there's no such task.
List<Task> toggleTask(List<Task> tasks, String id) {
  final index = tasks.indexWhere((t) => t.id == id);
  if (index == -1 || tasks[index].repeats) return tasks;
  final result = [...tasks];
  final done = !tasks[index].done;
  if (_isHead(tasks, index)) {
    final end = _familyEnd(tasks, index);
    for (var i = index; i < end; i++) {
      if (!result[i].repeats) result[i] = result[i].copyWith(done: done);
    }
  } else {
    result[index] = result[index].copyWith(done: done);
    final head = _headOf(tasks, index);
    if (!done && tasks[head].done && !tasks[head].repeats) {
      result[head] = result[head].copyWith(done: false);
    }
  }
  return result;
}

/// [tasks] without [id], and without its subtasks if it has any. The same
/// list when there's no such task.
List<Task> removeTask(List<Task> tasks, String id) {
  final index = tasks.indexWhere((t) => t.id == id);
  if (index == -1) return tasks;
  final end = _isHead(tasks, index) ? _familyEnd(tasks, index) : index + 1;
  return [...tasks]..removeRange(index, end);
}

/// [tasks] with [id] moved to just below [after] within its group (to do or
/// done), or to the top of it when [after] is null, and made a subtask when
/// [indent] is set. The same list when there's no such task.
///
/// A top-level task brings its subtasks along. It can't be a subtask at the
/// top of a group, since nothing is above it, and it doesn't land between a
/// task and its subtasks: it goes below them. When [after] is the task itself
/// or one of its own subtasks, only the indent changes.
List<Task> moveTask(
  List<Task> tasks,
  String id, {
  required String? after,
  required bool indent,
}) {
  final groups = taskGroups(tasks);
  final inTodo = groups.todo.any((t) => t.id == id);
  final rows = [...(inTodo ? groups.todo : groups.done)];
  final from = rows.indexWhere((t) => t.id == id);
  if (from == -1) return tasks;

  final end = _isHead(rows, from) ? _familyEnd(rows, from) : from + 1;
  final block = rows.sublist(from, end);
  rows.removeRange(from, end);

  final above = after == null ? -1 : rows.indexWhere((t) => t.id == after);
  var at = after == null
      ? 0
      : above == -1
      ? from // after is in the block, or gone: the task stays where it is
      : above + 1;
  final indented = indent && at > 0;
  if (!indented) {
    while (at < rows.length && rows[at].indented) {
      at++;
    }
  }
  block[0] = block[0].copyWith(indented: indented);
  rows.insertAll(at, block);
  return inTodo ? [...rows, ...groups.done] : [...groups.todo, ...rows];
}

/// [tasks] without the done ones, except those [keep] holds on to. A done
/// task stays while any of its subtasks does (an open one, which only
/// another app can leave behind, or one [keep] holds on to): without it
/// they'd become subtasks of whatever is above.
List<Task> withoutDone(List<Task> tasks, {bool Function(Task task)? keep}) {
  bool stays(Task task) => !task.done || (keep?.call(task) ?? false);
  final kept = <Task>[];
  var head = 0;
  while (head < tasks.length) {
    final end = _familyEnd(tasks, head);
    final subtasks = [
      for (var i = head + 1; i < end; i++)
        if (stays(tasks[i])) tasks[i],
    ];
    if (stays(tasks[head]) || subtasks.isNotEmpty) kept.add(tasks[head]);
    kept.addAll(subtasks);
    head = end;
  }
  return kept;
}

/// The parent of each task in [tasks]: the id of the task it's a subtask
/// of, or null for a top-level task.
Map<String, String?> parentsOf(List<Task> tasks) {
  final parents = <String, String?>{};
  String? head;
  for (var i = 0; i < tasks.length; i++) {
    if (_isHead(tasks, i)) {
      head = tasks[i].id;
      parents[head] = null;
    } else {
      parents[tasks[i].id] = head;
    }
  }
  return parents;
}

/// Whether [id] can be made a subtask where it is: a top-level task that
/// isn't the first of its group, so there's a task above it.
bool canIndent(List<Task> tasks, String id) {
  final groups = taskGroups(tasks);
  for (final rows in [groups.todo, groups.done]) {
    final index = rows.indexWhere((t) => t.id == id);
    if (index != -1) return index > 0 && !rows[index].indented;
  }
  return false;
}

/// The subtasks that move along when [id] is moved: none for a subtask.
Iterable<Task> subtasksOf(List<Task> tasks, String id) {
  final index = tasks.indexWhere((t) => t.id == id);
  if (index == -1 || !_isHead(tasks, index)) return const [];
  return tasks.sublist(index + 1, _familyEnd(tasks, index));
}

/// [tasks] with [id] made a subtask of the task above it in its group, or a
/// task of its own, without moving it otherwise; see [moveTask] for where a
/// subtask that stops being one lands. The same list when its indent is
/// already that, or there's no such task. When only some of [tasks] are
/// [shown], the task above it is the one shown above it.
List<Task> indentTask(
  List<Task> tasks,
  String id, {
  required bool indent,
  List<Task>? shown,
}) {
  final groups = taskGroups(shown ?? tasks);
  for (final rows in [groups.todo, groups.done]) {
    final index = rows.indexWhere((t) => t.id == id);
    if (index == -1) continue;
    if (rows[index].indented == indent) return tasks;
    final above = index == 0 ? null : rows[index - 1].id;
    return moveTask(tasks, id, after: above, indent: indent);
  }
  return tasks;
}

/// The row a drag lands below, for a row lifted from [from] and dropped at
/// [to] in [rows], numbered the way a reorderable list numbers them: with
/// the lifted row still in place. Null at the top.
String? rowAbove(List<Task> rows, int from, int to) {
  var above = to - 1;
  if (above == from) above = from - 1;
  return above < 0 ? null : rows[above].id;
}

/// Whether a lifted row ends up a subtask, after being dragged [dx] to the
/// right (or left, when negative) of where it was lifted.
bool indentAfterDrag({required bool wasIndented, required double dx}) =>
    wasIndented ? dx > -indentDragThreshold : dx >= indentDragThreshold;
