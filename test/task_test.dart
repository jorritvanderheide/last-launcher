import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/tasks/task.dart';

void main() {
  group('Task', () {
    test('creates with defaults', () {
      const task = Task(id: '1', title: 'Test');
      expect(task.done, false);
    });

    test('serializes to JSON', () {
      const task = Task(id: '1', title: 'Buy milk', done: true);
      final json = task.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Buy milk');
      expect(json['done'], true);
    });

    test('deserializes from JSON', () {
      final task = Task.fromJson({'id': '1', 'title': 'Test', 'done': true});
      expect(task.id, '1');
      expect(task.title, 'Test');
      expect(task.done, true);
    });

    test('deserializes with missing done field', () {
      final task = Task.fromJson({'id': '1', 'title': 'Test'});
      expect(task.done, false);
    });

    test('copyWith updates title', () {
      const task = Task(id: '1', title: 'Old');
      final updated = task.copyWith(title: 'New');
      expect(updated.title, 'New');
      expect(updated.id, '1');
      expect(updated.done, false);
    });

    test('copyWith updates done', () {
      const task = Task(id: '1', title: 'Test');
      final updated = task.copyWith(done: true);
      expect(updated.done, true);
      expect(updated.title, 'Test');
    });

    test('encodeList and decodeList roundtrip', () {
      final tasks = [
        const Task(id: '1', title: 'First'),
        const Task(id: '2', title: 'Second', done: true),
      ];
      final encoded = Task.encodeList(tasks);
      final decoded = Task.decodeList(encoded);
      expect(decoded.length, 2);
      expect(decoded[0].title, 'First');
      expect(decoded[1].done, true);
    });

    test('decodeList handles empty list', () {
      final decoded = Task.decodeList('[]');
      expect(decoded, isEmpty);
    });
  });
}
