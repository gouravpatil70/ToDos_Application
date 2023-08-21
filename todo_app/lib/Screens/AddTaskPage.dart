import 'package:flutter/material.dart';
import '../Component/Components.dart';
import '../Animations/PageChangeAnimation.dart';
import '../Utils/AppColors.dart';

class AddTask extends StatefulWidget {
  final String title;
  const AddTask({super.key, required this.title});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  int currentIndex = 1;
  final GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: Components.customAppBarMethod(widget.title, false, defaultEmptyMethod),
      backgroundColor: AppColors.appBackgroundColor,
      body: Form(
        key: _key,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 40.0, 10.0),
                  child: Components.textWidget('Priority'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 10.0),
                    child: Components.dropDownButtonWidget(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute('-', 'toLeft', '/'));
  }

  defaultEmptyMethod(){}
}