import 'package:flutter/material.dart';
import '../Utils/todo.dart';
import '../Utils/AppColors.dart';
import '../Component/Components.dart';
import '../Animations/PageChangeAnimation.dart';
import 'package:sqflite/sqflite.dart';
import '../Utils/DatabaseHelper.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int currentSelectedId = 0;
  bool currentCheckBoxValue = false;

  // var currentTextStyle;
  var taskList;
  int totalTasksCount = 0;
  
  final DatabaseHelper _helperObject = DatabaseHelper();

  TextStyle normalTextStyle = const TextStyle(
    fontSize: 20.0,
  );

  TextStyle decoratedTextStyle = const TextStyle(
    fontSize: 20.0,
    decoration: TextDecoration.lineThrough,
    color: AppColors.whiteShadeColor,
  );

  @override
  Widget build(BuildContext context){
    if(taskList == null){
      taskList = <ToDo>[];
      getUpdatedListFromDatabase();
    }

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: Components.customAppBarMethod("ToDo's", true, calenderShowMethod),
      body: bodyContent(),
      bottomNavigationBar: Components.customBottomNavigationBar(currentSelectedId,changeDisplayPage),
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
        navigateToEditeToDosPage('Add New ToDo',ToDo(0, '', 3,'false', ''));
        break;
    }
  }

  calenderShowMethod(){}

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
                  await _helperObject.updateData(taskList[index]);
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
    Future<Database> dbFuture = _helperObject.initializeDatabase();

    dbFuture.then((value)async{
      List<ToDo> list = await _helperObject.getToDoClassList();

      setState(() {
        taskList = list;
        totalTasksCount = list.length;
      });
    });

    bodyContent();
  }

  // navigateToHomePage(){}
  
}