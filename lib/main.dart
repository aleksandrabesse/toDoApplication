import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/generateForList.dart';
import 'package:to_do_application/widgets/lstOfTasks.dart';
import 'package:to_do_application/widgets/floatingAction.dart';
import 'package:to_do_application/widgets/newProject.dart';
import 'dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/dbhelper.dart';
import 'classes/proj.dart';
import 'package:to_do_application/resourses.dart';
import 'package:to_do_application/page/listOfTasksRoute.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   // statusBarColor: Colors.transparent,
  //   // statusBarBrightness: Brightness.dark,
  //   // systemNavigationBarColor: Colors.white,
  //   // systemNavigationBarIconBrightness: Brightness.dark,
  //   // systemNavigationBarDividerColor: Colors.transparent,
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // darkTheme: ThemeData(
      //   floatingActionButtonTheme:
      //       FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
      //   // textTheme: TextTheme(
      //   //     body1: TextStyle(color: Colors.white),
      //   //     body2: TextStyle(color: Colors.black)),
      //   // iconTheme: IconThemeData(
      //   //   color: Colors.white,
      //   // ),
      //   brightness: Brightness.dark,
      //   appBarTheme: AppBarTheme(
      //       color: Colors.transparent,
      //       iconTheme: IconThemeData(color: Colors.black)),
      // ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontSizeFactor: 1.0, fontSizeDelta: 2.0),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
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

    toDoCount = tasks.length;
    if (toDoCount == 0)
      lstForUp = [
        Text(
          date(DateTime.now()) + ", " + DateTime.now().day.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(textForDrawer + 'Анна!'),
        Text('У вас ни одной задачи')
      ];
    else
      lstForUp = [
        Text(
          date(DateTime.now()) + ", " + DateTime.now().day.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(textForDrawer + 'Анна!'),
        Text('У вас ' +
            toDoCount.toString() +
            getTask(toDoCount) +
            ' из ' +
            proj.length.toString() +
            getProject(proj.length))
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
    // Project newP = Project(name, icon: icon);
    //
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
        (MediaQuery.of(context).size.height - appBar.preferredSize.height) ;
    double hForCard = height * 0.6;
    double width = MediaQuery.of(context).size.width;
    double wForCard = MediaQuery.of(context).size.width * 0.9;
    double locationLeft1 = 150;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
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
                          Positioned(
                            left: width * 0.05,
                            child: Container(
                              height: height * 0.2,
                              width: wForCard,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: lstForUp.map((e) {
                                    return Align(
                                      child: e,
                                      alignment: Alignment.centerLeft,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: height * 0.2,
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
                                      height: hForCard,
                                      width: wForCard,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SecondRoute(
                                                          proj[index],
                                                          appBar,
                                                          colors[indexOfColor]
                                                              [0],
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
                                      height: hForCard,
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
