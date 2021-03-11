import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';

import 'dbhelper.dart';

class Information {
  int countOfTasks = 0;
  List<ToDo> tasks = [];
  List<Project> proj = [];

  Information() {
    Future help() {}
    
    // Future<bool> help() async {
    //   await DatabaseHelper.instance
    //       .queryAllRows('project')
    //       .then((value) => value.forEach((element) {
    //             proj.add(Project.fromMap(element));
    //           }
    //           ))
    //       .then(
    //     await DatabaseHelper.instance
    //         .queryAllRows('toDo')
    //         .then((value) => value.forEach((element) {
    //               tasks.insert(0, ToDo.fromMap(element));
    //             }))
    //         .whenComplete(() => true);
    //   });

    // }

    // bool h = await help().;
  }

  int get countOfAllTasks {
    return countOfTasks;
  }

  int countTasksOfProkect(int p) {}
}
