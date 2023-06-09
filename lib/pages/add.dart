import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_todo/controllers/todo_controller.dart';
import 'package:simple_todo/helpers/functions.dart';
import 'package:simple_todo/models/todo.dart';
import 'package:simple_todo/models/todo_route.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {

  String currentTitle = "";
  bool currentCompletion = false;
  int userId = -1;
  int id = -1;

  final TodoController controller = Get.put(TodoController());
  final TextEditingController textfieldController = TextEditingController();

  void takeActionTodo(String currentMode) async {

    bool result = false;

    switch(currentMode){
      case "edit":
        result = await controller.editTodo(Todo(userId: userId, id: id, title: currentTitle, completed: currentCompletion));
        break;
      case "add":
        result = await controller.addTodo(currentTitle, currentCompletion);
      default:
        break;
    }


    if(context.mounted && result){
      await showDialog(context: context, builder: (_) => SimpleDialog(
        title: Text("Todo has been ${currentMode == 'add' ? 'addded' : 'edited'}!"),
        children: [
          SimpleDialogOption(child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Ok")),)
        ],
      ));
    }

    if(context.mounted){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    final TodoRoute routeData = ModalRoute.of(context)?.settings.arguments as TodoRoute;
    final String currentMode = routeData.type;


    if(routeData.currentTodo != null && currentTitle == ""){
      textfieldController.text = routeData.currentTodo?.title ?? "";
      setState(() {
        currentTitle = routeData.currentTodo?.title ?? "";
        currentCompletion = routeData.currentTodo?.completed ?? false;
        userId = routeData.currentTodo?.userId ?? -1;
        id = routeData.currentTodo?.id ?? -1;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("${camelize(currentMode)} Todo")),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: double.infinity,
        child: Column(children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: textfieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Todo title")
                  ),
                  onChanged: (String value) => setState(() {
                    currentTitle = value;
                  }),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const Text("Is completed?"),
                    Switch(value: currentCompletion, onChanged: (bool current) => setState(() {
                      currentCompletion = current;
                    }))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => takeActionTodo(currentMode), 
              icon: currentMode == "add" ? const Icon(Icons.add) : const Icon(Icons.edit), 
              label: Text(camelize(currentMode)),
            )
          )
        ]),
      ),
    );
  }
}