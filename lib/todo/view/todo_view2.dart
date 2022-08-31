import 'package:flutter/material.dart';
import 'package:gdg_state_management/todo/product/locale_keys.dart';
import 'package:vexana/vexana.dart';

import '../model/todo_model.dart';
import '../service/todo_service.dart';

class TodoView2 extends StatefulWidget {
  const TodoView2({Key? key}) : super(key: key);

  @override
  State<TodoView2> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView2> {
  late final ToDoService toDoService;
  List<TodoModel> toDoModelItems = [];
  final List<TodoModel> selectedItems = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    toDoService =
        ToDoService(NetworkManager(options: BaseOptions(baseUrl: 'https://blocexamp-default-rtdb.firebaseio.com/')));
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response = await toDoService.fetchToDoItems();
    toDoModelItems = response;
    changeLoading();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void updateItems(TodoModel model) {
    if (selectedItems.contains(model)) {
      selectedItems.remove(model);
    } else {
      selectedItems.add(model);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tittle.value),
        actions: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
      bottomNavigationBar:
          ElevatedButton(onPressed: selectedItems.length < 4 ? null : () {}, child: Text(LocaleKeys.buttonText.value)),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: toDoModelItems.length,
          itemBuilder: ((context, index) {
            return _ToDo(
              onPressed: () {
                updateItems(toDoModelItems[index]);
              },
              isSelected: selectedItems.contains(toDoModelItems[index]),
              todoModel: toDoModelItems[index],
            );
          })),
    );
  }
}

class _ToDo extends StatelessWidget {
  _ToDo({
    Key? key,
    required this.todoModel,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);
  TodoModel todoModel;
  final VoidCallback onPressed;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: isSelected ? Border.all(color: Theme.of(context).errorColor) : null),
      child: IconButton(
        onPressed: onPressed,
        icon: Column(
          children: [
            Visibility(
                visible: todoModel.imageUrl != null && todoModel.imageUrl!.isNotEmpty,
                replacement: const FlutterLogo(),
                child: Image.network(todoModel.imageUrl ?? '')),
            // Image.network(todoModel.imageUrl ?? ''),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(todoModel.title ?? ''),
            )
          ],
        ),
      ),
    );
  }
}
