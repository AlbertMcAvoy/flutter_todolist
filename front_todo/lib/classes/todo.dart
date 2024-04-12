class Todo {
  int id;
  String name;
  String description;
  bool isCompleted;

  Todo ({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.isCompleted = false
  });

  Todo.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      name = data['name'],
      description = data['description'],
      isCompleted = data['isCompleted'];
}