// import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_todo/helpers/functions.dart';
import 'package:simple_todo/models/todo.dart';
// import 'package:http/http.dart';

class TodoController extends GetxController{

  var todosList = Rx<List<Todo>>([]);
  var isFetchingTodos = Rx<bool>(false);
  var isErrorTodos = Rx<bool>(false);

  var isFetchingAdding = Rx<bool>(false);
  var isErrorAdding = Rx<bool>(false);

  var isFetchingEditing = Rx<bool>(false);
  var isErrorEditing = Rx<bool>(false);

  var isFetchingDeleting = Rx<bool>(false);
  var isErrorDeleting = Rx<bool>(false);

  final GetConnect connect = GetConnect();

  void getTodos() async {
    isFetchingTodos.value = true;
    try{
      final Response res = await connect.get("https://jsonplaceholder.typicode.com/todos");
      isFetchingTodos.value = false;
      // final Response res = await get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

      // List<dynamic> data = jsonDecode(res.body);

      if(res.statusCode != 200){
        isErrorTodos.value = true;
        throw Exception("Failed to make request");
      }

      // todosList.value = (res.body as List<dynamic>).map<Todo>((e) => Todo.fromjson(e)).toList();
      todosList.value = res.body.map<Todo>((e) => Todo.fromjson(e)).toList();
    }
    catch(err){
      print("Error while accessing todos list");
      print(err);
    }
  }

  Future<bool> addTodo(String title, bool completed) async {
    isFetchingAdding.value = true;

    final int userId = generateRandomNumber(min: 1000);

    try{
      final Response response = await connect.post("https://jsonplaceholder.typicode.com/todos", {
        "userId": userId,
        "title": title,
        "completed": completed
      });

      if(response.statusCode != 200 && response.statusCode != 201){
        isErrorAdding.value = true;
        throw Exception("Failed to make post request to add todo");
      }

      todosList.value.insert(0, Todo.fromjson(response.body));
      todosList.refresh();

      return true;
    }
    catch(err){
      isFetchingAdding.value = false;
      print("Failure when adding a todo");
      print(err);
    }

    return false;
  }

  Future<bool> editTodo(Todo todo) async {
    isFetchingEditing.value = true;

    try{
      final Response response = await connect.put("https://jsonplaceholder.typicode.com/todos/${todo.id}", {
        "userId": todo.userId,
        "title": todo.title,
        "completed": todo.completed,
        "id": todo.id
      });
      isFetchingEditing.value = false;

      if(response.statusCode != 200 && response.statusCode != 201){
        isErrorEditing.value = true;
        throw Exception("Failed to make put request to edit todo");
      }

      final Todo targetTodo = Todo.fromjson(response.body);

      todosList.value = todosList.value.map<Todo>((e){
        if(e.id == targetTodo.id){
          return targetTodo;
        }
        return e;
      }).toList();

      todosList.refresh();

      return true;
    }
    catch(err){
      isFetchingEditing.value = false;
      print("Failure when editing a todo");
      print(err);
    }

    return false;
  }

  Future<bool> deleteTodo(int todoId) async{
    try{
      isFetchingDeleting.value = true;

      Response res = await connect.delete("https://jsonplaceholder.typicode.com/todos/$todoId");
      isFetchingDeleting.value = false;

      if(res.statusCode != 200){
        isErrorDeleting.value = true;
        throw Exception("Failed to make request to delete todo with id: $todoId");
      }

      todosList.value = todosList.value.where((todo) => todo.id != todoId).toList();
      todosList.refresh();

      print(todosList.value.length);

      return true;

    }
    catch(err){
      isFetchingDeleting.value = false;
      print("Failed to delete todo");
      print(err);
    }

    return false;
  }

}