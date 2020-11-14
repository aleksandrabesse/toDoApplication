import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskForMain extends StatelessWidget {
  String task;
  DateTime time;
  double width;
  TaskForMain(this.task, this.time, this.width);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: width * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.check_circle),
                Text(DateFormat('HH:mm').format(time)),
              ],
            ),
          ),
          Container(width: width * 0.6, child: Text(task)),
        ],
      ),
    );
  }
}
