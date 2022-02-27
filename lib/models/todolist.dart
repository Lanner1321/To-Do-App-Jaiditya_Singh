import 'package:flutter/material.dart';

class ToDoList1 {
  int? _id;
  late String _title;
  late String _date;
  late int _priority;
  int? _done;

  ToDoList1(this._title, this._date, this._priority);

  ToDoList1.withId(this._id, this._title, this._date, this._priority);

  int? get id => _id;

  String get title => _title;

  int get priority => _priority;

  String get date => _date;

  int? get done => _done;

  set title(String newTitle) {
    if (newTitle.length <= 250) {
      this._title = newTitle;
    }
  }

  set priority(int newPriority) {
    if (newPriority! >= 1 && newPriority! <= 2) {
      this._priority = newPriority;
    }
  }

  set done(int? newDone){
    if (newDone! >=1 && newDone! <=2){
      this._done = newDone;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;}
    map['title'] = _title;
    map['priority'] = _priority;
    map['date'] = _date;
    map['done'] = _done;

    return map;
  }
  ToDoList1.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._done = map ['done'];
  }
}
