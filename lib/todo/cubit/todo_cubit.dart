import 'package:bloc/bloc.dart';
import 'package:gdg_state_management/todo/service/todo_service.dart';
import 'package:meta/meta.dart';

import '../model/todo_model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit({required this.toDoService}) : super(ToDoLoading(true)) {
    fetchItems();
  }
  final ToDoService toDoService;
  List<TodoModel> toDoModelItems = [];
  List<TodoModel> selectedItems = [];

  void changeLoading(bool isLoading) {
    emit(ToDoLoading(isLoading));
  }

  Future<void> fetchItems() async {
    final response = await toDoService.fetchToDoItems();
    toDoModelItems = response;
    emit(ToDoLoaded(response));
    changeLoading(false);
  }

  void updateItems(TodoModel model) {
    if (selectedItems.contains(model)) {
      selectedItems.remove(model);
    } else {
      selectedItems.add(model);
    }
    final newItems = selectedItems.toList();
    emit(ToDoSelectedItems(newItems));
  }

  void onCompleted() {
    emit(ToDoFinished(selectedItems));
  }
}
