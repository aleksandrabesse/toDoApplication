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
  double width;
  final Function(ToDo) del;
  SecondRoute(this.current, this.color, this.width, this.del);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<ToDo> needed = [];
  List<Widget> needToShow = [];
  int count;
  String text = '';
  bool isLoading = true;
  void getFuture() async {
    await DatabaseHelper.instance
        .queryRowProjCount(widget.current.getIdProj)
        .then((value) {
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
        print(needed);
        items = List.from(needed);
        setState(() {
          isLoading = false;
        });
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
    print(needToShow);
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
      body: isLoading
          ? CircularProgressIndicator()
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height +
                  appBar.preferredSize.height,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20),
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height) *
                          0.5,
                      // width: MediaQuery.of(context).size.width * 0.9,
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
                                          style:
                                              TextStyle(color: Colors.white)),
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
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              widget.del(n);
                              setState(() {
                                items.removeAt(index);
                                count -= 1;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Задача '$item' удалена")));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 20),
                              child: Container(
                                // width: widget.width * 0.9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            widget.del(n);
                                            setState(() {
                                              count -= 1;
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
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(n.toDoName,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    DateFormat('HH:mm').format(
                                                            n.toDoDate) +
                                                        ', ' +
                                                        weekDay(n.toDoDate) +
                                                        ' ' +
                                                        DateFormat('dd.MM')
                                                            .format(n.toDoDate),
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.left,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    n.toDoImportant >= 1
                                        ? Icon(Icons.circle,
                                            color: colorsForImportance[
                                                n.toDoImportant],
                                            size: 12)
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
