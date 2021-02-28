import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';

import 'dbhelper.dart';

class HelperFunctions {
  List<ToDo> _tasks = [];
  // List<Project> _proj = [];
  static Future<List<Project>> listOfProjects() async {
    List<Project> proj = [];
    bool isDone = false;
    await DatabaseHelper.instance
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              // print(element['name']);
              proj.add(Project.fromMap(element));
            }))
        .whenComplete(() {
      isDone = true;
    });
    if (isDone) return proj;
  }

  static Future<List<ToDo>> listOfTasks() async {
    List<ToDo> todo = [];
    bool isDone = false;
    await DatabaseHelper.instance
        .queryAllRows('toDo')
        .then((value) => value.forEach((element) {
              todo.insert(0, ToDo.fromMap(element));
            }))
        .whenComplete(() {
      isDone = true;
    });
    if (isDone) return todo;
  }

  
}
