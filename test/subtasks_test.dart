import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/tasks/subtasks.dart';
import 'package:last_launcher/features/modules/tasks/task.dart';

/// Tasks from a sketch: a leading `-` makes a subtask, a trailing `x` a done
/// task. The title doubles as the id.
List<Task> _tasks(List<String> sketch) => [
  for (final line in sketch)
    Task(
      id: line.replaceAll(RegExp(r'^- | x$'), ''),
      title: line.replaceAll(RegExp(r'^- | x$'), ''),
      indented: line.startsWith('- '),
      done: line.endsWith(' x'),
    ),
];

/// [tasks] back as a sketch.
List<String> _sketch(Iterable<Task> tasks) => [
  for (final t in tasks)
    '${t.indented ? '- ' : ''}${t.title}${t.done ? ' x' : ''}',
];

void main() {
  group('groups', () {
    test('a family is done when its top-level task is', () {
      final groups = taskGroups(
        _tasks(['Shop x', '- Milk x', 'Call', '- Dial', '- Talk x']),
      );
      expect(_sketch(groups.todo), ['Call', '- Dial', '- Talk x']);
      expect(_sketch(groups.done), ['Shop x', '- Milk x']);
    });

    test('a subtask with nothing above it is shown at the top level', () {
      final groups = taskGroups(_tasks(['- Lost', '- Found']));
      expect(_sketch(groups.todo), ['Lost', '- Found']);
    });
  });

  group('ticking off', () {
    final tasks = _tasks(['Shop', '- Milk', '- Eggs x', 'Call']);

    test('a task takes its subtasks along', () {
      final done = toggleTask(tasks, 'Shop');
      expect(_sketch(done), ['Shop x', '- Milk x', '- Eggs x', 'Call']);
      expect(_sketch(toggleTask(done, 'Shop')), [
        'Shop',
        '- Milk',
        '- Eggs',
        'Call',
      ]);
    });

    test('a subtask is ticked off by itself', () {
      expect(_sketch(toggleTask(tasks, 'Milk')), [
        'Shop',
        '- Milk x',
        '- Eggs x',
        'Call',
      ]);
    });

    test('a subtask put back on puts its task back on too', () {
      final done = _tasks(['Shop x', '- Milk x', '- Eggs x']);
      expect(_sketch(toggleTask(done, 'Eggs')), ['Shop', '- Milk x', '- Eggs']);
    });

    test('an unknown task changes nothing', () {
      expect(toggleTask(tasks, 'Nope'), same(tasks));
    });
  });

  group('clearing done tasks', () {
    test('removes them with their subtasks', () {
      final tasks = _tasks(['Shop x', '- Milk x', 'Call', '- Dial x']);
      expect(_sketch(withoutDone(tasks)), ['Call']);
    });

    test('keeps a done task that still has open subtasks', () {
      final tasks = _tasks(['Other', 'Move x', '- Cancel', '- Pack x']);
      expect(_sketch(withoutDone(tasks)), ['Other', 'Move x', '- Cancel']);
    });

    test("keeps what it's told to, and the task that holds it", () {
      final tasks = _tasks(['Old x', 'Move x', '- Pack x', 'Call x']);
      final kept = withoutDone(
        tasks,
        keep: (t) => {'Old', 'Pack'}.contains(t.id),
      );
      expect(_sketch(kept), ['Old x', 'Move x', '- Pack x']);
    });
  });

  group('removing', () {
    final tasks = _tasks(['Shop', '- Milk', '- Eggs', 'Call']);

    test('a task goes with its subtasks', () {
      expect(_sketch(removeTask(tasks, 'Shop')), ['Call']);
    });

    test('a subtask goes by itself', () {
      expect(_sketch(removeTask(tasks, 'Milk')), ['Shop', '- Eggs', 'Call']);
    });

    test('an unknown task changes nothing', () {
      expect(removeTask(tasks, 'Nope'), same(tasks));
    });
  });

  group('moving', () {
    final tasks = _tasks(['Shop', '- Milk', '- Eggs', 'Call', 'Write']);

    List<String> move(String id, String? after, {bool indent = false}) =>
        _sketch(moveTask(tasks, id, after: after, indent: indent));

    test('a task moves with its subtasks', () {
      expect(move('Shop', 'Call'), [
        'Call',
        'Shop',
        '- Milk',
        '- Eggs',
        'Write',
      ]);
      expect(move('Write', null), [
        'Write',
        'Shop',
        '- Milk',
        '- Eggs',
        'Call',
      ]);
    });

    test('dragged sideways in place, a task becomes a subtask', () {
      expect(move('Call', 'Eggs', indent: true), [
        'Shop',
        '- Milk',
        '- Eggs',
        '- Call',
        'Write',
      ]);
    });

    test('a task made a subtask brings its own subtasks along', () {
      final tasks = _tasks(['Call', 'Shop', '- Milk']);
      expect(_sketch(moveTask(tasks, 'Shop', after: 'Call', indent: true)), [
        'Call',
        '- Shop',
        '- Milk',
      ]);
    });

    test('the first task stays top level', () {
      expect(move('Shop', null, indent: true), _sketch(tasks));
    });

    test('a subtask moved out lands below the rest of its family', () {
      expect(move('Milk', 'Shop'), ['Shop', '- Eggs', 'Milk', 'Call', 'Write']);
    });

    test('a task never lands between a task and its subtasks', () {
      expect(move('Write', 'Milk'), [
        'Shop',
        '- Milk',
        '- Eggs',
        'Write',
        'Call',
      ]);
    });

    test('a subtask can move to another task', () {
      expect(move('Milk', 'Call', indent: true), [
        'Shop',
        '- Eggs',
        'Call',
        '- Milk',
        'Write',
      ]);
    });

    test('dropped among its own subtasks, a task only changes its indent', () {
      expect(move('Shop', 'Milk'), _sketch(tasks));
    });

    test('a task moves within its own group', () {
      final tasks = _tasks(['Shop x', 'Call', 'Write x']);
      expect(_sketch(moveTask(tasks, 'Write', after: null, indent: false)), [
        'Call',
        'Write x',
        'Shop x',
      ]);
    });

    test('a ticked-off subtask moved out joins the done tasks', () {
      final tasks = _tasks(['Shop', '- Milk x', 'Call']);
      final moved = moveTask(tasks, 'Milk', after: 'Shop', indent: false);
      expect(_sketch(taskGroups(moved).todo), ['Shop', 'Call']);
      expect(_sketch(taskGroups(moved).done), ['Milk x']);
    });

    test('an unknown task changes nothing', () {
      expect(moveTask(tasks, 'Nope', after: null, indent: false), same(tasks));
    });
  });

  test('a family moving along is the subtasks of a top-level task', () {
    final tasks = _tasks(['Shop', '- Milk', '- Eggs', 'Call']);
    expect(_sketch(subtasksOf(tasks, 'Shop')), ['- Milk', '- Eggs']);
    expect(subtasksOf(tasks, 'Milk'), isEmpty);
    expect(subtasksOf(tasks, 'Call'), isEmpty);
    expect(subtasksOf(tasks, 'Nope'), isEmpty);
  });

  group('indenting in place', () {
    final tasks = _tasks(['Shop', '- Milk', '- Eggs', 'Call', 'Write x']);

    List<String> indent(String id, bool indent) =>
        _sketch(indentTask(tasks, id, indent: indent));

    test('a task becomes a subtask of the task above it in its group', () {
      expect(indent('Call', true), [
        'Shop',
        '- Milk',
        '- Eggs',
        '- Call',
        'Write x',
      ]);
    });

    test('a subtask becomes a task below the rest of its family', () {
      expect(indent('Milk', false), [
        'Shop',
        '- Eggs',
        'Milk',
        'Call',
        'Write x',
      ]);
    });

    test('the first task of a group stays top level', () {
      expect(indent('Write', true), _sketch(tasks));
      expect(indent('Shop', true), _sketch(tasks));
    });

    test('when some are hidden, goes under the task shown above it', () {
      final tasks = _tasks(['Shop x', 'Old x', 'Call x']);
      final shown = _tasks(['Shop x', 'Call x']);
      expect(_sketch(indentTask(tasks, 'Call', indent: true, shown: shown)), [
        'Shop x',
        '- Call x',
        'Old x',
      ]);
    });

    test('an indent it already has, or an unknown task, changes nothing', () {
      expect(indentTask(tasks, 'Milk', indent: true), same(tasks));
      expect(indentTask(tasks, 'Nope', indent: true), same(tasks));
    });
  });

  group('drop position', () {
    final rows = _tasks(['A', 'B', 'C', 'D']);

    test('is below the row above the gap', () {
      expect(rowAbove(rows, 0, 3), 'C');
      expect(rowAbove(rows, 3, 1), 'A');
      expect(rowAbove(rows, 3, 0), isNull);
    });

    test('in place, is below the row that was above it', () {
      expect(rowAbove(rows, 2, 2), 'B');
      expect(rowAbove(rows, 2, 3), 'B');
      expect(rowAbove(rows, 0, 1), isNull);
    });
  });

  group('sideways drag', () {
    test('a task becomes a subtask once dragged far enough right', () {
      expect(indentAfterDrag(wasIndented: false, dx: 10), isFalse);
      expect(
        indentAfterDrag(wasIndented: false, dx: indentDragThreshold),
        isTrue,
      );
      expect(indentAfterDrag(wasIndented: false, dx: -100), isFalse);
    });

    test('a subtask stays one until dragged far enough left', () {
      expect(indentAfterDrag(wasIndented: true, dx: -10), isTrue);
      expect(indentAfterDrag(wasIndented: true, dx: 100), isTrue);
      expect(
        indentAfterDrag(wasIndented: true, dx: -indentDragThreshold - 1),
        isFalse,
      );
    });
  });
}
