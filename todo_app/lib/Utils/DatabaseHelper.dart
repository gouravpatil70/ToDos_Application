import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'ToDo.dart';

class DatabaseHelper{

  String tableName = 'todoTable';
  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
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
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colPriority VARCHAR(10),  $colDate TEXT)');
  }

  Future<int> insertIntoTable(ToDo object)async{
    Database db = await database;
    int result = await db.insert(tableName, object.convertToMapObject());
    return result;
  }

  Future<int> updateData(ToDo object)async{
    Database db = await database;
    int result = await db.update(tableName, object.convertToMapObject(),where: '$colId = ?',whereArgs: [object.id]);
    return result;
  }
  
}