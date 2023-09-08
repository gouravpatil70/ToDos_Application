import 'package:flutter/material.dart';
import '../Component/app_components.dart';
class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  String currentPriority = 'Low';
  String currentNavigationBar = 'curvedBottomNavigatorBar';
  List<String> dropDownItemsListForPriority = <String>['Low','Medium','High'];
  List<String> dropDownItemsListForBottomNavigation = <String>['simpleBottomNavigationBar','curvedBottomNavigatorBar'];

  @override
  Widget build(BuildContext context){
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

          ],
        ),
      ),
    );
  }

  defaultMethod(){}

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
}