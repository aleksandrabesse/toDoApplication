import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';

class Task extends StatefulWidget {
  @override
  final ToDo task;
  final Function delete;
  int icon=1;
  Task(this.task, this.delete) {}
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final dbHelper = DatabaseHelper.instance;
  String project = '';
  List<int> k = List();
  void initState() {
// dbHelper.getForeignKey(widget.task.toDoID).then((value) => print(value[0]['icon'].toString() + widget.task.toDoName));
    super.initState();
  }

  Future<void> getKey() async {
    dbHelper.getForeignKey(widget.task.toDoID).then((value) {
      setState(() {
        widget.icon = value[0]['icon'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.093,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return CircularProgressIndicator();
          } else
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  widget.delete(widget.task);
                  DatabaseHelper.instance.delete(widget.task.toDoID, 'toDo');
                });
              },
              child: ListTile(
                subtitle: Text(widget.task.toDoDate.day.toString() +
                    '.' +
                    widget.task.toDoDate.month.toString()),
                title: Text(widget.task.toDoName),
                trailing:
                    Icon(IconData(widget.icon, fontFamily: 'MaterialIcons')),
                leading: GestureDetector(
                  onTap: () {
                    if (widget.icon == -1) print(12);
                    print(widget.icon);
                  },
                  child: Icon(IconData(59744, fontFamily: 'MaterialIcons'),
                      color: widget.task.toDoImportant == 3
                          ? Colors.red
                          : widget.task.toDoImportant == 2
                              ? Colors.orange
                              : widget.task.toDoImportant == 1
                                  ? Colors.green
                                  : Colors.grey),
                ),
              ),
            );
        },
        future: getKey(),
      ),
    );
  }
}
