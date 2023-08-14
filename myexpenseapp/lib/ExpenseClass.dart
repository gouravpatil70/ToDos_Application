class Expenses{
  var _id = 0;
  var _reason;
  var _rupees;
  var _mode = 'Debit';
  var _date;

  // Constructors
  Expenses(this._reason,this._rupees,this._mode,this._date);
  Expenses.withId(this._id,this._reason,this._rupees,this._mode,this._date);

  // Getters
  int get id => _id;
  String get reason => _reason;
  int get rupees => _rupees;
  String get mode => _mode;
  String get date => _date;


  // Setters
  set id(int newId){
    _id = newId;
  }
  set reason(String newReason){
    _reason = newReason;
  }
  set rupees(int newRupees){
    _rupees = newRupees;
  }
  set mode(String newMode){
    _mode = newMode;
  }
  set date(String newDate){
    _date = newDate;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{};
    map['id'] = _id;
    map['reason'] = _reason;
    map['rupees'] = _rupees;
    map['mode'] = _mode;
    map['date'] = _date;

    return map;
  }


  Expenses.fromMapObject(Map<String,dynamic> map){
    _id = map['id'];
    _reason = map['reason'];
    _rupees = map['rupees'];
    _mode = map['mode'];
    _date = map['date'];
  }

}