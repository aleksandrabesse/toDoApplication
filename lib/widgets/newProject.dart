import 'package:flutter/material.dart';
import 'package:to_do_application/classes/multoSelectChip.dart';
import 'package:to_do_application/classes/proj.dart';

class NewProjCard extends StatefulWidget {
  Color color;
  final Function(Project) _addProj;
  final Function() change;
  double height;
  NewProjCard(this.color, this._addProj, this.height, this.change);
  @override
  _NewProjCardState createState() => _NewProjCardState();
}

class _NewProjCardState extends State<NewProjCard> {
  TextEditingController _tx = TextEditingController();
  int chooisen = 58712;
  bool isChoisen = false;
  bool isOpen = false;
  Project newProject = Project('temp');
  @override
  void dispose() {
    _tx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: widget.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isChoisen
                                ? widget.color.withOpacity(0.8)
                                : Colors.black,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconData(chooisen, fontFamily: 'MaterialIcons'),
                          color: isChoisen ? widget.color : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () {
                        if (_tx.text != '') {
                          newProject.changeNameProj = _tx.text;
                          newProject.changeIconProj = chooisen;
                          widget._addProj(newProject);
                          widget.change();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.color.withOpacity(0.8),
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: widget.height * 0.6,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    MultiSelectChip((int c) {
                      setState(() {
                        isChoisen = true;
                        chooisen = c;
                      });
                    }, widget.color)
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
