import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/components/componants.dart';
import 'package:todo_app/stateManagement/cubit.dart';
import 'package:todo_app/stateManagement/states.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder:(context, state) {
        var tasks = AppCubit().get(context).tasks;
        return ListView.builder(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        itemCount: tasks.length,
      );
      },
    );
  }
}
