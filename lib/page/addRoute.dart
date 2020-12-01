import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/resourses.dart';

class AddRoute extends StatefulWidget {
  AppBar appBar;
  final Function _adder;
  Color color;
  AddRoute(this.appBar, this._adder, this.color);

  @override
  _AddRouteState createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  ToDo newToDo = ToDo('Введите задачу');
  List<Project> proj = [];
  TextEditingController tx = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();
  void initState() {
    DatabaseHelper.instance
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              print(element['name']);
              setState(() {
                proj.add(Project.fromMap(element));
              });
            }));
    super.initState();
  }

  @override
  void dispose() {
    tx.dispose();
    super.dispose();
  }

  void _add() async {
    newToDo.changeToDoDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    final int id = await DatabaseHelper.instance.insertTask(newToDo);
    newToDo.changeToDoID = id;
    widget._adder(newToDo);
    Navigator.of(context).pop();
  }

  List<double> sizeOfImportant = [15, 15, 15];
  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - widget.appBar.preferredSize.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: widget.appBar,
        body: Container(
          color: widget.color,
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.1,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Добавить задачу',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  width: double.infinity,
                  height: height * 0.85,
                  padding: const EdgeInsets.only(
                      left: 20, top: 30, right: 20, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Align(
                            child: Text(
                              'Дата и время',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontSize),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: DatePickerWidget(
                                  looping: false,
                                  firstDate: DateTime.now(),
                                  dateFormat: "dd(E)-MMMM-yyyy",
                                  onChange: (DateTime newDate, _) {
                                    selectedDate = newDate;
                                  },
                                  locale: DatePicker.localeFromString('ru'),
                                  pickerTheme: DateTimePickerTheme(
                                    backgroundColor: Colors.transparent,
                                    itemTextStyle:
                                        TextStyle(color: Colors.black),
                                    dividerColor: widget.color,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TimePickerSpinner(
                                  normalTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.grey),
                                  highlightedTextStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  itemWidth: 20,
                                  is24HourMode: true,
                                  onTimeChange: (time) {
                                    selectedTime = time;
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              child: Text(
                                'Название задачи',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 1,
                            autofocus: false,
                            controller: tx,
                            onSubmitted: (text) {
                              newToDo.changeToDoName = tx.text;
                            },
                            onChanged: (text) {
                              newToDo.changeToDoName = tx.text;
                            },
                            decoration: InputDecoration(
                                labelText: 'Введите задачу',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 1,
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            child: Text(
                              'Проект',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontSize),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          DropdownButton(
                              isExpanded: true,
                              value: newToDo.toDoProj,
                              hint: Text(
                                'Выбрать проект',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              items: proj.map((e) {
                                return DropdownMenuItem(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.getNameProj),
                                      Icon(
                                        IconData(e.getIconroj,
                                            fontFamily: 'MaterialIcons'),
                                      ),
                                    ],
                                  ),
                                  value: e.getIdProj,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  newToDo.changeToDoProj = value;
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            child: Text(
                              'Приоритет',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontSize),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  newToDo.changeImportant = 0;
                                  setState(() {
                                    sizeOfImportant[0] = 20;
                                    sizeOfImportant[1] = 15;
                                    sizeOfImportant[2] = 15;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorsForImportance[0]),
                                  height: sizeOfImportant[0],
                                  width: sizeOfImportant[0],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  newToDo.changeImportant = 1;
                                  setState(() {
                                    sizeOfImportant[0] = 15;
                                    sizeOfImportant[1] = 20;
                                    sizeOfImportant[2] = 15;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorsForImportance[1]),
                                  height: sizeOfImportant[1],
                                  width: sizeOfImportant[1],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  newToDo.changeImportant = 2;
                                  setState(() {
                                    sizeOfImportant[0] = 15;
                                    sizeOfImportant[1] = 15;
                                    sizeOfImportant[2] = 20;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorsForImportance[2]),
                                  height: sizeOfImportant[2],
                                  width: sizeOfImportant[2],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: widget.color)),
                          color: widget.color,
                          onPressed: _add,
                          child: Text('Добавить задачу'),
                        ),
                      )
                    ],
                  )),
            ],
          )),
        ));
  }
}
