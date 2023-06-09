import 'package:flutter/material.dart';
import 'package:simple_todo/models/todo.dart';

class TodoCard extends StatefulWidget {
  final Todo currentTodo;
  final Function(Todo targetTodo) onTapTodo;

  const TodoCard({super.key, required this.currentTodo, required this.onTapTodo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {

  Widget renderCompletionIcon(){
    return Icon(
      widget.currentTodo.completed ? Icons.check : Icons.close, 
      color: widget.currentTodo.completed ? Colors.green.shade400 : Colors.red.shade400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: ListTile(
        title: Text(widget.currentTodo.title),
        leading: renderCompletionIcon(),
        onTap: (){
          widget.onTapTodo(widget.currentTodo);
        },
      ),
    );
  }
}