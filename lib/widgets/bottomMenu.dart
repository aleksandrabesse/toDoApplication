import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:to_do_application/classes/proj.dart';

class BottomMenu extends StatefulWidget {
  @override
  final Function _adder;
  double h;
  BuildContext ctx;
  BottomMenu(this.h, this.ctx, this._adder);
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  ToDo newToDo = ToDo('Введите задачу');
  List<Project> proj = [];
  TextEditingController tx = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isSelected = false;
  void _add() async {
    newToDo.changeToDoProj = 0;
    final int id = await DatabaseHelper.instance.insertTask(newToDo);
    newToDo.changeToDoID = id;
    widget._adder(newToDo);
    print(newToDo);
  }

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

  _selectDate(BuildContext ctx) async {
    final date = await showDatePicker(
        context: ctx,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2025));
    if (date != null) {
      setState(() {
        isSelected = true;
        selectedDate = date;
        newToDo.changeToDoDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.h,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
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
                decoration: InputDecoration.collapsed(
                  hintText: 'Сделать...',
                  hintStyle: Theme.of(context).textTheme.body2,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                    hint: Text(
                      'Выбрать проект',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    items: proj.map((e) {
                      return DropdownMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                MaterialButton(
                    child: isSelected
                        ? Text(selectedDate.day.toString() +
                            '.' +
                            selectedDate.month.toString() +
                            '.' +
                            selectedDate.year.toString())
                        : Text('Выбрать дату'),
                    onPressed: () {
                      _selectDate(context);
                    }),
              ],
            ),
            ToggleSwitch(
              labels: ['0', '1', '2', '3'],
              initialLabelIndex: newToDo.toDoImportant,
              activeBgColors: [
                Colors.grey,
                Colors.green,
                Colors.yellow,
                Colors.red
              ],
              onToggle: (index) {
                newToDo.changeImportant = index;
              },
            ),
            MaterialButton(onPressed: _add, child: Text('Добавить задачу'))
          ],
        ),
      ),
    );
  }
}
