import 'package:flutter/material.dart';
import 'package:to_do_application/classes/proj.dart';
import 'package:to_do_application/classes/toDo.dart';
import 'package:to_do_application/dbhelper.dart';
import 'package:to_do_application/widgets/newProj.dart';

class HelpDrawer extends StatefulWidget {
  @override
  _HelpDrawerState createState() => _HelpDrawerState();
}

class _HelpDrawerState extends State<HelpDrawer> {
  AssetImage photo;
  String textForDrawer;
  List<Project> proj = [];
  @override
  void initState() {
    textForDrawer = DateTime.now().hour >= 18
        ? 'Добрый вечер!'
        : DateTime.now().hour > 12
            ? 'Добрый день!'
            : 'Доброе утро!';
    photo = DateTime.now().hour >= 18
        ? AssetImage('assets/ge.jpg')
        : DateTime.now().hour > 12
            ? AssetImage('assets/gd.jpg')
            : AssetImage('assets/gm.jpg');
    DatabaseHelper.instance
        .queryAllRows('project')
        .then((value) => value.forEach((element) {
              print(element['name']);
              setState(() {
                proj.add(Project.fromMap(element));
              });
            }));
    super.initState();
  }

  void _add(name, icon) async {
    Project newP = Project(name, icon: icon);
    proj.add(newP);
    final int id = await DatabaseHelper.instance.insertProject(newP);
    newP.changeIdProj = id;
  }

  void _delete(Project i) async {
    proj.remove(i);
    await DatabaseHelper.instance.delete(i.getIdProj, 'project');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Stack(
              children: [
                Positioned(bottom: 12.0, left: 16.0, child: Text(textForDrawer))
              ],
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: photo,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal:8.0),
            title: Text('Проекты'),
            trailing: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetAnimationDuration: Duration(milliseconds: 500),
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
              child: Icon(Icons.add),
            ),
          ),
          Divider(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              
              itemCount: proj.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(proj[index].getNameProj),
                  leading: Icon(
                    IconData(proj[index].getIconroj,
                        fontFamily: 'MaterialIcons'),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _delete(proj[index]);
                      });
                    },
                    child: Icon(Icons.delete, color: Colors.grey[400]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
