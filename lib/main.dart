import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/generateForList.dart';
import 'package:to_do_application/lstOfTasks.dart';
import 'package:to_do_application/widgets/bottomMenu.dart';
import 'package:to_do_application/widgets/forDrawer.dart';
import 'dbhelper.dart';
import 'package:flutter/material.dart';

import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/widgets/task.dart';
import 'classes/proj.dart';

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
        textTheme: TextTheme(
            body1: TextStyle(color: Colors.white),
            body2: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontSizeFactor: 1.0, fontSizeDelta: 2.0),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black)),
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

class _MyHomePageState extends State<MyHomePage> {
  String textForDrawer;
  final dbHelper = DatabaseHelper.instance;
  // List<ToDo> tasks = [
  //   ToDo('Добавить задачу', imp: 0),
  //   ToDo('Добавить не очень важную задачу', imp: 1),
  //   ToDo('Добавить важную, но не срочную задачу', imp: 2),
  //   ToDo('Добавить срочную задачу', imp: 3)
  // ];
  List<Project> proj = [];
  bool isLoading = true;
  int toDoCount;
  void getFuture() async {
    await DatabaseHelper.instance
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              print(element['name']);
              setState(() {
                proj.add(Project.fromMap(element));
                isLoading = false;
              });
            }));

    await dbHelper.queryRowCount('toDo').then((value) {
      setState(() {
        toDoCount = value;
      });
    });
  }

  void initState() {
    textForDrawer = DateTime.now().hour >= 18 || DateTime.now().hour <= 5
        ? 'Добрый вечер, '
        : DateTime.now().hour > 12
            ? 'Добрый день, '
            : 'Доброе утро, ';
    getFuture();
    //  SystemChrome.setSystemUIOverlayStyle(
    //   // SystemUiOverlayStyle(
    //   //   statusBarColor: Colors.transparent,
    //   //   systemNavigationBarColor: Colors.transparent
    //   // ),
    // );
    // dbHelper.queryAllRows('toDo').then((value) => value.forEach((element) {
    //       setState(() {
    //         tasks.insert(0, ToDo.fromMap(element));
    //       });
    //     }));

    super.initState();
  }

  String date(DateTime tm) {
    String month;
    switch (tm.month) {
      case 1:
        month = "январь";
        break;
      case 2:
        month = "февраль";
        break;
      case 3:
        month = "март";
        break;
      case 4:
        month = "апрель";
        break;
      case 5:
        month = "май";
        break;
      case 6:
        month = "июнь";
        break;
      case 7:
        month = "июль";
        break;
      case 8:
        month = "август";
        break;
      case 9:
        month = "сентябрь";
        break;
      case 10:
        month = "октябрь";
        break;
      case 11:
        month = "ноябрь";
        break;
      case 12:
        month = "декабрь";
        break;
    }
    return month;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int index = 1;
    List<Text> lstForUp = [
      Text(
        date(DateTime.now()) + ", " + DateTime.now().day.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Text(textForDrawer + 'Анна!'),
      Text('У вас ' +
          toDoCount.toString() +
          ' задач из ' +
          proj.length.toString() +
          ' проектов')
    ];
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );
    double height =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: HelpDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor:
      //       Theme.of(context).floatingActionButtonTheme.backgroundColor,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       isScrollControlled: true,
      //       context: context,
      //       builder: (ctx) {
      //         return SingleChildScrollView(
      //           padding: EdgeInsets.only(
      //               bottom: MediaQuery.of(context).viewInsets.bottom),
      //           child:
      //               BottomMenu(MediaQuery.of(context).size.height * 0.35, ctx,
      //                   (ToDo newTask) {
      //             setState(() {
      //               tasks.insert(0, newTask);
      //             });
      //           }),
      //         );
      //       },
      //     );
      //   },
      // ),
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: isLoading
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: height * 0.2,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                        child: Container(
                          height: height * 0.7 * 0.9,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListOfTasks(proj[index]),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: height * 0.35,
                      child: Column(
                        children: [
                          Container(
                            child: Text('Предстоящие'),
                            padding: const EdgeInsets.all(20),
                          ),
                          TaskForMain('Name', DateTime.now(),
                              MediaQuery.of(context).size.width * 0.8),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFF9957F), const Color(0xFFF2F5D0)]),
        ),
      ),
    );
  }
}
