import 'package:flutter/material.dart';
import 'classes/proj.dart';
import 'dbhelper.dart';

class ListOfTasks extends StatefulWidget {
  Project p;
  ListOfTasks(this.p);

  @override
  _ListOfTasksState createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  int count;
  void getFuture() async {
    await DatabaseHelper.instance
        .queryRowProjCount('toDo', widget.p.getIdProj)
        .then((value) => count = value);
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  void initState() {
    getFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(15),
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
                      ),
                      IconButton(
                          icon: Icon(Icons.add_circle), onPressed: () {})
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Align(
                              child: Text(count.toString() + ' tasks'),
                              alignment: Alignment.centerLeft,
                            ),
                            Align(
                              child: Text(
                                widget.p.getNameProj,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

    // }
  }
}
