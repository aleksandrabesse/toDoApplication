import 'package:flutter/material.dart';
import 'classes/proj.dart';
import 'dbhelper.dart';

class ListOfTasks extends StatefulWidget {
  Project p;
  int count;
  ListOfTasks(this.p) {}

  @override
  _ListOfTasksState createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  void getInfo() async {
    setState(() {
      DatabaseHelper.instance
          .queryRowProjCount('toDo', widget.p.getIdProj)
          .then((value) => widget.count = value);
    });
  }

  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFF9957F).withOpacity(0.5),
                        width: 1.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconData(widget.p.getIconroj,
                          fontFamily: 'MaterialIcons'),
                      color: const Color(0xFFF9957F),
                    ),
                  ),
                  Icon(Icons.more_vert),
                ],
              ),
              flex: 1,
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          child: Text(widget.count.toString() + ' tasks'),
                          alignment: Alignment.centerLeft,
                        ),
                        Align(
                          child: Text(
                            widget.p.getNameProj,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
