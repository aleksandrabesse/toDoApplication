import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/widgets/bottomMenu.dart';
import 'dbhelper.dart';
import 'package:to_do_application/widgets/task.dart';
// import 'package:to_do_application/widgets/task2.dart';

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
        appBarTheme: AppBarTheme(
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black)),
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
  List<Project> proj = [];
  void initState() {
    dbHelper.queryAllRows('toDo').then((value) => value.forEach((element) {
          setState(() {
            tasks.insert(0, ToDo.fromMap(element));
          });
        }));
    dbHelper.queryAllRows('project').then((value) => value.forEach((element) {
          print(element['name']);
          setState(() {
            proj.add(Project.fromMap(element));
          });
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String textForDrawer = DateTime.now().hour >= 18
        ? 'Добрый вечер!'
        : DateTime.now().hour > 12
            ? 'Добрый день!'
            : 'Доброе утро!';
    AssetImage photo = DateTime.now().hour >= 18
        ? AssetImage('assets/ge.jpg')
        : DateTime.now().hour > 12
            ? AssetImage('assets/gd.jpg')
            : AssetImage('assets/gm.jpg');

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Positioned(
                      bottom: 12.0, left: 16.0, child: Text(textForDrawer))
                ],
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: photo,
                ),
              ),
            ),
            ListTile(
              title: Text('Проекты'),
              trailing: GestureDetector(
                onTap: () {
                  // TODO
                },
                child: Icon(Icons.add),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ...proj.map((e) {
              return ListTile(
                title: Text(e.getNameProj),
            
                leading: Icon(IconData(e.getIconroj,fontFamily: 'MaterialIcons')),
              );
            }).toList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return BottomMenu(MediaQuery.of(context).size.height * 0.4, ctx,
                    (ToDo newTask) {
                  // print(Icons.add.codePoint);
                  setState(() {
                    tasks.insert(0, newTask);
                  });
                });
              });
        },
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SingleChildScrollView(
            child: Column(
              children: tasks
                  .map((e) => Task(e, (ToDo cur) {
                        setState(() {
                          tasks.remove(cur);
                        });
                      }))
                  .toList(),
            ),
          ),
          // ExtendBottomSheet((ToDo newTask) {
          //   setState(() {
          //     tasks.insert(0, newTask);
          //   });
          // })
        ]),
      ),
    );
  }
}
