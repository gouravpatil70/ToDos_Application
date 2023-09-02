import 'package:flutter/material.dart';
import '../Utils/AppColors.dart';
import 'Screens/home_page.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
      return MaterialApp(
        title: "ToDo's App",
        theme: ThemeData(
          primarySwatch: AppColors.appPrimaryColor,
        ),
        home: const HomePage(),
      );
  }
}