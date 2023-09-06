import 'package:flutter/material.dart';
import 'package:todo_app/Utils/user_settings.dart';
import '../Utils/todo.dart';
import '../Utils/AppColors.dart';
import '../Component/app_components.dart';
import '../Animations/PageChangeAnimation.dart';
import 'package:sqflite/sqflite.dart';
import '../Utils/database_helper.dart';
import 'package:intl/intl.dart';
import '../Utils/database_helper_settings.dart';


class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  // Required Variables
  int currentSelectedId = 0;
  bool currentCheckBoxValue = false;
  var taskList;
  var userSettingsList;
  int totalTasksCount = 0;
  var selectedDateRangePicker;
  
  // Database helper class Object
  final DatabaseHelper _todoHelperObject = DatabaseHelper();

  // Getting the UserSettings database object
  final DatabaseHelperSettings _userSettings = DatabaseHelperSettings();

  // Text style decorations
  TextStyle normalTextStyle = const TextStyle(
    fontSize: 20.0,
  );
  TextStyle decoratedTextStyle = const TextStyle(
    fontSize: 20.0,
    decoration: TextDecoration.lineThrough,
    color: AppColors.whiteShadeColor,
  );


  @override
  void initState() {
    super.initState();
    // selectedDateRangePicker = DateFormat.yMMMd().format(DateTime.now());
    selectedDateRangePicker = 'Today';
  }

  @override
  Widget build(BuildContext context){

    if(userSettingsList == null){
      userSettingsList = <UserSettings>[];
      userSettingsTable();
    }

    if(taskList == null){
      taskList = <ToDo>[];
      getUpdatedListFromDatabase();
    }

    

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: Components.customAppBarMethod("ToDo's", true, calenderShowMethod),
      drawer: Components.appDrawer(context),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
            ),
            color: AppColors.appBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  Text(
                    selectedDateRangePicker,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.only(left: 3.0,right: 10.0),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: bodyContent(),
          ),
        ]
      ),
      
      bottomNavigationBar: Components.curvedBottomNavigatorBar(currentSelectedId,changeDisplayPage),
    );
  }


  // Method for BottomNavigation Bar
  changeDisplayPage(int value){
    setState(() {
      currentSelectedId = value;
    });
    switch (value) {
      case 0:
        break;
      case 1:
        navigateToEditeToDosPage('Add New ToDo',ToDo(0, '', 0,'false', ''));
        break;
    }
  }

  calenderShowMethod(){
    var currentYear = DateTime.now().year;
    var currentMounth = DateTime.now().month;
    var startDate = DateTime(currentYear,currentMounth,1);

    // print(currentYear);
    // print(currentMounth);
    // print(startDate);
    
    showDateRangePicker(
      context: context, 
      firstDate: DateTime(2023,1,1), 
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: DateTime.now()),

    ).then((value){
      var dateTimeFormat = '${DateFormat.yMMMd().format(value!.start)} - ${DateFormat.yMMMd().format(value.end)}';

      // If The inital range value & final range value is same then show only one date.
      if(value.start == value.end){
        dateTimeFormat = DateFormat.yMMMd().format(value.start);
      }else if(value.start.toString().substring(0,10) == DateTime.now().toString().substring(0,10)){
        dateTimeFormat = 'Today';
      }
      setState(() {
        selectedDateRangePicker = dateTimeFormat;
      });

      // print(dateTimeFormat);
      
    });
  }

  defaultEmptyMethod(){}

  bodyContent(){
    return ListView.builder(
      itemCount: totalTasksCount,
      itemBuilder:(BuildContext context,int index) {
        return Card(
          color: priorityWiseColorSet(taskList[index].priority),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Card(
            margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              // Leading
              leading: Checkbox(
                activeColor: priorityWiseColorSet(taskList[index].priority),
                side: BorderSide(
                  color: priorityWiseColorSet(taskList[index].priority),
                  width: 1.5
                ),
                value:  taskList[index].markAsDone == 'true' ? true : false,
                onChanged: (value)async{
                  setState(() {
                    taskList[index].markAsDone = (taskList[index].markAsDone == 'true' ? 'false' : 'true');
                  });

                  // print(taskList[index].markAsDone);
                  // print(taskList[index]);
                  // methodToStrockTheTask(value!,);

                  // Updating The data when user click on the checkbox
                  await _todoHelperObject.updateToDosData(taskList[index]);
                  getUpdatedListFromDatabase();
                }
              ),
        
              // Main Title
              title: Text(
                taskList[index].title.toString(),
                style: methodToStrockTheTask(taskList[index].markAsDone == 'true' ? true : false),
              ),
        
              // Trailing
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.av_timer,
                    color: AppColors.whiteShadeColor,
                  ),
                  Text(
                    '10:10',
                    style : TextStyle(
                      color: AppColors.whiteShadeColor,
                    )
                  ),
                ],
              ),
              onTap: (){
                navigateToEditeToDosPage('Edit ToDo', taskList[index]);
              },
            ),
          ),
        );
      },
    );
  }

  methodToStrockTheTask(bool value){
    TextStyle currentTextStyle;
    value == true 
    ? currentTextStyle = decoratedTextStyle
    : currentTextStyle = normalTextStyle;

    return currentTextStyle;
  }


  navigateToEditeToDosPage(String title, ToDo object){
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute(title,'toRight','AddTask',object));
  }

  Color priorityWiseColorSet(int priority){
    Color newColor;
    switch (priority) {
      case 1:
        newColor = AppColors.highPriorityColor;
        break;
      case 2:
        newColor = AppColors.mediumPriorityColor;
        break;
      default:
        newColor = AppColors.lowPriorityColor;
    }

    return newColor;
  }


  getUpdatedListFromDatabase()async{
    Future<Database> dbFuture = _todoHelperObject.initializeDatabase();

    dbFuture.then((value)async{
      List<ToDo> list = await _todoHelperObject.getToDoClassList();

      setState(() {
        taskList = list;
        totalTasksCount = list.length;
      });
    });

    bodyContent();
  }

  // Creating the database & inserting some queries into the User Settings database
  userSettingsTable(){
    Future<Database> dbFuture = _userSettings.initializeDatabase();
    dbFuture.then((value)async{
      List<UserSettings> userSettingsList = await _userSettings.getObjectList();

      // Inserting some settings into it.
      if(userSettingsList.length == 0){
        var result = await _userSettings.insertIntoSettingsTable(UserSettings(1, 'Low', 'curvedBottomNavigatorBar'));

        print(result);
      }

      setState(() {
        this.userSettingsList = userSettingsList;

      });
    });
  }


  // navigateToHomePage(){}
  
}