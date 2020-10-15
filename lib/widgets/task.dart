import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';

class Task extends StatefulWidget {
  @override
  ToDo t;
  Task(this.t);
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.t.name),

    );
  }
}