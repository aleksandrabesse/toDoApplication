import 'package:to_do_application/dbhelper.dart';

class ToDo {
  int _id;
  String _name;

  ToDo(id, name) {
    _id = id;
    _name = name;
  }
  String get toDoName {
    return _name;
  }

  void set changeToDoName(String n) {
    _name = n;
  }

  ToDo.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: _id,
      DatabaseHelper.columnName: _name,
    };
  }
}
