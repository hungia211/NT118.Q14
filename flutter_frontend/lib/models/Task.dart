class Task {
  final String id;
  final String title;
  final String? description;
  final bool done;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.done = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }
}
