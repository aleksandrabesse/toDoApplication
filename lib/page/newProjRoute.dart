import 'package:flutter/material.dart';
import 'package:to_do_application/classes/multoSelectChip.dart';

class NewProjRoute extends StatefulWidget {
  AppBar appBar;
  Color color;
  final Function(String, int) _addProj;
  int chooisen = 58712;
  NewProjRoute(this.appBar, this.color, this._addProj);

  @override
  _NewProjRouteState createState() => _NewProjRouteState();
}

class _NewProjRouteState extends State<NewProjRoute> {
  TextEditingController _tx = TextEditingController();

  @override
  void dispose() {
    _tx.dispose();
    super.dispose();
  }

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
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Добавить проект',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: height * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                padding: const EdgeInsets.only(
                    left: 20, top: 30, right: 20, bottom: 30),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: height * 0.85 * 0.1,
                          child: Column(
                            children: [
                              Align(
                                child: Text(
                                  'Название проекта',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontSize),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              TextField(
                                controller: _tx,
                                autofocus: false,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Название проекта",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.85 * 0.7,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                child: Text(
                                  'Иконка проекта',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontSize),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                height: height * 0.85 * 0.5,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      MultiSelectChip((int c) {
                                        setState(() {
                                          widget.chooisen = c;
                                        });
                                      }, widget.color)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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
                            onPressed: () {
                              if (_tx.text != '') {
                                widget._addProj(_tx.text, widget.chooisen);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Готово'),
                          ),
                        ),
                        // Container(
                        //   height: height * 0.85 * 0.1,
                        //   child: MaterialButton(
                        //     onPressed: () {
                        //       if (_tx.text != '') {
                        //         widget._addProj(_tx.text, widget.chooisen);
                        //         Navigator.of(context).pop();
                        //       }
                        //     },
                        //     child: Text('Готово'),
                        //   ),
                        // ),
                      ]),
                )),
          ],
        )),
      ),
    );
  }
}
