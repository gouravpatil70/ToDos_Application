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
  String currentPriority = 'High';
  String noteTitle = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: Components.customAppBarMethod(widget.title, false, defaultEmptyMethod),
      backgroundColor: AppColors.appBackgroundColor,
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              // For the Priority Text & their DropDownManuItem
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 10.0),
                    child: Components.textWidget('Priority'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 40.0, 10.0),
                      child: Components.dropDownButtonWidget(currentPriority,changeToDoPriority),
                    ),
                  )
                ],
              ),
        
        
              // For the Task Title
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 10.0),
                child: Components.textWidget('Task Title'),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                child: Components.textFormFieldWidget(noteTitle),
              ),


              // Buttons 
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Components.buttonWidget(AppColors.saveButtonColor,'Save', onSaveMethod),
                    Components.buttonWidget(AppColors.deleteButtonColor,'Delete', onDeleteMethod),
                  ],
                ),
              )
            ],
          ),
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

  changeToDoPriority(String changedPriority){
    setState(() {
      currentPriority = changedPriority;
    });
  }

  onSaveMethod(){
      if(_key.currentState!.validate()){
        _key.currentState!.save();
        showDialogBox('Success','Data Saved');
      }
  }
  onDeleteMethod(){}

  showDialogBox(String title, String content){
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0)
          ),
          title: Text(
            title
          ),
          content: Text(
            content
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              style: TextButton.styleFrom(
                backgroundColor: AppColors.appPrimaryColor,
              ),
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: AppColors.textWhiteColor,
                ),
              ),
            )
          ],
        );
      }
    );
  }
  defaultEmptyMethod(){}
}