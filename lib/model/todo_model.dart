class TodoModel {
  int? id;
  String title;
  bool isCompleted;

  TodoModel({
    this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
