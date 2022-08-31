import 'package:flutter/material.dart';
import 'package:gdg_state_management/todo/product/locale_keys.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tittle.value),
      ),
      bottomNavigationBar: ElevatedButton(onPressed: (() {}), child: Text(LocaleKeys.buttonText.value)),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: ((context, index) {
            return Column(
              children: const [
                Placeholder(
                  fallbackHeight: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Events"),
                )
              ],
            );
          })),
    );
  }
}
