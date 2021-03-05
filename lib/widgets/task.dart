import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/resourses.dart';

class Task extends StatefulWidget {
  @override
  final ToDo task;
  final Function delete;
  int icon = 1;
  Task(this.task, this.delete);
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final dbHelper = DatabaseHelper.instance;
  String project = '';
  List<int> k = List();

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
      // width: MediaQuery.of(context).size.width * 0.75,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return CircularProgressIndicator();
          } else
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.delete(widget.task);
                            DatabaseHelper.instance
                                .delete(widget.task.toDoID, 'toDo');
                          });
                        },
                        child: Icon(
                            const IconData(59744,
                                fontFamily: 'MaterialIcons'),
                            color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.task.toDoName),
                            Text(
                              widget.task.toDoDate.day.toString() +
                                  '.' +
                                  widget.task.toDoDate.month.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  widget.task.toDoImportant == 0
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.task.toDoImportant == 2
                                  ? colorsForImportance[2]
                                  : colorsForImportance[1]),
                          height: 10,
                          width: 10,
                        )
                ],
              ),
            );
        },
        future: getKey(),
      ),
    );
  }
}
