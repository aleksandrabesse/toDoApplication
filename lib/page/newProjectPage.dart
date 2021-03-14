import 'package:flutter/material.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/resourses.dart';

class NewProjectPage extends StatefulWidget {
  List<Color> color;
  final Function(Project) adderProject;
  NewProjectPage(this.color, this.adderProject);

  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  TextEditingController tx = TextEditingController();
  int colorIndex = 0;
  int firstOrSecondColor = 0;
  int icon = 58712;
  bool isBlack = false;
  String nameOfProject = '';

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 0.0,
    );
    double height =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          Project p = Project(nameOfProject, icon: icon, color: colorIndex);
          widget.adderProject(p);
          Navigator.of(context).pop();
        },
        backgroundColor: colors[colorIndex][firstOrSecondColor],
      ),
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: width,
        height: height + appBar.preferredSize.height,
        child: Container(
          width: width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: height / 8,
                    width: height / 8,
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.05 / 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isBlack
                                  ? colors[colorIndex][firstOrSecondColor]
                                  : colors[colorIndex][firstOrSecondColor]
                                      .withOpacity(0.5),
                              width: 3.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              IconData(icon, fontFamily: 'MaterialIcons'),
                              color: colors[colorIndex][firstOrSecondColor],
                              size: height / 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: width * 0.95,
                    child: Center(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        autofocus: false,
                        controller: tx,
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            nameOfProject = tx.text;
                          }
                        },
                        onChanged: (text) {
                          nameOfProject = tx.text;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.done,
                            color: isBlack ? Colors.black : Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: isBlack ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          labelText: 'Название проекта',
                          fillColor: HSLColor.fromColor(
                                  colors[colorIndex][firstOrSecondColor])
                              .withSaturation(HSLColor.fromColor(
                                          colors[colorIndex]
                                              [firstOrSecondColor])
                                      .saturation *
                                  0.95)
                              .toColor(),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: isBlack
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: height * 0.15,
                      width: width * 0.95,
                      child: ColorsScroll((int i) {
                        setState(() {
                          colorIndex = i;
                          HSLColor.fromColor(colors[colorIndex][0]).lightness <
                                  HSLColor.fromColor(colors[colorIndex][1])
                                      .lightness
                              ? firstOrSecondColor = 0
                              : firstOrSecondColor = 1;
                          (HSLColor.fromColor(colors[colorIndex]
                                          [firstOrSecondColor])
                                      .lightness) <
                                  0.85
                              ? isBlack = false
                              : isBlack = true;
                        });
                      })),
                  Container(
                      height: height * 0.25,
                      width: width,
                      child: IconWrap((int i) {
                        setState(() {
                          icon = i;
                        });
                      }, colors[colorIndex][firstOrSecondColor])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  int i;
  Circle(t1) {
    i = t1;
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: [0.4, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors[i]),
          border: Border.all(
            color: Colors.transparent,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ColorsScroll extends StatelessWidget {
  final Function(int) chooise;
  List<int> colorsForCircle = [];
  ColorsScroll(this.chooise) {
    for (int i = 0; i < colors.length; i++) {
      colorsForCircle.add(i);
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        return GestureDetector(
            onTap: () {
              chooise(index);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: MediaQuery.of(context).size.width / 4.5,
              child: Circle(index),
            ));
      },
      itemCount: colorsForCircle.length,
    );
  }
}

class IconWrap extends StatelessWidget {
  final Function(int) chooise;
  Color color;
  List<Widget> items = [];
  IconWrap(this.chooise, this.color) {
    for (int i = 58712; i <= 60158; i += 3) {
      items.add(GestureDetector(
        onTap: () {
          chooise(i);
        },
        child: Icon(
          IconData(i, fontFamily: 'MaterialIcons'),
          size: 40,
          color: HSVColor.fromColor(color).withValue(0.4).toColor(),
        ),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 15,
              runAlignment: WrapAlignment.center,
              runSpacing: 15,
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
