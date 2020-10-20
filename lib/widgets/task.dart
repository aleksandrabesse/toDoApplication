import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';

class Task extends StatefulWidget {
  @override
  final ToDo task;
  final Function delete;
  Task(this.task, this.delete);
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  String project = '';
  String getProject() {
    if (widget.task.toDoProj == 0)
      return 'Учеба';
    else
      return 'Входящие';
  }

  @override
  Widget build(BuildContext context) {
    int _color = widget.task.toDoImportant;
    return GestureDetector(
      onLongPress: () {
        widget.delete(widget.task);
        DatabaseHelper.instance.delete(widget.task.toDoID);
      },
      child: ListTile(
        subtitle: Text(widget.task.toDoDate.day.toString() +
            '.' +
            widget.task.toDoDate.month.toString()),
        title: Text(widget.task.toDoName),
        trailing: GestureDetector(
            child: Container(
          constraints: BoxConstraints(
            maxWidth: 0.3 * MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
            minWidth: 0.1 * MediaQuery.of(context).size.width,
          ),
          padding: EdgeInsets.all(2.5),
          child: Text(
            getProject(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(166, 71, 36, 65),
            border:
                Border.all(color: Color.fromRGBO(166, 71, 36, 65), width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
        )),
        leading: GestureDetector(
          onTap: () {},
          child: LayoutBuilder(
            builder: (build, constraint) {
              return Container(
                margin: EdgeInsets.only(left: 5.0),
                height: MediaQuery.of(build).size.height,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: _color == 0
                          ? Color.fromRGBO(166, 137, 103, 65)
                          : _color == 1
                              ? Color.fromRGBO(79, 115, 2, 45)
                              : _color == 2
                                  ? Color.fromRGBO(242, 116, 5, 95)
                                  : Color.fromRGBO(191, 54, 4, 75),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
