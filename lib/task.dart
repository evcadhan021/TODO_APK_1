class Task {
  String title;
  bool isDone;
  final int? id;

  Task({required this.title, required this.isDone, required this.id});
  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone};
  }

  // Convert JSON to Task
  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
      id: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
