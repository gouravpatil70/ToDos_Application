import 'package:flutter/material.dart';
import '../Utils/todo.dart';
import '../Utils/AppColors.dart';
import '../Component/Components.dart';
import '../Animations/PageChangeAnimation.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int currentSelectedId = 0;
  bool currentCheckBoxValue = false;

  @override
  Widget build(BuildContext context){


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
        navigateToEditeToDosPage('Add New ToDo');
        break;
    }
  }

  calenderShowMethod(){}

  defaultEmptyMethod(){}

  bodyContent(){
    return ListView.builder(

      itemCount: 1,
      itemBuilder:(BuildContext context,int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            // Leading
            leading: Checkbox(
              value: currentCheckBoxValue, 
              onChanged: (value){
                setState(() {
                  currentCheckBoxValue = value!;
                });
                print(value);
              }
            ),

            // Main Title
            title:const Text(
              'Task 1',
              style: TextStyle(
                fontSize: 20.0
              ),
            ),

            // Trailing
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.av_timer,
                ),
                Text('10:10'),
              ],
            ),
          ),
        );
      },
    );
  }

  navigateToEditeToDosPage(String title){
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute(title,'toRight','AddTask',ToDo(0, '', 'Low', '')));
  }

  // navigateToHomePage(){}
  
}