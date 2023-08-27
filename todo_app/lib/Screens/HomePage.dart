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

  var currentTextStyle;
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
  void initState() {
    super.initState();
    setState(() {
      currentTextStyle = normalTextStyle;
    });
  }

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
        navigateToEditeToDosPage('Add New ToDo',ToDo(0, '', 'Low', ''));
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Card(
            margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              // Leading
              leading: Checkbox(
                
                value:  taskList[index].markAsDone == 'true' ? true : false,  
                onChanged: (value){
                  setState(() {
                    taskList[index].markAsDone = taskList[index].markAsDone == 'true' ? 'false' : 'true';
                  });

                  // print(value);
                  methodToStrockTheTask(value!);

                  // Updating The data when user click on the checkbox
                  _helperObject.updateData(taskList[index]);
                  getUpdatedListFromDatabase();
                }
              ),
        
              // Main Title
              title: Text(
                taskList[index].title.toString(),
                style: currentTextStyle,
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
    setState(() {
      value == true 
      ? currentTextStyle = decoratedTextStyle
      : currentTextStyle = normalTextStyle;
    });
  }



  navigateToEditeToDosPage(String title, ToDo object){
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute(title,'toRight','AddTask',object));
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
  }

  // navigateToHomePage(){}
  
}