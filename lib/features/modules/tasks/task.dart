import 'dart:convert';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.done = false,
    this.indented = false,
    this.repeats = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) =>
      tryFromJson(json) ?? (throw const FormatException('Not a task'));

  /// Null for anything that isn't a task with an id, such as one in a
  /// shape another version stored. Other values that aren't what they
  /// should be read as unset.
  static Task? tryFromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    if (id is! String && id is! num) return null;
    final title = json['title'];
    return Task(
      id: '$id',
      title: title is String ? title : '',
      done: json['done'] == true,
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

  /// The tasks in [json], leaving out what isn't one. Throws
  /// [FormatException] when it isn't a list at all.
  static List<Task> decodeList(String json) {
    final list = jsonDecode(json);
    if (list is! List) throw const FormatException('Not a list');
    return [for (final entry in list) ?Task.tryFromJson(entry)];
  }

  static String encodeList(List<Task> tasks) {
    return jsonEncode(tasks.map((t) => t.toJson()).toList());
  }
}
