import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  Color color;
  Function(int) _addProj;
  MultiSelectChip(this._addProj, this.color);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<bool> selectedChoices = List();
  int chooise = 58712;
  List<int> icons = List();
  void initState() {
    for (int i = 58712; i <= 60158; i += 3) {
      icons.add(i);
      selectedChoices.add(false);
    }
    selectedChoices[0] = true;
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    icons.forEach((item) {
      choices.add(
        Container(
          color: selectedChoices[icons.indexOf(item)]
              ? widget.color.withOpacity(0.8)
              : Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              child: Icon(IconData(item, fontFamily: 'MaterialIcons')),
              onTap: () {
                widget._addProj(item);
                setState(() {
                  selectedChoices[icons.indexOf(chooise)] = false;
                  selectedChoices[icons.indexOf(item)] = true;
                });
                chooise = item;
              }),
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
        spacing: 6.0, // gap between adjacent chips
        runSpacing: 6.0, // gap between lines
        children: _buildChoiceList());
  }
}
