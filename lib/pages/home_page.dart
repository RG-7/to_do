import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';
import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToDoDataBase db = ToDoDataBase();
  // reference the hive box
  final _myBox = Hive.box('mybox');
  // text controller
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    // if this is the forst tiome ever opening thye app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitalData();
    } else {
      // if the data is already there, then get it
      db.loadData();
    }
    super.initState();
  }

  // checkbox was tapped
  void checkBoxChanged(bool value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // dispose
  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  // crate a new task
  void createANewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: taskController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    taskController.clear();
  }

  // save a new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([taskController.text, false]);
    });
    db.updateDataBase();
    Navigator.of(context).pop();
  }

  // void ndelete the task
  void deleteTheTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('To Do'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => createANewTask(),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value!, index),
            deleteFunction: (context) => deleteTheTask(index),
          );
        },
      ),
    );
  }
}
