import 'package:flutter/material.dart';
import 'package:simple_todo/pages/add.dart';
import 'package:simple_todo/pages/home.dart';
// import 'package:get/get.dart';
// import 'package:simple_todo/controllers/todo_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Application',
      // home: Home(),
      routes: {
        "/": (context) => const Home(),
        "/add": (context) => AddTodo(),
      },
    );
  }
}