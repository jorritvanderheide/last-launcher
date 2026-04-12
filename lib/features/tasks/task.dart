import 'dart:convert';

class Task {
  const Task({required this.id, required this.title});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['id'] as String, title: json['title'] as String);
  }

  final String id;
  final String title;

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  static List<Task> decodeList(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String encodeList(List<Task> tasks) {
    return jsonEncode(tasks.map((t) => t.toJson()).toList());
  }
}
