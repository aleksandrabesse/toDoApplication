import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_application/allProjPage.dart';
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
  List<ToDo> needed = [];
  bool isLoading = true;
  void getFuture() async {
    needed.clear();
    await DatabaseHelper.instance.queryAllRows('toDo').then((value) {
      print(value);
      value.forEach((element) {
        needed.add(ToDo.fromMap(element));
      });
    }).whenComplete(() {
      needed.sort((a, b) => a.toDoDate.compareTo(b.toDoDate));
      print(needed);
      items = List.from(needed);
      setState(() {
        isLoading = false;
      });
    });
  }

  List<ToDo> items;
  initState() {
    getFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
      title: Text('Задачи'),
      centerTitle: true,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => AllProjPage()),
              )
              .then((value) => getFuture());
        },
      ),
      appBar: appBar,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height +
                  appBar.preferredSize.height,
              child: Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height) *
                    0.8,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final n = items[index];
                    final item = items[index].toDoName;
                    return Dismissible(
                      secondaryBackground: Container(
                        color: colorsForImportance[0],
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Сделано',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      background: Container(
                        color: colorsForImportance[0],
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Сделано',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        DatabaseHelper.instance.delete(n.toDoID, 'toDo');
                        setState(() {
                          items.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Задача '$item' удалена")));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 20),
                        child: Container(
                          // width: widget.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      DatabaseHelper.instance
                                          .delete(n.toDoID, 'toDo');
                                      setState(() {
                                        items.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Задача '$item' удалена")));
                                    },
                                    child: Icon(Icons.done),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(n.toDoName,
                                            style: TextStyle(fontSize: 18)),
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              DateFormat('HH:mm')
                                                      .format(n.toDoDate) +
                                                  ', ' +
                                                  weekDay(n.toDoDate) +
                                                  ' ' +
                                                  DateFormat('dd.MM')
                                                      .format(n.toDoDate),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              textAlign: TextAlign.left,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              n.toDoImportant >= 1
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Icon(Icons.circle,
                                          color: colorsForImportance[
                                              n.toDoImportant],
                                          size: 12),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
