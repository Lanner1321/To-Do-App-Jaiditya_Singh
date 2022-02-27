import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/todolist.dart';
import 'package:to_do/utils/helper1.dart';
import 'package:to_do/screens/todolist_screen1.dart';

class ToDoEntry extends StatefulWidget {
  late final ToDoList1 todo;

  ToDoEntry(this.todo);

  @override
  State<StatefulWidget> createState() {
    return ToDoEntryState(this.todo);
  }
}

class ToDoEntryState extends State<ToDoEntry> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper1 helper1 = DatabaseHelper1.instance;
  ToDoList1 todo;
  var value1 = "Low";
  TextEditingController titleController = TextEditingController();
  ToDoEntryState(this.todo);

  //get todolist_screen1 => todolist_screen1;

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    return WillPopScope(
        onWillPop: () {
          MoveToSreen1();
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Add New To-Do Task",
                style: TextStyle(fontSize: 23),
              ),
              centerTitle: true,
              backgroundColor: Colors.cyan,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  MoveToSreen1();
                },
              ),
            ),
            body: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: ListView(children: [
                Padding(
                    padding: EdgeInsets.only(top: 175),
                    child: Text("Select Task Priority",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          // decoration: TextDecoration.underline
                        ))),
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: ListTile(
                        title: DropdownButton(
                      underline: SizedBox(),
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'coolvetica rg',
                          fontSize: 40),
                      value: getPriorityAsString(todo.priority),
                      onChanged: (valueselectedbyuser) {
                        setState(() {
                          debugPrint("User selected $valueselectedbyuser");
                          updatePriorityAsInt(valueselectedbyuser.toString());
                        });
                      },
                    ))),
                Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 15.0),
                    child: TextField(
                        controller: titleController,
                        style: TextStyle(
                            fontFamily: 'coolvetica rg', fontSize: 26),
                        onChanged: (value) {
                          debugPrint('Something changed in Title Text Field ');
                          updateTitle();
                        },
                        decoration: InputDecoration(
                            labelText: 'Title of the To-Do Task',
                            labelStyle: TextStyle(
                                fontFamily: 'coolvetica rg', fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))))),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          width: 20,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.cyan,
                            textColor: Colors.white,
                            child: Text(
                              'Cancel',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Cancel button clicked");
                                MoveToSreen1();
                              });
                            },
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: 15,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.cyan,
                            textColor: Colors.white,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                MoveToSreen1();
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: 20,
                        ),
                      ],
                    ))
              ]),
            )));
  }

  void MoveToSreen1() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        todo.priority = 1;
        break;
      case 'Low':
        todo.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int? value) {
    late String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of To Do object
  void updateTitle() {
    todo.title = titleController.text;
  }
  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title, textAlign:TextAlign.center,style: TextStyle(decoration: TextDecoration.underline, fontSize: 26.5),),
      content: Text(message, textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
  // Save data to database
  void _save() async {

    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
      await helper1.insertToDo(todo);

      _showAlertDialog('Status', "To-Do Task Saved Successfully \n Tap on the To-Do task to \n Change the Completion Status ");
      debugPrint("Save Success");

    }


  // void updateListView2() {
  //   final Future<Database> dbFuture = helper1.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<ToDoList1>> todolistFuture = helper1.getToDoList();
  //     todolistFuture.then((todolist) {
  //       setState(() {
  //         this.todolist = todolist;
  //         this.count = todolist.length;
  //       });
  //     });
  //   });
  // }


}
