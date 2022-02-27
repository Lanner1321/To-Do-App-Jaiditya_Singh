import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/main.dart';
import 'package:to_do/screens/todoentry_screen.dart';
import 'package:to_do/utils/helper1.dart';

import '../models/todolist.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ToDoListState();
  }
}

class ToDoListState extends State<ToDoList> {
  DatabaseHelper1 databaseHelper1 = DatabaseHelper1.instance;
  List<ToDoList1>? todolist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todolist == null) {
      todolist = <ToDoList1>[];
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "To-Do List",
            style: TextStyle(fontSize: 23),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () {
            debugPrint("FAB pressed");
            navigateToScreen2(ToDoList1('','',2));
          },
          child: Icon(Icons.add, color: Colors.white, size: 28),
          tooltip: "Add To-Task",
        ),
        body: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: getToDoList()));
  }

  ListView getToDoList() {

    TextStyle titleStylenotdone = TextStyle(fontFamily: 'coolvetica rg', fontSize: 20);
    TextStyle tileStyledone = TextStyle(fontFamily: 'coolvetica rg', fontSize: 20,decoration: TextDecoration.lineThrough, decorationThickness: 3.75);
    TextStyle card= titleStylenotdone;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        TextStyle card= titleStylenotdone;
        return Card(
          color: Colors.black,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundColor:
                  getPriorityColor(this.todolist![position].priority),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            title: Text(
              this.todolist![position].title,
              style: getStyle(this.todolist![position].done),
            ),
            subtitle: Text(this.todolist![position].date,
                style: TextStyle(fontFamily: 'coolvetica rg', fontSize: 15)),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size:27.5,
              ),
              onTap: () {
                //debugPrint("Del was tapped");
                _delete(context, todolist![position]);
                updateListView();
              },
            ),
            onTap: () {
              setState(() {
                if (this.todolist![position].done==null){
                this.todolist![position].done=2;}
                updateDone(this.todolist![position]);
                update(this.todolist![position]);
                updateListView();
                debugPrint("List tile was tapped");
                _showSnackBar(context, 'Task Completion Status Changed');
                // int? r= this.todolist![position].done;
                // debugPrint(r.toString());
              });

            },
          ),
        );
      },
    );
  }

// Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.purpleAccent;
        break;
      case 2:
        return Colors.lightGreenAccent;
        break;

      default:
        return Colors.lightGreenAccent;
    }
  }

  TextStyle getStyle(int? done){
    switch (done){
      case 2:
        return TextStyle(fontFamily: 'coolvetica rg', fontSize: 20);
        break;
      case 1:
        return TextStyle(fontFamily: 'coolvetica rg', fontSize: 20,decoration: TextDecoration.lineThrough, decorationThickness: 3.75);
        break;
      default:
        return TextStyle(fontFamily: 'coolvetica rg', fontSize: 20);
    }
  }

  void updateDone(ToDoList1 todo){
    if(todo.done==1){
      todo.done=2;
    }
    else if (todo.done==2){
      todo.done=1;
    }
    else if (todo.done== null){
      todo.done==2;
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper1.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ToDoList1>> todolistFuture = databaseHelper1.getToDoList();
      todolistFuture.then((todolist) {
        setState(() {
          this.todolist = todolist;
          this.count = todolist.length;
        });
      });
    });
  }

  void _delete(BuildContext context, ToDoList1 todo) async {
    int result = await databaseHelper1.deleteToDo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'To-Do Task Deleted Successfully');
      //updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToScreen2(ToDoList1 todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return ToDoEntry(todo);
    }));
    if (result == true) {
      updateListView();
    }
  }
  void update(ToDoList1 todo) async{
    int result;
    result= await databaseHelper1.updateToDo(todo);
    // _showSnackBar(context, 'Task Completion Status Changed');
  }
}
