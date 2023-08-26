class ToDo{

  var _id;
  var _title;
  var _priority;
  var _date;



  ToDo();

  // Getters
  int get id => _id;

  String get title => _title;

  String get priority => _priority;

  String get date => _date;


  // Setters
  set id(int newId){
    _id = newId;
  }

  set title(String newtitle){
    _title = newtitle;
  }

  set priority(String newPriority){
    _priority = newPriority;
  }

  set date(String neDate){
    _date = neDate;
  }
  

  // toMap
  Map<String,dynamic> convertToMapObject(){
    Map<String,dynamic> map = <String,dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  // From Map Object
  ToDo.fromMap(Map<String,dynamic> map){
    _id = map['id'];
    _title = map['title'];
    _priority = map['priority'];
    _date = map['date'];
  }
  
}