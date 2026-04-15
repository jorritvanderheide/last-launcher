import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TaskState state;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    state = TaskState(prefs);
  });

  group('TaskState', () {
    test('starts empty', () {
      expect(state.tasks, isEmpty);
    });

    test('adds task to the top', () {
      state.addTask('First');
      state.addTask('Second');
      expect(state.tasks.length, 2);
      expect(state.tasks[0].title, 'Second');
      expect(state.tasks[1].title, 'First');
    });

    test('toggles task done state', () {
      state.addTask('Test');
      final id = state.tasks.first.id;
      expect(state.tasks.first.done, false);

      state.toggleTask(id);
      expect(state.tasks.first.done, true);

      state.toggleTask(id);
      expect(state.tasks.first.done, false);
    });

    test('toggle with invalid id does nothing', () {
      state.addTask('Test');
      state.toggleTask('nonexistent');
      expect(state.tasks.length, 1);
    });

    test('renames task', () {
      state.addTask('Old name');
      final id = state.tasks.first.id;
      state.renameTask(id, 'New name');
      expect(state.tasks.first.title, 'New name');
    });

    test('rename with invalid id does nothing', () {
      state.addTask('Test');
      state.renameTask('nonexistent', 'New');
      expect(state.tasks.first.title, 'Test');
    });

    test('removes task', () {
      state.addTask('Test');
      final id = state.tasks.first.id;
      state.removeTask(id);
      expect(state.tasks, isEmpty);
    });

    test('remove with invalid id does nothing', () {
      state.addTask('Test');
      state.removeTask('nonexistent');
      expect(state.tasks.length, 1);
    });

    test('reorders tasks', () {
      state.addTask('C');
      state.addTask('B');
      state.addTask('A');
      expect(state.tasks.map((t) => t.title).toList(), ['A', 'B', 'C']);

      state.reorder(0, 2);
      expect(state.tasks.map((t) => t.title).toList(), ['B', 'A', 'C']);
    });

    test('reorder same index does nothing', () {
      state.addTask('B');
      state.addTask('A');
      state.reorder(0, 0);
      expect(state.tasks.map((t) => t.title).toList(), ['A', 'B']);
    });

    test('notifies listeners on changes', () {
      var count = 0;
      state.addListener(() => count++);

      state.addTask('Test');
      expect(count, 1);

      state.toggleTask(state.tasks.first.id);
      expect(count, 2);

      state.renameTask(state.tasks.first.id, 'New');
      expect(count, 3);

      state.removeTask(state.tasks.first.id);
      expect(count, 4);
    });

    test('persists and restores tasks', () async {
      state.addTask('Persisted');
      final id = state.tasks.first.id;
      state.toggleTask(id);

      // Wait for save.
      await Future<void>.delayed(Duration.zero);

      final prefs = await SharedPreferences.getInstance();
      final restored = TaskState(prefs);
      expect(restored.tasks.length, 1);
      expect(restored.tasks.first.title, 'Persisted');
      expect(restored.tasks.first.done, true);
    });
  });
}
