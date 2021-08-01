import 'package:flutter/material.dart';


import 'package:todo_app/screens/archive_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';
import 'package:todo_app/stateManagement/states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  //Create object
  AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  bool isBottomSheetShown = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<Map> tasks = [];
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


  void changeScreenIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavigationBarIndex());
  }

  void clearTextField() {
    titleController.clear();
    timeController.clear();
    dateController.clear();
    emit(ClearTextFormField());
  }

  void changeBottomNavState(bool state) {
    isBottomSheetShown = state;
    emit(ChangeBottomNavState());
  }
  void createDatabase() {
    openDatabase("todo.db", version: 1,
        onCreate: (Database db, version) async {
          db
              .execute(
              "CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
              .then((value) => print("Database created"))
              .catchError((error) {
            print("some thing went wring! when created ${error.toString()}");
          });
        }, onOpen: (db) {
          retrieveDataFromDatabase(db).then((value) {
            print("Database Opened");
            tasks = value;
            print(tasks);
            emit(AppRetrieveDatabase());
          });
        }).then((value) {
          database = value;
          emit(AppCreateDatabase());
    });
  }

  Future<void> insertDatabase({
    @required String? title,
    @required String? date,
    @required String? time,
  }) async {
    await database!.transaction((txn) async {
      txn.rawInsert(
          "INSERT INTO Tasks (title, date, time, status) VALUES ('$title','$date','$time','new')")
          .then((value) {
        print("$value Inserted Successfully");
        emit(AppInsertDatabase());

        retrieveDataFromDatabase(database).then((value) {
          print("Database Opened");
          tasks = value;
          print(tasks);
          emit(AppRetrieveDatabase());
        });

      }).catchError((err) {
        print("Some thing went wrong when inserted! ${err.toString()}");
      });
    });
  }

  Future<List<Map>> retrieveDataFromDatabase(db) async {
    return await db!.rawQuery("SELECT * FROM Tasks");
  }

}
