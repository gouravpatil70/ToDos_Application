import 'package:flutter/material.dart';
import '../Component/app_components.dart';
class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: Components.customAppBarMethod('Settings', false, defaultMethod),
      drawer: Components.appDrawer(context),
      
    );
  }

  defaultMethod(){}
}