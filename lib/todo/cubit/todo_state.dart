part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class ToDoLoading extends TodoState {
  final bool value;
  ToDoLoading(this.value);
}

class ToDoLoaded extends TodoState {
  final List<TodoModel> items;
  ToDoLoaded(this.items);
}

class ToDoSelectedItems extends TodoState {
  final List<TodoModel> items;
  ToDoSelectedItems(this.items);
}

class ToDoFinished extends TodoState {
  final List<TodoModel> items;
  ToDoFinished(this.items);
}
