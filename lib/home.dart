import 'package:flutter/material.dart';
import 'package:my_todo_app/SqlLite/dbmanager.dart';
import 'package:my_todo_app/model/todo_model.dart';
import 'package:my_todo_app/sqlLite/updateRecord.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    loadTodoData();
  }

  TextEditingController taskController = TextEditingController();
  List<TodoModel>? listofTodos;

  void loadTodoData() async {
    listofTodos = await DBmanager.instance.loadData();
  }

  void addRecord() async {
    String todotext = taskController.text;
    TodoModel model = TodoModel(title: todotext);
    await DBmanager.instance.adddata(model);

    setState(() {
      loadTodoData();
      taskController.clear();
    });
  }

  void deleteRecord(String id) {
    DBmanager.instance.deleteTodo(id);
    setState(() {
      loadTodoData();
    });
  }

  void updateRecord(TodoModel todo) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                updateTodoRecord(todo.title.toString(), todo)));
    setState(() {
      loadTodoData();
    });
  }

  Widget displayTodoRecords() {
    return FutureBuilder(
      future: DBmanager.instance.loadData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("No Data Available"),
          );
        } else if (snapshot.hasData) {
          return Column(
            children: listofTodos?.map((element) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(left: 0),
                        leading: Checkbox(
                          value: element.isCompleted,
                          onChanged: (bool? newValue) {
                            setState(() {
                              element.isCompleted = newValue ?? false;
                            });
                          },
                        ),
                        title: Text(
                          element.title.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: Wrap(children: [
                          IconButton(
                            onPressed: () {
                              updateRecord(element);
                            },
                            icon: const Icon(
                              Icons.edit_note,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteRecord(element.id.toString());
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 28,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          );
        } else {
          return const Center(
            child: Text("No Data Available"),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 62, 22, 131),
              Color.fromARGB(255, 52, 9, 128),
            ]),
          ),
        ),
        title: const Text('Todo App'),
        elevation: 0.5,
        toolbarHeight: 55,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addRecord();
        },
        hoverColor: Colors.purple,
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 62, 22, 131),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: displayTodoRecords(),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Container(
                width: 260,
                margin: const EdgeInsets.only(
                  bottom: 15,
                  right: 10,
                  left: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 83, 81, 81)),
                      hintText: 'Add new item',
                      border: InputBorder.none),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
