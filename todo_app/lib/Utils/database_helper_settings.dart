import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'user_settings.dart';

class DatabaseHelperSettings{

  // Required Variables
  String tableName = 'userSettings';
  String colSrNo = 'srno';
  String colDefaultPriority = 'defaultPriority';
  String coldDefaultBottomNavigation = 'defaultBottomNavigation';

  static var _databaseHelperSettings;
  static var _database;

  DatabaseHelperSettings._createInstance();

  // Initializing the Object of the class (Single-Ton)
  factory DatabaseHelperSettings(){
    _databaseHelperSettings ??= DatabaseHelperSettings._createInstance();
    return _databaseHelperSettings;
  }

  // Getting the database
  Future<Database> get database{
    _database ??= initializeDatabase();
    return _database;
  }

  // Method for initalizing the database
  Future<Database> initializeDatabase()async{
    Directory directoryPath = await getApplicationDocumentsDirectory();
    String tablePath = 'todoAppUserSettings.db ${directoryPath.path}';
    var result = await openDatabase(tablePath,version: 1, onCreate: _onCreateDB);
    return result;
  }

  // Creating the Database
  _onCreateDB(Database db,int version,)async{
    return await db.execute('CREATE TABLE $tableName($colSrNo INTEGER PRIMARY KEY, $colDefaultPriority INTEGER, $coldDefaultBottomNavigation VARCHAR(30))');
  }

  // Inserting into the table
  Future<int> insertIntoSettingsTable(UserSettings object)async{
    Database db = await database;
    int result = await db.insert(tableName, object.converToMap());
    return result;
  }

  // Updating the data Settings table
  Future<int> updatesSettingsTableValue(UserSettings object)async{
    Database db = await database;
    int result = await db.update(tableName, object.converToMap(), where: '$colSrNo = ?', whereArgs: [object.srno]);
    return result;
  }


  // Getting map object of the queries
  Future<List<Map<String,dynamic>>> getAllSettings()async{
    Database db = await database;
    List<Map<String,dynamic>> data = await db.rawQuery('SELECT * FROM $tableName');
    return data;
  }

  // Getting the list of object of settigns
  Future<List<UserSettings>> getObjectList()async{
    List<Map<String,dynamic>> dataMapList = await getAllSettings();
    int count = dataMapList.length;
    List<UserSettings> userSettingsList = <UserSettings>[];
    for(int i=0;i<count;i++){
      userSettingsList.add(UserSettings.fromMapObject(dataMapList[i]));
    }
    return userSettingsList;
  }
  
}