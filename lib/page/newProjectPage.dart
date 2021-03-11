import 'package:flutter/material.dart';

class NewProjectPage extends StatelessWidget {
  TextEditingController _tx = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            width: 100,
            color:Colors.red
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            child:  TextField(
              controller: _tx,
              autofocus: false,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Название проекта",
              ),
            ),
            ),
          Container(),
          Container(),
          Container()
        ],
      ),
    );
  }
}
