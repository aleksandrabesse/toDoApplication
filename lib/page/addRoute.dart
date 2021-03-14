import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/resourses.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AddRoute extends StatefulWidget {
  final Function(ToDo) _adder;
  Color color;
  AddRoute(this._adder, this.color);

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

  bool isSelectedDate = false;
  bool isSelectedTime = false;
  List<double> sizeOfImportant = [15, 15, 15];
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: widget.color,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );
    Future<void> _selectDate(BuildContext context) async {
      final DateTime pickedDate = await showDatePicker(
          locale: Locale('ru', "RU"),
          helpText: 'Введите дату',
          fieldHintText: 'dd/mm/yy',
          fieldLabelText: 'Введите дату',
          errorFormatText: 'Введите дату в формате dd/mm/yy',
          errorInvalidText: '4',
          cancelText: 'Отмена',
          confirmText: 'Ок',
          context: context,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryIconTheme: IconThemeData(
                    color: widget.color), //OK/Cancel button text color
                primaryColor: widget.color, //Head background
                accentColor: widget.color, //selection color
                // dialogBackgroundColor: widget.color,//Background color
              ),
              child: child,
            );
          },

          // initialDatePickerMode: DatePickerEntryMode.input,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2050));

      if (pickedDate != null && pickedDate != DateTime.now())
        setState(() {
          DateTime d = new DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, selectedDate.hour, selectedDate.minute);
          selectedDate = d;
          isSelectedDate = true;
        });
    }

    double height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: SafeArea(
        child: Column(children: [
          ClipPath(
            child: Container(
              color: widget.color,
              height: height * 0.25,
              width: width,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment(-1, -1),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      autofocus: false,
                      controller: tx,
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          newToDo.changeToDoName = tx.text;
                        }
                      },
                      onChanged: (text) {
                        newToDo.changeToDoName = tx.text;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        labelText: 'Введите задачу',
                        fillColor: HSLColor.fromColor(widget.color)
                            .withSaturation(
                                HSLColor.fromColor(widget.color).saturation *
                                    0.95)
                            .toColor(),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(15),
                        //     gapPadding: 1,
                        //     borderSide: BorderSide(color: Colors.red)
                        //     )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            clipper: BottomWaveClipper(),
          ),
          Container(
              width: width,
              height: height * 0.75,
              padding: const EdgeInsets.only(
                  left: 20, top: 30, right: 20, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Align(
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
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Icon(
                                          Icons.date_range_outlined,
                                          color: isSelectedDate
                                              ? widget.color
                                              : Colors.black,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          child: Center(
                                            child: Text(DateFormat('d MM yyyy')
                                                .format(selectedDate)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Flexible(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    var time = await showTimePicker(

                                        // locale: Locale('ru', "RU"),
                                        cancelText: 'Отмена',
                                        confirmText: 'Ок',
                                        helpText: 'Введите время',
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData.light().copyWith(
                                                primaryColor: widget.color,
                                                accentColor: widget.color,
                                                colorScheme: ColorScheme.light(
                                                    primary: widget.color),
                                                buttonTheme: ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .primary),
                                              ),
                                              child: child);
                                        });
                                    setState(() {
                                      isSelectedTime = true;
                                      DateTime d = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          time.hour,
                                          time.minute);
                                      selectedDate = d;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Icon(Icons.access_time,
                                            color: isSelectedTime
                                                ? widget.color
                                                : Colors.black),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            DateFormat('HH:mm')
                                                .format(selectedDate),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
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
                  ),
                  Flexible(
                    flex: 4,
                    child: Row(
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
                  ),
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: widget.color)),
                        color: widget.color,
                        onPressed: () {
                          newToDo.changeToDoDate = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute);
                          Navigator.of(context).pop();
                          widget._adder(newToDo);
                        },
                        child: Text('Добавить задачу'),
                      ),
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}

class WavyHeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('images/coffee_header.jpeg'),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.7); //vertical line
    path.cubicTo(50, size.height, size.width - 50, size.height * 0.55,
        size.width, size.height); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
