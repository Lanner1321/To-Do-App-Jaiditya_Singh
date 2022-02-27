import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:to_do/models/todolist.dart';

class DatabaseHelper1 {
  // static DatabaseHelper1 _databaseHelper1;
  // DatabaseHelper1._createInstance();
  DatabaseHelper1._();
  static final DatabaseHelper1 instance = DatabaseHelper1._();


  String todolistTable = 'todolist_table';
  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
  String colDate = 'date';
  String colDone = 'done';



  // factory DatabaseHelper1() {
  //   if (_databaseHelper1 == null) {
  //     _databaseHelper1 = DatabaseHelper1._createInstance();
  //   }
  //   return _databaseHelper1;
  // }
  static  Database? _database;
  Future<Database> get database async =>
    _database ??= await initializeDatabase();


  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';

    var todoDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $todolistTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colDone INTEGER DEFAULT 1,$colTitle TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // Fetch Operation: Get all to do objects from database
  Future<List<Map<String, dynamic>>> getToDoMapList() async {
    Database db = await this.database;
    var result = await db.query(todolistTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a to do object to database
  Future<int> insertToDo(ToDoList1 todo) async {
    Database db = await this.database;
    var result = await db.insert(todolistTable, todo.toMap());
    return result;
  }
  // Update Operation: Update a to do object and save it to database
  Future<int> updateToDo(ToDoList1 todo) async {
    var db = await this.database;
    var result = await db.update(todolistTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  // Delete Operation: Delete a to do object from database
  Future<int> deleteToDo(int? id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $todolistTable WHERE $colId = $id');
    return result;
  }

  // Get number of to do objects in database
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $todolistTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'to do List' [ List<ToDoList1> ]
  Future<List<ToDoList1>> getToDoList() async {
    var todoMapList = await getToDoMapList(); // Get 'Map List' from database
    int count =
        todoMapList.length; // Count the number of map entries in db table

    List<ToDoList1> todoList = List<ToDoList1>.empty(growable: true);
    // For loop to create a 'ToDoList1 List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(ToDoList1.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }
}
