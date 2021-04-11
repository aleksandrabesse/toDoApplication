class Project {
  int _id;
  String _name;
  int _icon;
  int _color;

  Project(name, {int id, int icon, int color}) {
    if (id != null)
      _id = id;
    else
      _id = 0;
    _name = name;
    _icon = icon;
    _color = color;
  }

  Project.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _icon = map['icon'];
    _color = map['color'];
  }

  Map<String, dynamic> toMap() {
    return {'id': _id, 'name': _name, 'icon': _icon, 'color': _color};
  }

  
  int get getIdProj {
    return _id;
  }

  String get getNameProj {
    return _name;
  }

  int get getIconroj {
    return _icon;
  }

  set changeIdProj(id) {
    _id = id;
  }

  set changeNameProj(name) {
    _name = name;
  }

  set changeIconProj(icon) {
    _icon = icon;
  }

  int get getColorproj {
    return _color;
  }

  set changeColorProj(color) {
    _color = color;
  }


}
