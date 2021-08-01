import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/main_layout.dart';

import 'bloc_observe.dart';


void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainLayout(),
    );
  }
}
