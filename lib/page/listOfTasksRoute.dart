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
  SecondRoute(this.current, this.color, this.width);

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

        List<Widget> td = [];
        List<Widget> tm = [];
        List<Widget> tw = [];
        List<Widget> thisMonth = [];
        List<Widget> lt = [];
        needed.sort((a, b) => a.toDoDate.compareTo(b.toDoDate));

        var today = DateTime.now();
        var tommoroow = DateTime.now().add(Duration(days: 1));
        var maxThisWeek = DateTime.now();

        while (maxThisWeek.weekday != DateTime.sunday) {
          maxThisWeek.add(const Duration(days: 1));
        }

        for (int i = 0; i < needed.length; i++) {
          var temp = needed[i].toDoDate;
          var n = needed[i];
          if (temp.year == today.year) {
            if (temp.day == today.day && temp.month == today.month) {
              td.add(
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: widget.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('Хочу выйти, а не дают');
                              },
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.toDoName,
                                      style: TextStyle(fontSize: 18)),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        DateFormat('HH:mm').format(n.toDoDate),
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        n.toDoImportant >= 1
                            ? Icon(Icons.circle,
                                color: colorsForImportance[n.toDoImportant],
                                size: 12)
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            } else if (temp.day == tommoroow.day &&
                temp.month == tommoroow.month) {
              tm.add(Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    width: widget.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('Хочу выйти, а не дают');
                              },
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.toDoName,
                                      style: TextStyle(fontSize: 18)),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        DateFormat('HH:mm').format(n.toDoDate),
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        n.toDoImportant >= 1
                            ? Icon(Icons.circle,
                                color: colorsForImportance[n.toDoImportant],
                                size: 12)
                            : Container()
                      ],
                    )),
              ));
            } else if (temp.isAfter(tommoroow) && temp.isBefore(maxThisWeek) ||
                (temp.day == maxThisWeek.day &&
                    temp.month == maxThisWeek.month &&
                    temp.year == maxThisWeek.year)) {
              tw.add(Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    width: widget.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('Хочу выйти, а не дают');
                              },
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.toDoName,
                                      style: TextStyle(fontSize: 18)),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        weekDay(n.toDoDate) +
                                            ', ' +
                                            DateFormat('dd.MM')
                                                .format(n.toDoDate),
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        n.toDoImportant >= 1
                            ? Icon(Icons.circle,
                                color: colorsForImportance[n.toDoImportant],
                                size: 12)
                            : Container()
                      ],
                    )),
              ));
            } else {
              thisMonth.add(Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    width: widget.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('Хочу выйти, а не дают');
                              },
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.toDoName,
                                      style: TextStyle(fontSize: 18)),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        DateFormat('dd.MM').format(n.toDoDate),
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        n.toDoImportant >= 1
                            ? Icon(Icons.circle,
                                color: colorsForImportance[n.toDoImportant],
                                size: 12)
                            : Container()
                      ],
                    )),
              ));
            }
          } else {
            lt.add(Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                  width: widget.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('Хочу выйти, а не дают');
                            },
                            child: Icon(Icons.done),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.toDoName,
                                    style: TextStyle(fontSize: 18)),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      DateFormat('yyyy').format(n.toDoDate),
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.left,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      n.toDoImportant >= 1
                          ? Icon(Icons.circle,
                              color: colorsForImportance[n.toDoImportant],
                              size: 12)
                          : Container()
                    ],
                  )),
            ));
          }
        }

        needToShow.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Сегодня',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                  fontSize: 18),
            ),
          ),
        ));
        needToShow.add(Divider(
          color: widget.color,
          thickness: 1,
        ));
        needToShow.addAll(td);
        needToShow.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Завтра',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                  fontSize: 18),
            ),
          ),
        ));
        needToShow.add(Divider(
          color: widget.color,
          thickness: 1,
        ));
        needToShow.addAll(tm);
        needToShow.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'На этой неделе',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                  fontSize: 18),
            ),
          ),
        ));
        needToShow.add(Divider(
          color: widget.color,
          thickness: 1,
        ));
        needToShow.addAll(tw);
        needToShow.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'В этом месяце',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                  fontSize: 18),
            ),
          ),
        ));
        needToShow.add(Divider(
          color: widget.color,
          thickness: 1,
        ));
        needToShow.addAll(thisMonth);
        needToShow.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Позднее',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                  fontSize: 18),
            ),
          ),
        ));
        needToShow.add(Divider(
          color: widget.color,
          thickness: 1,
        ));
        needToShow.addAll(lt);
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height + appBar.preferredSize.height,
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height) *
                      0.13,
                  child: FittedBox(
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
                ),
                Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height) *
                      0.8,
                  child: SingleChildScrollView(
                    child: Column(children: needToShow),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class LT extends StatelessWidget {
  ToDo n;
  LT(this.n);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print('Хочу выйти, а не дают');
                  },
                  child: Icon(Icons.done),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      Text(n.toDoName),
                      Text(
                        DateFormat('HH:mm').format(n.toDoDate),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            n.toDoImportant >= 1
                ? Icon(Icons.circle,
                    color: colorsForImportance[n.toDoImportant], size: 12)
                : Container()
          ],
        ));
  }
}
