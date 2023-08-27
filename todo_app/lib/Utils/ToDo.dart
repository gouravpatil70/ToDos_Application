class ToDo{

  var _id;
  var _title;
  var _priority;
  var _markAsDone = 'false';
  var _date;


  ToDo(this._id,this._title,this._priority,this._date);


  // Getters
  int get id => _id;

  String get title => _title;

  String get priority => _priority;

  String get date => _date;

  String get markAsDone => _markAsDone;


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

  set markAsDone(String newMarkAsDone){
    _date = newMarkAsDone;
  }
  

  // toMap
  Map<String,dynamic> convertToMapObject(){
    Map<String,dynamic> map = <String,dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['priority'] = _priority;
    map['markAsDone'] = _markAsDone;
    map['date'] = _date;
    return map;
  }

  // From Map Object
  ToDo.fromMap(Map<String,dynamic> map){
    _id = map['id'];
    _title = map['title'];
    _priority = map['priority'];
    _markAsDone = map['markAsDone'];
    _date = map['date'];
  }
  
}