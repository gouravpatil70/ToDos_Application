import 'package:flutter/material.dart';
import 'HomePage.dart';
import '../Component/Components.dart';

class AddTask extends StatefulWidget {
  final String title;
  const AddTask({super.key, required this.title});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  int currentIndex = 1;
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: Components.customAppBarMethod(widget.title, false, defaultEmptyMethod),

      bottomNavigationBar: Components.customBottomNavigationBar(currentIndex, changeDisplayPage),
    );
    
  }

  changeDisplayPage(int value){
    setState(() {
      currentIndex = value;
    });
    switch(value){
      case 0:
        navigateToHomePage();
        break;
      case 1:
        break;
    }
  }

  navigateToHomePage(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
      return const HomePage();
    }));
  }

  defaultEmptyMethod(){}
}