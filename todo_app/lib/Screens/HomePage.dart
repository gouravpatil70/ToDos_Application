import 'package:flutter/material.dart';
import '../Utils/AppColors.dart';
import '../Component/Components.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: Components.customAppBarMethod("ToDo's", true, calenderShowMethod),
      
    );
  }

  calenderShowMethod(){

  }
  defaultEmptyMethod(){}
}