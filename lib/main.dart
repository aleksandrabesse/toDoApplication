import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/helperFunc.dart';
import 'package:to_do_application/widgets/lstOfTasks.dart';
import 'package:to_do_application/widgets/floatingAction.dart';
import 'package:to_do_application/widgets/newProject.dart';
import 'package:to_do_application/dbhelper.dart';
import 'classes/proj.dart';
import 'package:to_do_application/resourses.dart';
import 'package:to_do_application/page/listOfTasksRoute.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [const Locale('ru')],
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontSizeFactor: 1.0, fontSizeDelta: 2.0),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Задачи'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Information inf = Information();
  String textForDrawer;
  final dbHelper = DatabaseHelper.instance;
  List<ToDo> tasks = [];
  List<Project> proj = [];
  bool isNewProject = false;
  bool isLoading = true;
  int toDoCount;
  List<Text> lstForUp;
  int index = 0;
  int indexOfColor = 0; //index for colors
  void getFuture() async {
    await DatabaseHelper.instance
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              print(element['name']);
              setState(() {
                proj.add(Project.fromMap(element));
              });
            }));
    await dbHelper
        .queryAllRows('toDo')
        .then((value) => value.forEach((element) {
              setState(() {
                tasks.insert(0, ToDo.fromMap(element));
              });
            }))
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    toDoCount = inf.countOfAllTasks;

    lstForUp = [
      Text(
        date(DateTime.now()) + ", " + DateTime.now().day.toString(),
        style: TextStyle(fontSize: 24),
      ),
    ];
  }

  void initState() {
    textForDrawer = DateTime.now().hour >= 18 || DateTime.now().hour <= 5
        ? 'Добрый вечер, '
        : DateTime.now().hour > 12
            ? 'Добрый день, '
            : 'Доброе утро, ';
    getFuture();
    super.initState();
  }

  void changeIndexForColorLeft() {
    int n = colors.length;
    if (indexOfColor + 1 == n)
      indexOfColor = 0;
    else
      indexOfColor += 1;
  }

  void changeIndexForProjectLeft() {
    int n = proj.length;
    if (index + 1 == n)
      index = 0;
    else
      index += 1;
  }

  void changeIndexForColorRight() {
    int n = colors.length;
    if (indexOfColor - 1 == -1)
      indexOfColor = n - 1;
    else
      indexOfColor -= 1;
  }

  void changeIndexForProjectRight() {
    int n = proj.length;
    if (index - 1 == -1)
      index = n - 1;
    else
      index -= 1;
  }

  void _add(Project p) async {
    proj.add(p);
    final int id = await DatabaseHelper.instance.insertProject(p);
    p.changeIdProj = id;
  }

  bool isDrag = false;
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );

    double height =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height);
    double hForCard = height * 0.6;
    double width = MediaQuery.of(context).size.width;
    double wForCard = MediaQuery.of(context).size.width * 0.9;
    double locationLeft1 = 150;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButton: FancyFab(
          (ToDo newTask) {
            setState(() {
              tasks.insert(0, newTask);
              toDoCount += 1;
            });
          },
          proj,
          colors[indexOfColor][0],
          context,
          () {
            setState(() {
              isNewProject = true;
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
                          // Positioned(
                          //   top: 5 * height / 18,
                          //   left: width * 0.05,
                          //   child: Container(
                          //     height: height / 8,
                          //     width: wForCard,
                          //     child:
                          //         //  Padding(
                          //         // padding: const EdgeInsets.all(8.0),
                          //         // child:
                          //         Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: lstForUp.map((e) {
                          //         return Align(
                          //           child: e,
                          //           alignment: Alignment.centerLeft,
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          //   // ),
                          // ),
                          Positioned(
                            // top: height / 8,
                            left: isDrag ? locationLeft1 : width * 0.05,
                            child: isNewProject
                                ? Container(
                                    height: hForCard,
                                    width: wForCard,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: NewProjCard(
                                          colors[indexOfColor][0],
                                          (Project temp) {
                                            setState(() {
                                              _add(temp);
                                            });
                                          },
                                          hForCard,
                                          () {
                                            setState(() {
                                              isNewProject = false;
                                            });
                                          }),
                                    ),
                                  )
                                : Draggable(
                                    axis: Axis.horizontal,
                                    child: Container(
                                      height: height * 5 / 18,
                                      width: wForCard,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              ScaleRoute(
                                                  page: SecondRoute(
                                                      proj[index],
                                                      appBar,
                                                      colors[indexOfColor][0],
                                                      tasks)));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ListOfTasks(proj[index],
                                              colors[indexOfColor][0]),
                                        ),
                                      ),
                                    ),
                                    feedback: Container(
                                      height: height * 5 / 18,
                                      width: wForCard,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListOfTasks(proj[index],
                                            colors[indexOfColor][0]),
                                      ),
                                    ),
                                    childWhenDragging: Container(),
                                    onDragEnd: (drag) {
                                      double change = drag.offset.dx;
                                      if (change > wForCard / 2) {
                                        setState(() {
                                          changeIndexForColorRight();
                                          changeIndexForProjectRight();
                                        });
                                      }
                                      if (change < -wForCard / 2) {
                                        setState(() {
                                          changeIndexForColorLeft();
                                          changeIndexForProjectLeft();
                                        });
                                      }
                                    },
                                  ),
                          ),
                          Positioned(
                            top: height/3,
                            left: width * 0.05,
                            height: height / 2,
                            width: wForCard,
                            child: Container(
                              child: Column(
                                children: [
                                  Align(
                                    child: lstForUp[0],
                                    alignment: Alignment.centerLeft,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors[indexOfColor]),
          ),
        ),
      ),
    );
  }
}
