import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: Components.customAppBarMethod("ToDo's", true, calenderShowMethod),
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

  navigateToEditeToDosPage(String title){
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute(title,'toLeft','AddTask'));
  }

  // navigateToHomePage(){}
  
}