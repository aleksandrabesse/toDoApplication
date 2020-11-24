import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/task.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/resourses.dart';

class SecondRoute extends StatefulWidget {
  AppBar appBar;
  List<Color> colors;
  List<ToDo> tasks;
  Project current;
  SecondRoute(this.current, this.appBar, this.colors, this.tasks);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<ToDo> needed = [];
  int count;
  String text = '';
  void getFuture() async {
    await DatabaseHelper.instance
        .queryRowProjCount('toDo', widget.current.getIdProj)
        .then((value) {
      print(value);
      setState(() {
        count = value;
        text = count.toString() + getTask(count);
      });
    });
  }

  initState() {
    getFuture();
    widget.tasks.forEach((element) {
      if (element.toDoProj == widget.current.getIdProj) needed.add(element);
    });
    needed.sort((a, b) => a.toDoDate.compareTo(b.toDoDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - widget.appBar.preferredSize.height;

    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.colors[0].withOpacity(0.5),
                        width: 1.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconData(widget.current.getIconroj,
                          fontFamily: 'MaterialIcons'),
                      color: widget.colors[0],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  Align(
                    child: Text(text),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      widget.current.getNameProj,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                    children: needed.map((e) {
                  return Task(e, (value) {
                    needed.remove(value);
                  });
                }).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
