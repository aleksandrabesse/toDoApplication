import 'package:flutter/material.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  _selectDate(BuildContext ctx) async {
    await showDatePicker(
            context: ctx,
            initialDate: selectedDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        isSelected = true;
        selectedDate = value;
        newToDo.changeToDoDate = selectedDate;
      });
    });
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: tx,
                onSubmitted: (text) {
                  newToDo.changeToDoName = tx.text;
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Сделать...',
                ),
              ),
            ),
            Text('Выбор проекта'),
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
