import 'package:flutter/material.dart';
import '../Utils/AppColors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class Components{

  static AppBar customAppBarMethod(String appBarTitle, bool isShowCalender, var calenderMethod){
    return AppBar(
      title: Text(
        appBarTitle,
        style: const TextStyle(
          color: AppColors.textWhiteColor,
        )
      ),
      actions: [
        isShowCalender 
        ? IconButton(
            onPressed: calenderMethod, 
            icon: const Icon(
              Icons.calendar_month_rounded
            )
          )
        : Container()
      ],
    );
  }


  static BottomNavigationBar customBottomNavigationBar(int currentSelectedId,var changeDisplayPage){
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[ 

          // HomePage Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'List',
          ),

          // Edit ToDo List
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_add),
            label: 'Add New Todo'
          ),
        ],
        
        // User Interaction settings
        currentIndex: currentSelectedId,
        onTap: (value) => changeDisplayPage(value),

        // Styling part
        selectedItemColor: AppColors.onSelectedBottomNavigationButton,
        backgroundColor: AppColors.appPrimaryColor,

        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(
          size: 28.0,
          
        ),
    );
  }

  // New BottomNavigatorBar 
  static CurvedNavigationBar curvedBottomNavigatorBar(int currentSelectedId,var changeDisplayPage){
    return CurvedNavigationBar(
      items: const [
        Icon(
          Icons.fact_check_outlined,
          color: Colors.white,
          size: 28.0,
        ),
        Icon(
          Icons.format_list_bulleted_add,
          color: Colors.white,
          size: 28.0
        )
      ],
      animationCurve: Curves.linear,
      backgroundColor: AppColors.appBackgroundColor,
      color: AppColors.appPrimaryColor,
      index: currentSelectedId,
      onTap: (value) => changeDisplayPage(value),
      buttonBackgroundColor: AppColors.appPrimaryColor,
    );
  }


  // Text Widget
  static textWidget(String title){
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      )
    );
  }


  // Dropdown Button
  static dropDownButtonWidget(){
    const List<String> dropDownItems = <String>['Low','Medium','High'];
    
    return DropdownButton(
      value: dropDownItems.last,
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
        color: AppColors.appPrimaryColorForWidget,
      ),
      isExpanded: true,
      underline: Container(
        height: 2,
        color: AppColors.appPrimaryColor,
      ),
      onChanged: (value){
        
      },
      items: dropDownItems.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList() , 
    );
  }

}