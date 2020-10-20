import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/extendBottomSheet.dart';
import 'dbhelper.dart';
import 'package:to_do_application/widgets/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(color: Colors.transparent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Входящие'),
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
  final dbHelper = DatabaseHelper.instance;
  List<ToDo> tasks = [
    ToDo('Добавить задачу', imp: 0, proj: 0),
    ToDo('Добавить не очень важную задачу', imp: 1, proj: -1),
    ToDo('Добавить важную, но не срочную задачу', imp: 2),
    ToDo('Добавить срочную задачу', imp: 3)
  ];
  void initState() {
    dbHelper.queryAllRows().then((value) => value.forEach((element) {
      setState(() {
        tasks.insert(0, ToDo.fromMap(element));
      });
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tasks.map((e) => Task(e, (ToDo cur){ setState(() {
                    tasks.remove(cur);
                  });})).toList(),
                ),
              ),
              ExtendBottomSheet((ToDo newTask) {
                setState(() {
                  tasks.add(newTask);
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
