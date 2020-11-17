import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskForMain extends StatefulWidget {
  String task;
  DateTime time;
  double width;
  TaskForMain(this.task, this.time, this.width);

  @override
  _TaskForMainState createState() => _TaskForMainState();
}

class _TaskForMainState extends State<TaskForMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: widget.width * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.check_circle),
                Text(DateFormat('HH:mm').format(widget.time)),
              ],
            ),
          ),
          Container(width: widget.width * 0.6, child: Text(widget.task)),
        ],
      ),
    );
  }
}
