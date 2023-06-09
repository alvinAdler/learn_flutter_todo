import 'package:simple_todo/models/todo.dart';

class TodoRoute{
  final String type;
  final Todo? currentTodo;

  const TodoRoute({ required this.type, this.currentTodo });
}