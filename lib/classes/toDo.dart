class ToDo {
  int _id;
  String _name;
  int _important;
  int _project;
  DateTime _deadline;
  ToDo(name, {int id, int imp, DateTime date, int proj}) {
    if (id != null)
      _id = id;
    else
      _id = 0;
    _name = name;
    if (imp != null)
      _important = imp;
    else
      _important = 0;
    if (date != null)
      _deadline = date;
    else
      _deadline = DateTime.now();
    if (proj != null)
      _project = proj;
    else
      _project = 0;
  }
  int get toDoProj {
    return _project;
  }

  void set changeToDoProj(int n) {
    if (n > 0 && n != _project) _project = n;
  }

  void set changeToDoID(int n) {
    _id = n;
  }

  DateTime get toDoDate {
    return _deadline;
  }

  int get toDoID {
    return _id;
  }

  void set changeToDoDate(DateTime n) {
    if (n != _deadline) _deadline = n;
  }

  String get toDoName {
    return _name;
  }

  void set changeToDoName(String n) {
    if (n != '' && n != ' ') _name = n;
  }

  int get toDoImportant {
    return _important;
  }

  void set changeImportant(int n) {
    if (_important != n) if (_important >= 0 && _important <= 3) _important = n;
  }

  ToDo.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _important = map['important'];
    _project = map['proj'];
    _deadline = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'important': _important,
      'proj': _project,
      'date': _deadline.toString()
    };
  }
}
