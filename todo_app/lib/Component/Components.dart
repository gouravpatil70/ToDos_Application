import 'package:flutter/material.dart';
import '../Utils/AppColors.dart';

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
}