import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  int chooise = 58712;
  Function(int) _addProj;
  MultiSelectChip(this._addProj);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<bool> selectedChoices = List();
  List<int> icons = List();
  void initState() {
    for (int i = 58712; i <= 60158; i += 3) {
      icons.add(i);
      selectedChoices.add(false);
      // Icon(IconData(i, fontFamily: 'MaterialIcons')));
    }
    selectedChoices[0] = true;
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    icons.forEach((item) {
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(''),
            // selectedColor: Colors.teal[100],
            // backgroundColor: Colors.white,
            avatar: Icon(IconData(item, fontFamily: 'MaterialIcons')),
            selected: selectedChoices[icons.indexOf(item)],
            onSelected: (bool selected) {
              selectedChoices[icons.indexOf(widget.chooise)] = false;
              widget.chooise = item;
              if (selected) widget._addProj(item);
              setState(() {
                selectedChoices[icons.indexOf(item)] = selected;
                print(selectedChoices[0]);
              });
            },
          ),
        ),
      );
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 4.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: _buildChoiceList());
  }
}
