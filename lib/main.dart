import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/generateForList.dart';
import 'package:to_do_application/widgets/lstOfTasks.dart';
import 'package:to_do_application/widgets/floatingAction.dart';
import 'dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/dbhelper.dart';
import 'classes/proj.dart';
import 'package:to_do_application/russian.dart';
import 'package:to_do_application/widgets/newroute.dart';

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

const List<List<Color>> colors = [
  [const Color(0xFFF9957F), const Color(0xFFF2F5D0)],
  [const Color(0xFF9600FF), const Color(0xFFAEBAF8)],
  [const Color(0xFFEEBD89), const Color(0xFFD13DBD)],
  [const Color(0xFFBB73E0), const Color(0xFFFF8DDB)],
  [const Color(0xFF0CCDA3), const Color(0xFFC1FCD3)],
  [const Color(0xFF849B5C), const Color(0xFFBFFFC7)],
  [const Color(0xFF9FA5D5), const Color(0xFFE8F5C8)],
  [const Color(0xFFCCFBFF), const Color(0xFFEF96C5)],
  [const Color(0xFFA96F44), const Color(0xFFF2ECB6)],
  [const Color(0xFFED765E), const Color(0xFFE3BDE5)],
  [const Color(0xFF7DC387), const Color(0xFFDBE9EA)],
  [const Color(0xFFEAE5C9), const Color(0xFF6CC6CB)],
];

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
        // floatingActionButtonTheme:
        //     FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
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
  bool isLoading = true;
  int toDoCount;
  List<Text> lstForUp;

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
                isLoading = false;
              });
            }));
    toDoCount = tasks.length;
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

  int index = 0;
  int index1 = 0; //index for colors
  void changeIndexForColor() {
    int n = colors.length;
    if (index1 + 1 == n)
      index1 = 0;
    else
      index1 += 1;
  }

  void changeIndexForProject() {
    int n = proj.length;
    if (index + 1 == n)
      index = 0;
    else
      index += 1;
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );
    double height =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      // drawer: HelpDrawer(),
      floatingActionButton: FancyFab((ToDo newTask) {
        setState(() {
          tasks.insert(0, newTask);
          toDoCount += 1;
        });
      }, proj, colors[index1][0], context),
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: isLoading
              ? Container(child: Center(child: CircularProgressIndicator()))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.85,
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
                      Container(
                        height: height * 0.3,
                        width: double.infinity,
                        child: Center(
                          child: GestureDetector(
                            // TODO both side
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondRoute(
                                          proj[index],
                                          appBar,
                                          colors[index1],
                                          tasks)));
                            },
                            onHorizontalDragStart: (details) {
                              setState(() {
                                changeIndexForColor();
                                changeIndexForProject();
                              });
                            },
                            child: Container(
                              height: height * 0.7 * 0.9,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child:
                                    ListOfTasks(proj[index], colors[index1][0]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: height * 0.35,
                        child: Column(
                          children: [
                            Container(
                              child: Text('Предстоящие'),
                              padding: const EdgeInsets.all(20),
                            ),
                            TaskForMain('Name', DateTime.now(),
                                MediaQuery.of(context).size.width * 0.85),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors[index1]),
        ),
      ),
    );
  }
}
