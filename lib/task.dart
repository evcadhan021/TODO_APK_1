class Task {
  String title;
  final int id;
  bool isDone;
  final int createdDate; // Pastikan menambahkan ini

  Task({
    required this.title,
    required this.id,
    required this.isDone,
    required this.createdDate, // Tambahkan ini
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'isDone': isDone,
      'createdDate': createdDate, // Tambahkan ini
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      id: json['id'],
      isDone: json['isDone'],
      createdDate: json['createdDate'], // Tambahkan ini
    );
  }
}
