import 'dart:convert';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.done = false,
    this.indented = false,
    this.repeats = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool? ?? false,
      // Older versions never stored it: anything but true is top level.
      indented: json['indented'] == true,
    );
  }

  final String id;
  final String title;
  final bool done;

  /// Whether this is a subtask of the nearest top-level task above it.
  final bool indented;

  /// Whether it repeats, which only a synced task can: it's ticked off in
  /// its own app, which knows the next time. Never stored here.
  final bool repeats;

  Task copyWith({String? title, bool? done, bool? indented}) => Task(
    id: id,
    title: title ?? this.title,
    done: done ?? this.done,
    indented: indented ?? this.indented,
    repeats: repeats,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'done': done,
    'indented': indented,
  };

  static List<Task> decodeList(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String encodeList(List<Task> tasks) {
    return jsonEncode(tasks.map((t) => t.toJson()).toList());
  }
}
