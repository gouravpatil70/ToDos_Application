import 'package:flutter/material.dart';
import 'package:todo_app/Utils/AppColors.dart';
import '../Component/app_components.dart';
import '../Utils/user_settings.dart';
import '../Utils/database_helper_settings.dart';
import 'package:sqflite/sqflite.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  // Object Creation
  final DatabaseHelperSettings _helperSettingsObject = DatabaseHelperSettings();
  final UserSettings _userSettings = UserSettings();

  var currentPriority;
  var userSettingsList;
  String currentNavigationBar = 'curvedBottomNavigatorBar';
  List<String> dropDownItemsListForPriority = <String>['Low','Medium','High'];
  List<String> dropDownItemsListForBottomNavigation = <String>['simpleBottomNavigationBar','curvedBottomNavigatorBar'];

  @override
  void initState() {
    super.initState();
    currentPriority = convertToString(3);
  }

  @override
  Widget build(BuildContext context){
    if(userSettingsList == null){
      userSettingsList = <UserSettings>[];
      userSettingsTable();
    }
    return Scaffold(
      appBar: Components.customAppBarMethod('Settings', false, defaultMethod),
      drawer: Components.appDrawer(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 40,left: 20.0, right:20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Changing the Default Priority
            Row(
              children: [
                Components.textWidget('Default Priority'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Components.dropDownButtonWidget(currentPriority, changedPriority,dropDownItemsListForPriority),
                  ),                  
                )
              ],
            ),

            // Changing the Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Components.textWidget('Default Bottom Navigation'),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Components.dropDownButtonWidget(currentNavigationBar, changedBottomNavigationBar, dropDownItemsListForBottomNavigation)
            ),           

            Padding(
              padding: const EdgeInsets.only(top: 320.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Components.buttonWidget(AppColors.saveButtonColor, 'Save', onSave),
                ],
              ),
            )



          ],
        ),
      ),
    );
  }

  defaultMethod(){}

  onSave()async{
    _userSettings.srno = 1;
    _userSettings.defaultPriority = convertToInt(currentPriority);
    _userSettings.bottomNavigationBar = currentNavigationBar;

    int result = await _helperSettingsObject.updatesSettingsTableValue(_userSettings);

    if(result > 0){
      print(result);
      showDialogBox('Success','Data Changed Successfully');
    }else{
      showDialogBox('Error','Something was wrong');
    }
  }

  changedPriority(String newValue){
    setState(() {
      currentPriority = newValue;
    });
  }
  changedBottomNavigationBar(String newValue){
    setState(() {
      currentNavigationBar = newValue;
    });
  }

  convertToString(int value){
    switch (value) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  convertToInt(String value){
    switch (value) {
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      default:
        return 3;
    }
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

  userSettingsTable(){
    Future<Database> dbFuture = _helperSettingsObject.initializeDatabase();
    dbFuture.then((value)async{
      List<UserSettings> userSettingsList = await _helperSettingsObject.getObjectList();

      setState(() {
        this.userSettingsList = userSettingsList;
        currentPriority = convertToString(userSettingsList[0].defaultPriority);
        currentNavigationBar = userSettingsList[0].bottomNavigationBar;
      });
    });
  }


}