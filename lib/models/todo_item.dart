/* 
{
  userId: 1,
  id: 1,
  title: "delectus aut autem",
  completed: false
}
*/

class TodoItem {
  final int userId;
  final int id;
  final String title;
  bool completed;

  TodoItem({
    required this.userId,
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
