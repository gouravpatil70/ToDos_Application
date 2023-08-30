import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'todo.dart';

class DatabaseHelper{

  String tableName = 'todoTable';
  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
  String colTaskMarkDone = 'markAsDone';
  String colDate = 'date';

  static var _databaseHelper;
  static var _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database{
    _database ??= initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = 'todo.db' + directory.path;
    var result = openDatabase(path,version: 1, onCreate: _onCreateDB);
    return result;
  }

  _onCreateDB(Database db, int version)async{
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colPriority INTEGER, $colTaskMarkDone VARCHAR(6), $colDate TEXT)');
  }

  Future<int> insertIntoTable(ToDo object)async{
    Database db = await database;
    var count = await getTotalCount();
    object.id = count+1;
    int result = await db.insert(tableName, object.convertToMapObject());
    return result;
  }

  Future<int> updateData(ToDo object)async{
    Database db = await database;
    int result = await db.update(tableName, object.convertToMapObject(),where: '$colId = ?',whereArgs: [object.id]);
    return result;
  }
  Future<int> daleteData(int id)async{
    Database db = await database;
    int result = await db.delete(tableName,where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Map<String,dynamic>>> getAllQueries()async{
    Database db = await database;
    List<Map<String,dynamic>> dataList = await db.rawQuery('SELECT * FROM $tableName ORDER BY $colPriority ASC');
    return dataList;
  }

  Future<List<ToDo>> getToDoClassList()async{
    List<Map<String,dynamic>> totalQueries = await getAllQueries();
    int totalCount = totalQueries.length;

    List<ToDo> ls = <ToDo>[];
    for(int i=0;i<totalCount;i++){
      ls.add(ToDo.fromMap(totalQueries[i]));
    }
    return ls;
  }

  Future<int> getTotalCount()async{
    List<Map<String,dynamic>> ls = await getAllQueries();
    int result = ls.length;
    return result;
  }
  
}