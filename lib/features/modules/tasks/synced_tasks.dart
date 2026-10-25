import 'package:last_launcher/features/modules/tasks/subtasks.dart';
import 'package:last_launcher/features/modules/tasks/task.dart';

/// The rules of a task list kept in a tasks app (Tasks.org or OpenTasks),
/// which DAVx⁵ syncs with a CalDAV server.
///
/// The launcher reads the list's tasks into the same flat list a list on
/// the phone has, changes it with the same rules, and writes back only the
/// difference. The order is the launcher's own: CalDAV has none that every
/// app agrees on, so it's kept on the phone.

/// A list in a tasks app: the app's provider authority and the list's id.
typedef TaskSource = ({String authority, String listId});

/// The tasks apps the launcher can use, by provider authority.
const taskAppNames = {
  'org.tasks.opentasks': 'Tasks.org',
  'org.dmfs.tasks': 'OpenTasks',
};

/// Each tasks app's package, to open it, by provider authority.
const taskAppPackages = {
  'org.tasks.opentasks': 'org.tasks',
  'org.dmfs.tasks': 'org.dmfs.tasks',
};

/// [stored] as a [TaskSource]: `<authority>/<list id>`. Null for the list on
/// the phone, which is stored as an empty string, and for anything else.
TaskSource? parseTaskSource(String? stored) {
  if (stored == null) return null;
  final slash = stored.lastIndexOf('/');
  if (slash <= 0 || slash == stored.length - 1) return null;
  final authority = stored.substring(0, slash);
  if (!taskAppNames.containsKey(authority)) return null;
  return (authority: authority, listId: stored.substring(slash + 1));
}

/// [source] the way [parseTaskSource] reads it.
String storeTaskSource(TaskSource? source) =>
    source == null ? '' : '${source.authority}/${source.listId}';

/// A task as the tasks app has it. [status] is OpenTasks': 0 to do, 1 in
/// progress, 2 completed, 3 cancelled. [repeats] when it has a recurrence
/// rule.
typedef ProviderTask = ({
  String id,
  String title,
  int status,
  String? parentId,
  int created,
  bool repeats,
});

/// The tasks of a list as the launcher shows them, in [order] (ids from
/// before): tasks it hasn't seen yet first, newest first.
///
/// A task with a parent is a subtask of its top-most ancestor, since the
/// launcher's subtasks are one level deep. Completed and cancelled tasks are
/// done.
List<Task> arrangeSynced(List<ProviderTask> rows, List<String> order) {
  final byId = {for (final row in rows) row.id: row};
  String topOf(ProviderTask row) {
    final seen = {row.id};
    var current = row;
    while (true) {
      final parent = byId[current.parentId];
      if (parent == null) return current.id;
      // Parents that go round in circles: then it's a task of its own.
      if (!seen.add(parent.id)) return row.id;
      current = parent;
    }
  }

  final rank = {for (var i = 0; i < order.length; i++) order[i]: i};
  int compare(ProviderTask a, ProviderTask b) {
    final (ra, rb) = (rank[a.id], rank[b.id]);
    if (ra != null && rb != null) return ra.compareTo(rb);
    if (ra != null) return 1;
    if (rb != null) return -1;
    return b.created.compareTo(a.created);
  }

  final heads = <ProviderTask>[];
  final subtasks = <String, List<ProviderTask>>{};
  for (final row in rows) {
    final top = topOf(row);
    if (top == row.id) {
      heads.add(row);
    } else {
      (subtasks[top] ??= []).add(row);
    }
  }
  heads.sort(compare);

  Task task(ProviderTask row, {required bool indented}) => Task(
    id: row.id,
    title: row.title,
    done: row.status == 2 || row.status == 3,
    indented: indented,
    repeats: row.repeats,
  );
  return [
    for (final head in heads) ...[
      task(head, indented: false),
      for (final sub in (subtasks[head.id] ?? <ProviderTask>[])..sort(compare))
        task(sub, indented: true),
    ],
  ];
}

/// One change to make in the tasks app. Only what changed is set; a null
/// [parentId] with [setsParent] makes it a task of its own.
class TaskChange {
  const TaskChange.insert(
    this.id, {
    required String this.title,
    required bool this.done,
    this.parentId,
  }) : op = 'insert',
       setsParent = parentId != null;

  const TaskChange.update(
    this.id, {
    this.title,
    this.done,
    this.parentId,
    this.setsParent = false,
  }) : op = 'update';

  const TaskChange.delete(this.id)
    : op = 'delete',
      title = null,
      done = null,
      parentId = null,
      setsParent = false;

  const TaskChange._(
    this.op,
    this.id, {
    this.title,
    this.done,
    this.parentId,
    this.setsParent = false,
  });

  /// This change with the ids in [ids] in place of the ones it names: for a
  /// task added here, the id the tasks app gave it since.
  TaskChange withIds(Map<String, String> ids) => TaskChange._(
    op,
    ids[id] ?? id,
    title: title,
    done: done,
    parentId: ids[parentId] ?? parentId,
    setsParent: setsParent,
  );

  /// insert, update or delete.
  final String op;

  /// The task's id; for an insert, one the launcher made up for it.
  final String id;
  final String? title;
  final bool? done;
  final String? parentId;
  final bool setsParent;

  Map<String, Object?> toMap() => {
    'op': op,
    'id': id,
    'title': ?title,
    'done': ?done,
    if (setsParent) 'parentId': parentId,
  };

  @override
  bool operator ==(Object other) =>
      other is TaskChange &&
      other.op == op &&
      other.id == id &&
      other.title == title &&
      other.done == done &&
      other.parentId == parentId &&
      other.setsParent == setsParent;

  @override
  int get hashCode => Object.hash(op, id, title, done, parentId, setsParent);

  @override
  String toString() => 'TaskChange${toMap()}';
}

/// What to change in the tasks app to turn [before] into [after]: inserts
/// and updates in [after]'s order, so a new task is there before its
/// subtasks, then deletes. The order of tasks isn't one of them.
List<TaskChange> syncedChanges(List<Task> before, List<Task> after) {
  final old = {for (final task in before) task.id: task};
  final oldParents = parentsOf(before);
  final newParents = parentsOf(after);
  final changes = <TaskChange>[];
  for (final task in after) {
    final was = old[task.id];
    final parent = newParents[task.id];
    if (was == null) {
      changes.add(
        TaskChange.insert(
          task.id,
          title: task.title,
          done: task.done,
          parentId: parent,
        ),
      );
      continue;
    }
    final movedParent = oldParents[task.id] != parent;
    if (was.title == task.title && was.done == task.done && !movedParent) {
      continue;
    }
    changes.add(
      TaskChange.update(
        task.id,
        title: was.title != task.title ? task.title : null,
        done: was.done != task.done ? task.done : null,
        parentId: movedParent ? parent : null,
        setsParent: movedParent,
      ),
    );
  }
  final kept = {for (final task in after) task.id};
  for (final task in before) {
    if (!kept.contains(task.id)) changes.add(TaskChange.delete(task.id));
  }
  return changes;
}

/// [tasks] without the done ones in [hidden]: what a synced list shows when
/// done tasks are hidden instead of deleted. A hidden task hides its
/// subtasks too.
List<Task> visibleTasks(List<Task> tasks, Set<String> hidden) {
  bool isHidden(Task task) => task.done && hidden.contains(task.id);
  final visible = <Task>[];
  var familyHidden = false;
  for (var i = 0; i < tasks.length; i++) {
    final task = tasks[i];
    final isHead = i == 0 || !task.indented;
    if (isHead) {
      // A done task with open subtasks, which another app can leave
      // behind, stays: they'd go with it.
      familyHidden =
          isHidden(task) && subtasksOf(tasks, task.id).every((t) => t.done);
    }
    if (isHead ? !familyHidden : !familyHidden && !isHidden(task)) {
      visible.add(task);
    }
  }
  return visible;
}

/// The ids in [hidden] still worth keeping: tasks in [tasks] that are done.
/// A task ticked back on somewhere else shows again.
Set<String> pruneHidden(Set<String> hidden, List<Task> tasks) => {
  for (final task in tasks)
    if (task.done && hidden.contains(task.id)) task.id,
};
