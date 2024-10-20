import 'package:hive/hive.dart';

class ToDoDataBase {
  // list
  List toDoList = [];

  // refernce our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever openning this app
  void createInitalData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Exercise", false],
    ];
  }

  // load the data from the database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }
}
