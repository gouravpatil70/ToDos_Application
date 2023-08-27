import 'package:flutter/material.dart';
import '../Component/Components.dart';
import '../Animations/PageChangeAnimation.dart';
import '../Utils/AppColors.dart';
import '../Utils/DatabaseHelper.dart';
import '../Utils/todo.dart';

class AddTask extends StatefulWidget {
  final String title;
  final ToDo todoObject;
  const AddTask({super.key, required this.title, required this.todoObject});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  int currentIndex = 1;
  final GlobalKey<FormState> _key = GlobalKey();
  var currentPriority;
  var noteTitle;

  @override
  void initState() {
    super.initState();
    currentPriority  = widget.todoObject.priority;
    noteTitle = widget.todoObject.title;
  }

  // Objects
  // ToDo todoObject = ToDo();
  final DatabaseHelper _helperObject = DatabaseHelper();
  
  
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
                child: Components.textFormFieldWidget(noteTitle,methodOfTextField),
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

  methodOfTextField(String input){
    setState(() {
      noteTitle = input;
    });
  }

  navigateToHomePage(){
    Navigator.of(context).pushReplacement(PageChangeAnimation.createRoute('-', 'toLeft', '/',''));
  }

  changeToDoPriority(String changedPriority){
    setState(() {
      currentPriority = changedPriority;
    });
  }

  onSaveMethod()async{
      if(_key.currentState!.validate()){
        _key.currentState!.save();
        // print(todoObject.priority);
        // print(todoObject.title);
        // print(todoObject.date);
        
        widget.todoObject.priority = currentPriority;
        widget.todoObject.title = noteTitle;
        widget.todoObject.date = DateTime.now().toString().substring(0,11);

        var result = await _helperObject.insertIntoTable(widget.todoObject);
        if(result > 0){
          print(result);
          showDialogBox('Success','Data Saved');
        }else{
          showDialogBox('Error','Something was wrong');
        }
      }
  }

  onDeleteMethod(){
    // if()
  }

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