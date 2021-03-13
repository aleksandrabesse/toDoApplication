import 'package:flutter/material.dart';
import 'package:to_do_application/resourses.dart';
import '../classes/proj.dart';
import '../dbhelper.dart';

class ListOfTasks extends StatefulWidget {
  Project p;
  Color color;
  int count;
  ListOfTasks(this.p, this.color, this.count);

  @override
  _ListOfTasksState createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  // int count;
  String text = '';
  bool isLoading = true;
  void getFuture() async {
    await DatabaseHelper.instance
        .queryRowsWithNProject(widget.p.getIdProj)
        .then((value) {
      print(value);
      setState(() {
        text = widget.count.toString() + getTask(widget.count);
      });
    }).whenComplete(() {
      isLoading = false;
    });
  }

  void initState() {
    getFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                            color: widget.color.withOpacity(0.5),
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconData(widget.p.getIconroj,
                              fontFamily: 'MaterialIcons'),
                          color: widget.color,
                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.settings), onPressed: () {})
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
                            child: Text(text),
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
              ],
            ),
    );
  }
}
