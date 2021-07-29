import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/constants.dart';

import 'tasks_screen.dart';
import 'archive_screen.dart';
import 'done_screen.dart';

import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  Database? database;
  bool isBottomSheetShown = false;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  List<Widget> screensWidget = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks",
  ];

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: tasks.length > 0 ? screensWidget[currentIndex] : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task_alt_outlined,
            ),
            label: "Task",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.done_outline,
              ),
              label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: "Archive"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                retrieveDataFromDatabase(database).then((value) {
                  Navigator.of(context).pop();
                  setState(() {
                    tasks = value;
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    isBottomSheetShown = false;
                  });
                });
              });
            }
          } else {
            isBottomSheetShown = true;
            scaffoldKey.currentState!.showBottomSheet((context) => Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                              labelText: "New Task",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefix: Icon(Icons.title)),
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return "Enter the Task";
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: timeController,
                          decoration: InputDecoration(
                              labelText: "Task Time",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefix: Icon(Icons.watch_later)),
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              timeController.text =
                                  value!.format(context).toString();
                            });
                          },
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return "Enter the Time";
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                              labelText: "Task Date",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefix: Icon(Icons.calendar_today)),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse("2021-11-21"),
                            ).then((value) {
                              dateController.text =
                                  DateFormat.yMMMEd().format(value!);
                            });
                          },
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return "Enter the Date";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ));
          }
        },
      ),
    );
  }

  Future<void> createDatabase() async {
    database = await openDatabase(
        "todo.db",
        version: 1,
        onCreate: (Database db, version) async {
      db
          .execute(
              "CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
          .then((value) => print("Database created"))
          .catchError((error) {
        print("some thing went wring! when created ${error.toString()}");
      });
    }, onOpen: (db) {
      retrieveDataFromDatabase(db).then((value){
        tasks = value;
      });
    });
  }

  Future<void> insertDatabase({
    @required String ? title,
    @required String ? date,
    @required String ? time,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              "INSERT INTO Tasks (title, date, time, status) VALUES ('$title','$date','$time','new')")
          .then((value) {
        print("$value Inserted Successfully");
      }).catchError((err) {
        print("Some thing went wrong when inserted! ${err.toString()}");
      });
    });
  }

  Future<List<Map>> retrieveDataFromDatabase (db) async{
    return await db!.rawQuery("SELECT * FROM Tasks");
  }
}
