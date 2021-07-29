import 'package:flutter/material.dart';
import 'package:todo_app/components/componants.dart';
import 'package:todo_app/components/constants.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => buildTaskItem(tasks[index]),
      itemCount: tasks.length,
    );
  }
}
