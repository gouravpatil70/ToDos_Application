import 'package:flutter/material.dart';
import 'package:todo_app/Screens/HomePage.dart';
import '../Screens/AddTaskPage.dart';

class PageChangeAnimation{

  static Route createRoute(String title, String slidePosition, String className){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation){
        return className == 'AddTask' ? AddTask(title: title): const HomePage() ;
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context,animation,secondaryAnimation,child){
        var begin = (slidePosition == 'toRight' ? const Offset(1,0) : const Offset(-1, 0));
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve
        );
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      }
    );
  }
}