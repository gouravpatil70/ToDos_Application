import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'ExpenseClass.dart';

class DatabaseHelper{
  static var _datbaseHelper;
  static var _database;

  final String tableName = 'expenseTable';
  final String colId = 'id';
  final String colReason = 'reason';
  final String colRupees = 'rupees';
  final String colMode = 'mode';
  final String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    _datbaseHelper ??= DatabaseHelper._createInstance();
    return _datbaseHelper;
  }

  Future<Database> get database{
    _database ??= initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'expenses.db';

    var result = await openDatabase(path, version: 1, onCreate: _onCreateDb);
    return result;
  }

  _onCreateDb(Database db, int newVersion)async{
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY, $colReason TEXT, $colRupees INTEGER, $colMode VARCHAR2(15), $colDate TEXT)');
    // await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY, $colReason TEXT, $colRupees INTEGER, $colDate DATETIME)');
  }

  // Inserting the data into the database
  Future<int> insertData(Expenses obj)async{
    Database db = await database;
    var totalCount = await getCount();
    obj.id = totalCount! + 1;
    int result = await db.insert(tableName, obj.toMap());
    return result;
  }

  // Updating the data into the database
  Future<int> updateData(Expenses obj)async{
    Database db = await database;
    int result = await db.update(tableName, obj.toMap(), where: '$colId = ?', whereArgs: [obj.id]);
    return result;
  }

  // Deleting the data from the databse
  Future<int> deleteData(int id)async{
    Database db = await database;
    var result = await db.delete(tableName, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Getting the list of list of data from the database
  Future<List<Map<String,dynamic>>> getAllExpensesListt(var startDate, var endDate)async{
    print(startDate.runtimeType == String);
    Database db = await database;
    var result = await db.rawQuery("SELECT * FROM $tableName WHERE $colDate BETWEEN '${DateTime.parse(startDate)}' AND '${DateTime.parse(endDate)}' ORDER BY $colId ASC");
    // var result = await db.query(tableName, orderBy: '$colId ASC');
    return result;
  }


  // Getting the total count of the rows present into the databsae
  Future<int?> getCount()async{
    Database db = await database;
    var expenseList = await db.rawQuery('SELECT COUNT (*) FROM $tableName');
    var count = Sqflite.firstIntValue(expenseList);
    return count;
  }

  // Getting the total amount we speand
  Future<int> getTotalAmountSpeand()async{
    Database db = await database;
    int totalAmount = 0;

    // Getting the Rupees Column Only where amount is debited
    var dataList = await db.rawQuery("SELECT $colRupees FROM $tableName WHERE $colMode == 'Debit' ");
    var toConvertedList = dataList.toList();  // Converted to list so that we can perform operation
    for(int i=0;i<toConvertedList.length;i++){  
      totalAmount += (toConvertedList[i]['rupees'] as int); // Addition of total rupees & stored into variable
    }
    
    // print(totalAmount);

    return totalAmount;
  }

  // Getting the total amount which is credited
  Future<int> getTotalAmountCredit()async{
    Database db = await database;
    int totalAmount = 0;

    // Getting the Rupees Column Only where amount is debited
    var dataList = await db.rawQuery("SELECT $colRupees FROM $tableName WHERE $colMode == 'Credit' ");
    var toConvertedList = dataList.toList();  // Converted to list so that we can perform operation
    for(int i=0;i<toConvertedList.length;i++){  
      totalAmount += (toConvertedList[i]['rupees'] as int); // Addition of total rupees & stored into variable
    }
    
    print(totalAmount);

    return totalAmount;
  }

  // Getting the total with credit & speand
  Future<int> getTotalAvailableAmount()async{
    
    int totalAmount = 0;
    
    int speandAmount = await getTotalAmountSpeand();
    int creditedAmount = await getTotalAmountCredit();

    // Substracting the amount from creditedAmount from speand amount.
    totalAmount = creditedAmount-speandAmount;

    // print(totalAmount);

    return totalAmount;
  }

  // Getting the Expense List 
  Future<List<Expenses>> getExpensesClassList(var startDate, var endDate) async{
    List<Map<String,dynamic>> list = await getAllExpensesListt(startDate,endDate);
    int count = list.length;
    List<Expenses> expenseList = <Expenses>[];
    for(int i=0;i<count;i++){
      expenseList.add(Expenses.fromMapObject(list[i]));
    }
    return expenseList;
  }
}