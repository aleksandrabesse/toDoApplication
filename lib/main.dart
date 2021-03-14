import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
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
  String textForDrawer;
  final dbHelper = DatabaseHelper.instance;
  List<Project> proj = [];
  Map commonList = {};
  bool isNewProject = false;
  bool isLoading = true;
  List<Text> lstForUp;
  int index = 0;
  int indexOfColor = 0; //index for colors
  void getFuture() async {
    await dbHelper
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              // print(element['Name']);
              proj.add(Project.fromMap(element));
            }))
        .whenComplete(() async {
      for (int i = 0; i < proj.length; i++) {
        await dbHelper.queryRowProjCount(proj[i].getIdProj).then((value) {
          commonList[proj[i].getIdProj] = value;
        });
      }
    }).whenComplete(() {
      print(commonList);
      setState(() {
        isLoading = false;
      });
    });

    lstForUp = [
      Text(
        'Сегодня ' + DateTime.now().day.toString() + " " + date(DateTime.now()),
        // style: TextStyle(fontSize: 24),
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
    double width = MediaQuery.of(context).size.width;
    double wForCard = MediaQuery.of(context).size.width * 0.9;
    double locationLeft1 = 150;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButton: FancyFab(
          (ToDo newTask) {
            setState(() {
              // tasks.insert(0, newTask);
              // toDoCount += 1;
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
                            left: isDrag ? locationLeft1 : width * 0.05,
                            child: Draggable(
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
                                                colors[indexOfColor][0],
                                                width)));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListOfTasks(
                                        proj[index],
                                        colors[indexOfColor][0],
                                        commonList[proj[index].getIdProj]),
                                  ),
                                ),
                              ),
                              feedback: Container(
                                height: height * 5 / 18,
                                width: wForCard,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListOfTasks(
                                      proj[index],
                                      colors[indexOfColor][0],
                                      commonList[proj[index].getIdProj]),
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
                          Positioned(
                            top: height / 3,
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
