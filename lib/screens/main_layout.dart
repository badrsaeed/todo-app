import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/constants.dart';
import 'package:todo_app/stateManagement/cubit.dart';
import 'package:todo_app/stateManagement/states.dart';

import 'package:intl/intl.dart';

class MainLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit _cubit = AppCubit().get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                _cubit.titles[_cubit.currentIndex],
              ),
            ),
            body: _cubit.tasks.length > 0
                ? _cubit.screensWidget[_cubit.currentIndex]
                : Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _cubit.currentIndex,
              onTap: (index) {
                _cubit.changeScreenIndex(index);
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
                if (_cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    _cubit.insertDatabase(
                      title: _cubit.titleController.text,
                      time: _cubit.timeController.text,
                      date: _cubit.dateController.text,
                    );
                  }
                } else {
                  _cubit.changeBottomNavState(true);
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _cubit.titleController,
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
                                controller: _cubit.timeController,
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
                                    _cubit.timeController.text =
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
                                controller: _cubit.dateController,
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
                                    _cubit.dateController.text =
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
        },
      ),
    );
  }
}
