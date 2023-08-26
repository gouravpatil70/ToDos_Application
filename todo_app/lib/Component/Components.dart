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
  static dropDownButtonWidget(String currentPriority,var changedPriority){
    const List<String> dropDownItems = <String>['Low','Medium','High'];
    
    return DropdownButton(
      value: currentPriority,
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
        changedPriority(value);
      },
      items: dropDownItems.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.dropDownMenuItemColor,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
          ),
        );
        
      }).toList() , 
    );
  }

  static TextFormField textFormFieldWidget(String dataVariable, var methodOfTextField){
    return TextFormField(
      validator: (input){
        if(input!.isEmpty){
          return 'Please provide title here';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      maxLines: 8,
      maxLength: 100,
      onChanged: (input)=> methodOfTextField(input),
    );
  }

  static buttonWidget(Color buttonColor,String buttonName, var actionMethod){
    return ElevatedButton(
      onPressed: (){
        actionMethod();
      }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0)
      ),

      child: Text(
        buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0
        )
      )
    );
  }

}