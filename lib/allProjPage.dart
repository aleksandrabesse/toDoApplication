import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/lstOfTasks.dart';
import 'package:to_do_application/widgets/floatingAction.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application/dbhelper.dart';
import 'classes/proj.dart';
import 'package:to_do_application/resourses.dart';
import 'package:to_do_application/page/listOfTasksRoute.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features.dart';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

class AllProjPage extends StatefulWidget {
  @override
  _AllProjPageState createState() => _AllProjPageState();
}

class _AllProjPageState extends State<AllProjPage>
    with SingleTickerProviderStateMixin {
  String textForDrawer;
  final dbHelper = DatabaseHelper.instance;
  List<Project> proj = [];
  int countTasks = 0;
  Map commonList = {};
  bool isNewProject = false;
  bool isLoading = true;
  List<Text> lstForUp;
  int index = 0;
  int indexOfColor = 0; 
  void getFuture() async {
    proj.clear();
    commonList.clear();
    await dbHelper
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              proj.add(Project.fromMap(element));
            }))
        .whenComplete(() async {
      for (int i = 0; i < proj.length; i++) {
        await dbHelper.queryRowProjCount(proj[i].getIdProj).then((value) {
          commonList[proj[i].getIdProj] = value;
        });
      }
    }).whenComplete(() {
      print('Общий лист');
      print(commonList);
      countTasks = commonList[proj[index].getIdProj];
      setState(() {
        isLoading = false;
      });
    });

    lstForUp = [
      Text(
        'Сегодня ' + DateTime.now().day.toString() + " " + date(DateTime.now()),
      ),
    ];
  }

  void initState() {
    getFuture();
    indexOfColor = 0;
    super.initState();
  }

  void changeIndexForProjectLeft() {
    int n = proj.length;
    if (index + 1 == n)
      index = 0;
    else
      index += 1;
    indexOfColor = proj[index].getColorproj;
  }

  void changeIndexForProjectRight() {
    int n = proj.length;
    if (index - 1 == -1)
      index = n - 1;
    else
      index -= 1;
    indexOfColor = proj[index].getColorproj;
  }

  void _add(Project p) async {
    final int id = await DatabaseHelper.instance.insertProject(p);
    p.changeIdProj = id;
    proj.add(p);
    commonList[p.getIdProj] = 0;
  }

  int getCountOftasksProj(index1) {
    return commonList[index1];
  }

  bool isDrag = false;
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: colors[indexOfColor][0].withOpacity(0.8),
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );

    double height =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height);
    double width = MediaQuery.of(context).size.width;
    double wForCard = MediaQuery.of(context).size.width * 0.9;
    double locationLeft1 = 150;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButton: FancyFab(
          (ToDo newTask) async {
            commonList[newTask.toDoProj] += 1;
            final int id = await DatabaseHelper.instance.insertTask(newTask);
            newTask.changeToDoID = id;
            setState(() {
              isLoading = false;
              getFuture();
            });
          },
          proj,
          colors[indexOfColor],
          context,
          (Project p) {
            setState(() {
              _add(p);
            });
          }),
      appBar: appBar,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height + appBar.preferredSize.height,
        child: Container(
          child: SafeArea(
              child: isLoading
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : SizedBox(
                      child: Stack(
                        children: [
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.001,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: CustomPaint(
                              painter: CurvePainter(colors[indexOfColor]),
                            ),
                          ),
                          Positioned(
                            left: isDrag ? locationLeft1 : width * 0.1,
                            top: height * 0.35,
                            child: Draggable(
                              axis: Axis.horizontal,
                              child: Container(
                                height: height * 0.5,
                                width: width * 0.8,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      ScaleRoute(
                                        page: SecondRoute(
                                          proj[index],
                                          colors[indexOfColor][0],
                                          width,
                                          (ToDo p) {
                                            commonList[p.toDoProj] -= 1;
                                            dbHelper.delete(p.toDoID, 'toDo');
                                            setState(() {
                                              isLoading = false;
                                              getFuture();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListOfTasks(
                                        proj[index],
                                        colors[indexOfColor][0],
                                        getCountOftasksProj(index)),
                                  ),
                                ),
                              ),
                              feedback: Container(
                                height: height * 0.5,
                                width: width * 0.8,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListOfTasks(
                                      proj[index],
                                      colors[indexOfColor][0],
                                      getCountOftasksProj(index)),
                                ),
                              ),
                              childWhenDragging: Container(),
                              onDragEnd: (drag) {
                                double change = drag.offset.dx;
                                if (change > wForCard / 2) {
                                  setState(() {
                                    changeIndexForProjectRight();
                                  });
                                }
                                if (change < -wForCard / 2) {
                                  setState(() {
                                    changeIndexForProjectLeft();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: colors[indexOfColor]),
          // ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  List<Color> colors;
  CurvePainter(this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
          Offset(0, 0), Offset(size.width / 2, size.height / 3), colors);

    final path = new Path()
      ..moveTo(0, size.height * .15)
      ..quadraticBezierTo(
        size.width * .35,
        0,
        size.width * .8,
        size.height * .2,
      )
      ..arcToPoint(
        Offset(
          size.width * .6,
          size.height * .18,
        ),
        radius: Radius.circular(size.height * .09),
        largeArc: true,
      )
      ..lineTo(size.width * .6 + size.height * .10, size.height * .27)
      ..cubicTo(
        size.width * .86,
        size.height * .41,
        size.width * .3,
        size.height * .35,
        0,
        size.height * .45,
      )
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
