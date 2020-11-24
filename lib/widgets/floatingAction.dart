import 'package:flutter/material.dart';
import 'package:to_do_application/page/addRoute.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/widgets/newProj.dart';

class FancyFab extends StatefulWidget {
  final Function(ToDo) adder;
  BuildContext context;
  Color color;
  List<Project> proj;
  AppBar appBar;
  FancyFab(this.adder, this.proj, this.color,this.context, this.appBar);
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.color,
      end: widget.color,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  void _add(name, icon) async {
    Project newP = Project(name, icon: icon);
    widget.proj.add(newP);
    final int id = await DatabaseHelper.instance.insertProject(newP);
    newP.changeIdProj = id;
  }

  Widget image() {
    _buttonColor = ColorTween(
      begin: widget.color,
      end: widget.color,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    return Container(
      child: FloatingActionButton(
        heroTag: 'btn3',
        onPressed: () {
          _animationController.reverse();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddRoute(widget.appBar, widget.adder,widget.color)));
        
        },
        backgroundColor: _buttonColor.value,
        tooltip: 'Добавить задачу',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'btn1',
        onPressed: () {
          _animationController.reverse();

          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetAnimationDuration: Duration(milliseconds: 400),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: NewProj((String name, int icon) {
                    setState(() {
                      _add(name, icon);
                    });
                  }),
                );
              });
        },
        backgroundColor: _buttonColor.value,
        tooltip: 'Добавить проект',
        child: Icon(Icons.add_comment),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'btn2',
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Добавить',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}
