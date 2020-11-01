import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'classes/toDo.dart';
import 'package:to_do_application/classes/proj.dart';

class DatabaseHelper {
  static final _databaseName = "toDo.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
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
            icon INTEGER NOT NULL
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
    Project insert = Project('Входящие', icon: 58771);
    await db.insert('project', insert.toMap());
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
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
    String sqlFor = "INSERT INTO project (name,icon) VALUES ('" +
        t['name'].toString() +
        "'," +
        t['icon'].toString()+
        ')';

    return await db.rawInsert(sqlFor);
  }
  // Future<int> insert(task, String table) async {
  //   Database db = await instance.database;
  //   return await db.insert(table, task.toMap());
  // }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name, table) async {
    Database db = await instance.database;

    return await db.query(table, where: "name LIKE '%$name%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(task, String table) async {
    Database db = await instance.database;
    int id = task.toMap()['id'];
    return await db
        .update(table, task.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
