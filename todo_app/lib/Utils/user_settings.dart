class UserSettings{

  var _srno;
  var _defaultPriority;
  var _bottomNavigationBar;
  

  UserSettings(this._srno,this._defaultPriority,this._bottomNavigationBar);

  int get srno => _srno;
  String get defaultPriority => _defaultPriority;
  String get bottomNavigationBar => _bottomNavigationBar;

  // Setters
  set srno(int newSrno){
    _srno = newSrno;
  }
  set defaultPriority(String newPriority){
    _defaultPriority = newPriority;
  }
  set bottomNavigationBar(String newNavigationBar){
    _bottomNavigationBar = newNavigationBar;
  }

  Map<String,dynamic> converToMap(){
    Map<String,dynamic> mapObject  = <String,dynamic>{};

    mapObject['srno'] = _srno;
    mapObject['defaultPriority'] = _defaultPriority;
    mapObject['defaultBottomNavigation'] = _bottomNavigationBar;

    return mapObject;
  }

  UserSettings.fromMapObject(Map<String,dynamic> mapObject){
    _srno = mapObject['srno'];
    _defaultPriority = mapObject['defaultPriority'];
    _bottomNavigationBar = mapObject['defaultBottomNavigation'];
  }
}