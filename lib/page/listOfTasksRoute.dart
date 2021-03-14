import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/resourses.dart';
import 'package:intl/intl.dart';
class SecondRoute extends StatefulWidget {
  Color color;
  List<ToDo> tasks = [];
  Project current;
  SecondRoute(this.current, this.color);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<ToDo> needed = [];
  List<ToDo> neededCur = [];
  int count;
  String text = '';
  bool isLoading = true;
  void getFuture() async {
    await DatabaseHelper.instance
        .queryRowProjCount(widget.current.getIdProj)
        .then((value) {
      // print(value);
      setState(() {
        count = value;
        text = count.toString() + getTask(count);
      });
    }).whenComplete(() async {
      await DatabaseHelper.instance
          .queryRowsWithNProject(widget.current.getIdProj)
          .then((value) {
        print(value);
        value.forEach((element) {
          widget.tasks.add(ToDo.fromMap(element));
        });
      }).whenComplete(() {
        needed = widget.tasks;
        needed.sort((a, b) => a.toDoDate.compareTo(b.toDoDate));
        neededCur = List.from(needed);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

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
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );

    return Scaffold(
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 3,
        child: Container(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("xyz"),
                accountEmail: Text("xyz@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("xyz"),
                ),
              ),
              ListTile(
                title: new Text("All Inboxes"),
                leading: new Icon(Icons.mail),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar,
      body: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Text(text),
                      alignment: Alignment.centerLeft,
                    ),
                    Align(
                      child: Text(
                        widget.current.getNameProj,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: neededCur
                  .map((el) => ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            print('Хочу выйти, а не дают');
                          },
                          child: Icon(Icons.done),
                        ),
                        title: Text(el.toDoName),
                        subtitle: Text(DateFormat("HH:mm").format(el.toDoDate)),
                        trailing: el.toDoImportant >= 1
                            ? Icon(Icons.circle,
                                color: colorsForImportance[el.toDoImportant],
                                size: 12)
                            : Container(),
                      ))
                  .toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
