import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'classes/proj.dart';

class DatabaseHelper {
  static final _databaseName = "toDo.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db
        .execute('''CREATE TABLE project (id INTEGER PRIMARY KEY AUTOINCREMENT
      ,name TEXT NOT NULL,
            icon INTEGER NOT NULL,color INTEGER NOT NULL
       )''');
    await db.execute('''
          CREATE TABLE toDo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            important INTEGER NOT NULL,
            date TEXT NOT NULL,
            proj INTEGER NOT NULL,
            FOREIGN KEY (proj) REFERENCES project(id)
          )
          ''');

    Project insert = Project('Входящие', icon: 58771, color: 0);

    await db.insert('project', insert.toMap());
  }

  Future<int> insertTask(task) async {
    Database db = await instance.database;
    Map<String, dynamic> t = task.toMap();
    String sqlFor = "INSERT INTO toDo (name,important,date,proj) VALUES ('" +
        t['name'] +
        "'," +
        t['important'].toString() +
        ",'" +
        t['date'] +
        "'," +
        t['proj'].toString() +
        ')';

    return await db.rawInsert(sqlFor);
  }

  Future<int> insertProject(task) async {
    Database db = await instance.database;
    Map<String, dynamic> t = task.toMap();
    String sqlFor = "INSERT INTO project (name,icon,color) VALUES ('" +
        t['name'].toString() +
        "'," +
        t['icon'].toString() +
        ',' +
        t['color'].toString() +
        ')';

    return await db.rawInsert(sqlFor);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRowsWithNProject(int n) async {
    Database db = await instance.database;
    return db.rawQuery('SELECT * FROM toDo where proj==$n');
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> queryRowProjCount(int proj) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM toDo where proj ==' + proj.toString()));
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
