import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_todo/components/todo_card.dart';
import 'package:simple_todo/controllers/todo_controller.dart';
import 'package:simple_todo/models/todo_route.dart';

import '../models/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TodoController controller = Get.put(TodoController());

  void getInitData(){
    controller.getTodos();
  }

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  void onTapTodo(Todo tappedTodo){
    print(tappedTodo.title);
    Navigator.pushNamed(context, "/add", arguments: TodoRoute(type: "edit", currentTodo: tappedTodo));
  }

  Widget getWidget(){

    if(controller.isFetchingTodos.value){
      return const Center(child: Text("Fetching todos"),);
    }

    if(controller.isErrorTodos.value){
      return const Center(child: Text("Failed fetching todo list"));
    }

    if(controller.todosList.value.isNotEmpty){
      return ListView.builder(
        itemCount: controller.todosList.value.length,
        itemBuilder: (context, index){
          final currentItem = controller.todosList.value[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              bool result = await controller.deleteTodo(currentItem.id);
              if(result && context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully deleted todo")));
              }
            },
            background: Container(color: Colors.red),
            child: TodoCard(currentTodo: currentItem, onTapTodo: onTapTodo,)
          );
        },
      );
    }
    return const Center(child: Text("The list is empty"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo Application"),),
      body: Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: Obx(() => getWidget())),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/add", arguments: const TodoRoute(type: "add"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}