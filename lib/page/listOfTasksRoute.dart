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
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 10),
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
                          subtitle:
                              Text(DateFormat("HH:mm").format(el.toDoDate)),
                          trailing: el.toDoImportant >= 1
                              ? Icon(Icons.circle,
                                  color: colorsForImportance[el.toDoImportant],
                                  size: 12)
                              : Container(),
                        ))
                    .toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
//     return Scaffold(
//       appBar: widget.appBar,
//       body: SafeArea(
//         child: isLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.only(
//                             left: 20, top: 20, bottom: 20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Align(
//                               child: Text(text),
//                               alignment: Alignment.centerLeft,
//                             ),
//                             Align(
//                               child: Text(
//                                 widget.current.getNameProj,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 24),
//                               ),
//                               alignment: Alignment.centerLeft,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Container(
//                           padding: const EdgeInsets.all(15),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: widget.color.withOpacity(0.5),
//                               width: 1.5,
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             IconData(widget.current.getIconroj,
//                                 fontFamily: 'MaterialIcons'),
//                             color: widget.color,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     width: double.infinity,
//                     color: widget.color,
//                     child: SingleChildScrollView(
//                       child: Row(
//                         children: needed
//                             .map((e) => InkWell(
//                                   onTap: () {
//                                     neededCur.clear();
//                                     List<ToDo> temp = [];
//                                     needed.forEach((element) {
//                                       if (element.toDoDate == e.toDoDate) {
//                                         temp.add(element);
//                                       }
//                                     });
//                                     setState(() {
//                                       neededCur = List.from(temp);
//                                     });
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(5)),
//                                     ),
//                                     margin: const EdgeInsets.all(10),
//                                     width: width,
//                                     height: width * 1.5,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           FittedBox(
//                                               fit: BoxFit.scaleDown,
//                                               child: Text(weekDay(e.toDoDate))),
//                                           FittedBox(
//                                               fit: BoxFit.scaleDown,
//                                               child: Text(
//                                                   e.toDoDate.day.toString())),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                       scrollDirection: Axis.horizontal,
//                     ),
//                   ),
//                   SingleChildScrollView(
//                     child: Container(
//                       padding: const EdgeInsets.only(left: 20, top: 10),
//                       child: Column(
//                           children: neededCur.map((e) {
//                         return Task(e, (value) {
//                           neededCur.remove(value);
//                         });
//                       }).toList()),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
