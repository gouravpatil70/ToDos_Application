import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelperSettings{

  // Required Variables
  String tableName = 'userSettings';
  String colSrNo = 'srno';
  String colDefaultPriority = 'defaultPriority';
  String coldDefaultBottomNavigation = 'defaultBottomNavigation';

  static var _databaseHelperSettings;
  static var _database;

  DatabaseHelperSettings._createInstance();

  factory DatabaseHelperSettings(){
    _databaseHelperSettings ??= DatabaseHelperSettings._createInstance();
    return _databaseHelperSettings;
  }

  Future<Database> get database{
    _database ??= initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase()async{
    Directory directoryPath = await getApplicationDocumentsDirectory();
    String tablePath = 'todoAppUserSettings.db ${directoryPath.path}';
    var result = await openDatabase(tablePath,version: 1, onCreate: _onCreateDB);
    return result;
  }

  _onCreateDB(Database db,int version,)async{
    return await db.execute('CREATE TABLE $tableName($colSrNo INTEGER PRIMARY KEY, $colDefaultPriority INTEGER, $coldDefaultBottomNavigation VARCHAR(30))');
  }

  
}