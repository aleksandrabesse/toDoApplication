import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/classes/toDo.dart';

class ExtendBottomSheet extends StatefulWidget {
  final Function _adder;
  ExtendBottomSheet(this._adder);
  @override
  _ExtendBottomSheetState createState() => _ExtendBottomSheetState();
}

class _ExtendBottomSheetState extends State<ExtendBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(
        velocity: isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
  }

  TextEditingController _todo = TextEditingController();

  void _add() async {
    ToDo newtask = ToDo(_todo.text);
    final int id = await DatabaseHelper.instance.insert(newtask);
    newtask.changeToDoID = id;
    widget._adder(newtask);
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.3;
    final double minHeight = MediaQuery.of(context).size.height * 0.08;
    TextField _enter = TextField(
      controller: _todo,
      onSubmitted: (text) {
        _add();
      },
      decoration: InputDecoration(
        hintText: 'Сделать...',
      ),
    );
    void _handleDragEnd(DragEndDetails details) {
      if (_controller.isAnimating ||
          _controller.status == AnimationStatus.completed) return;

      final double flingVelocity = details.velocity.pixelsPerSecond.dy /
          maxHeight; //<-- calculate the velocity of the gesture
      if (flingVelocity < 0.0)
        _controller.fling(
            velocity:
                math.max(2.0, -flingVelocity)); //<-- either continue it upwards

      else if (flingVelocity > 0.0)
        _controller.fling(
            velocity:
                math.min(-2.0, -flingVelocity)); //<-- or continue it downwards

      else
        _controller.fling(
            velocity: _controller.value < 0.5
                ? -2.0
                : 2.0); //<-- or just continue to whichever edge is closer
    }

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
              height: lerpDouble(minHeight, maxHeight, _controller.value),
              left: 0,
              right: 0,
              bottom: 0,
              
              child: GestureDetector(
                onTap: _toggle,
                onVerticalDragUpdate: (details) {
                  _controller.value -= details.primaryDelta / maxHeight;
                },
                onVerticalDragEnd: _handleDragEnd,
                child: Container(
                    child: _enter,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(242, 212, 174, 95),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    )),
              ));
        });
  }
}
