import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/modules/tasks/synced_tasks.dart';
import 'package:last_launcher/features/modules/tasks/task.dart';

ProviderTask _row(
  String id, {
  String? parent,
  int status = 0,
  int created = 0,
  String? title,
  bool repeats = false,
}) => (
  id: id,
  title: title ?? id,
  status: status,
  parentId: parent,
  created: created,
  repeats: repeats,
);

/// [tasks] as a sketch: `- ` for a subtask, ` x` for done.
List<String> _sketch(Iterable<Task> tasks) => [
  for (final t in tasks)
    '${t.indented ? '- ' : ''}${t.title}${t.done ? ' x' : ''}',
];

void main() {
  group('source', () {
    test('a list in a tasks app round-trips', () {
      const source = (authority: 'org.tasks.opentasks', listId: '7');
      expect(storeTaskSource(source), 'org.tasks.opentasks/7');
      expect(parseTaskSource(storeTaskSource(source)), source);
    });

    test('anything else is the list on the phone', () {
      expect(storeTaskSource(null), '');
      for (final stored in [null, '', '/7', 'org.tasks.opentasks/', 'x/7']) {
        expect(parseTaskSource(stored), isNull, reason: '$stored');
      }
    });
  });

  group('arranging', () {
    test('keeps the order from before, with new tasks first', () {
      final rows = [
        _row('a', created: 1),
        _row('b', created: 2),
        _row('new', created: 3),
        _row('newer', created: 4),
      ];
      expect(_sketch(arrangeSynced(rows, ['b', 'a'])), [
        'newer',
        'new',
        'b',
        'a',
      ]);
    });

    test('a subtask follows its task, deeper ones its top-most task', () {
      final rows = [
        _row('grandchild', parent: 'child'),
        _row('child', parent: 'top'),
        _row('top'),
        _row('other'),
      ];
      expect(
        _sketch(arrangeSynced(rows, ['top', 'child', 'grandchild', 'other'])),
        ['top', '- child', '- grandchild', 'other'],
      );
    });

    test('a subtask whose task is gone is a task of its own', () {
      expect(_sketch(arrangeSynced([_row('orphan', parent: 'gone')], [])), [
        'orphan',
      ]);
    });

    test('parents going round in circles leave every task in', () {
      final rows = [_row('a', parent: 'b'), _row('b', parent: 'a')];
      expect(arrangeSynced(rows, ['a', 'b']), hasLength(2));
    });

    test('completed and cancelled tasks are done', () {
      final rows = [
        _row('todo'),
        _row('busy', status: 1),
        _row('done', status: 2),
        _row('cancelled', status: 3),
      ];
      final order = ['todo', 'busy', 'done', 'cancelled'];
      expect(_sketch(arrangeSynced(rows, order)), [
        'todo',
        'busy',
        'done x',
        'cancelled x',
      ]);
    });
  });

  group('changes', () {
    const shop = Task(id: '1', title: 'Shop');
    const milk = Task(id: '2', title: 'Milk', indented: true);
    const call = Task(id: '3', title: 'Call');

    test('nothing for a list that only moved', () {
      expect(syncedChanges([shop, milk, call], [call, shop, milk]), isEmpty);
    });

    test('only what changed is sent', () {
      expect(
        syncedChanges(
          [shop, call],
          [shop.copyWith(title: 'Shopping'), call.copyWith(done: true)],
        ),
        [
          const TaskChange.update('1', title: 'Shopping'),
          const TaskChange.update('3', done: true),
        ],
      );
    });

    test('a new subtask is inserted after its new task', () {
      const errand = Task(id: 'n1', title: 'Errand');
      const stamps = Task(id: 'n2', title: 'Stamps', indented: true);
      expect(syncedChanges([call], [errand, stamps, call]), [
        const TaskChange.insert('n1', title: 'Errand', done: false),
        const TaskChange.insert(
          'n2',
          title: 'Stamps',
          done: false,
          parentId: 'n1',
        ),
      ]);
    });

    test('indenting and outdenting set the parent', () {
      expect(
        syncedChanges([shop, call], [shop, call.copyWith(indented: true)]),
        [const TaskChange.update('3', parentId: '1', setsParent: true)],
      );
      expect(
        syncedChanges([shop, milk], [shop, milk.copyWith(indented: false)]),
        [const TaskChange.update('2', setsParent: true)],
      );
    });

    test('removed tasks are deleted', () {
      expect(syncedChanges([shop, milk, call], [call]), [
        const TaskChange.delete('1'),
        const TaskChange.delete('2'),
      ]);
    });

    test('take the ids tasks added here got since', () {
      const change = TaskChange.update('n2', parentId: 'n1', setsParent: true);
      expect(
        change.withIds({'n1': '100', 'n2': '101'}),
        const TaskChange.update('101', parentId: '100', setsParent: true),
      );
      expect(change.withIds({}), change);
    });

    test('are sent with only what they set', () {
      expect(const TaskChange.update('3', done: true).toMap(), {
        'op': 'update',
        'id': '3',
        'done': true,
      });
      expect(const TaskChange.update('2', setsParent: true).toMap(), {
        'op': 'update',
        'id': '2',
        'parentId': null,
      });
    });
  });

  group('hiding', () {
    const shop = Task(id: '1', title: 'Shop', done: true);
    const milk = Task(id: '2', title: 'Milk', done: true, indented: true);
    const call = Task(id: '3', title: 'Call');
    const post = Task(id: '4', title: 'Post', done: true, indented: true);

    test('a hidden task hides its subtasks', () {
      expect(_sketch(visibleTasks([shop, milk, call], {'1'})), ['Call']);
    });

    test('a hidden subtask goes by itself', () {
      expect(_sketch(visibleTasks([call, post], {'4'})), ['Call']);
    });

    test('only done tasks hide', () {
      expect(_sketch(visibleTasks([call], {'3'})), ['Call']);
    });

    test('a done task with open subtasks stays, with them', () {
      const open = Task(id: '5', title: 'Cancel internet', indented: true);
      expect(_sketch(visibleTasks([shop, open, call], {'1'})), [
        'Shop x',
        '- Cancel internet',
        'Call',
      ]);
    });

    test('a task ticked back on, or gone, is no longer hidden', () {
      expect(pruneHidden({'1', '3', 'gone'}, [shop, call]), {'1'});
    });
  });
}
