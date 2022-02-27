import 'package:flutter/material.dart';
import 'package:to_do/screens/todoentry_screen.dart';
import 'package:to_do/screens/todolist_screen1.dart';
import 'package:to_do/screens/todotasks_screen.dart';
import 'package:to_do/screens/todotasksentry_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoList',
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyanAccent
      ),
      home: ToDoList(),
    );
  }

}