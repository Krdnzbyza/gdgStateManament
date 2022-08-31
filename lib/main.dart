import 'package:flutter/material.dart';
import 'package:gdg_state_management/todo/view/todo_view4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const TodoView3(),
    );
  }
}
