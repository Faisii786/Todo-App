import 'package:flutter/material.dart';
import 'package:my_todo_app/model/todo_model.dart';

import '../SqlLite/dbmanager.dart';


class updateTodoRecord extends StatefulWidget {
  final String title;
  final TodoModel todo;

  updateTodoRecord(this.title, this.todo);

  @override
  State<updateTodoRecord> createState() => _updateTodoRecordState();
}

class _updateTodoRecordState extends State<updateTodoRecord> {
  TextEditingController taskController = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskController.text = widget.todo.title;
  }

  void updateRecord(BuildContext context) async {
    String updatedText = taskController.text;
    TodoModel updatedModel = TodoModel(id: widget.todo.id, title: updatedText);

    await DBmanager.instance
        .updateTodo(widget.todo.id.toString(), updatedModel);

    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 62, 22, 131),
              Color.fromARGB(255, 52, 9, 128),
            ]),
          ),
          child: AlertDialog(
            title: const Text('Update Todo'),
            content: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: taskController,
                decoration: const InputDecoration(
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 83, 81, 81)),
                    hintText: '',
                    border: InputBorder.none),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    updateRecord(context);
                  },
                  child: Text("Update")),
            ],
          ),
        ));
  }
}
