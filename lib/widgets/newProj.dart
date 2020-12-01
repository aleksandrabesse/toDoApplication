import 'package:flutter/material.dart';
import 'package:to_do_application/classes/multoSelectChip.dart';

class NewProj extends StatefulWidget {
  final Function(String, int) _addProj;
  Color color;
  int chooisen = 58712;
  NewProj(this._addProj, this.color);
  @override
  _NewProjState createState() => _NewProjState();
}

class _NewProjState extends State<NewProj> {
  TextEditingController _tx = TextEditingController();
  @override
  void dispose() {
    _tx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _tx,
              autofocus: false,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Название проекта",
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  // spacing: 4.0,
                  // runSpacing: 4.0,
                  children: [
                    MultiSelectChip((int c) {
                      setState(() {
                        widget.chooisen = c;
                      });
                    }, widget.color)
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (_tx.text != '') {
                  widget._addProj(_tx.text, widget.chooisen);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Готово'),
            )
          ],
        ),
      ),
    );
  }
}
