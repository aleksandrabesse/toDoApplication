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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Flexible(
                      child: Container(
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
                      flex: 1,
                    ),
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
                  ),
                ],
              ),
            ),
          );

    // }
  }
}
