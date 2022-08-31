import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdg_state_management/todo/product/locale_keys.dart';
import 'package:kartal/kartal.dart';
import 'package:vexana/vexana.dart';

import '../cubit/todo_cubit.dart';
import '../model/todo_model.dart';
import '../service/todo_service.dart';
import 'completed_page.dart';

class TodoView3 extends StatefulWidget {
  const TodoView3({Key? key}) : super(key: key);

  @override
  State<TodoView3> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView3> {
  late final ToDoService toDoService;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    toDoService =
        ToDoService(NetworkManager(options: BaseOptions(baseUrl: 'https://blocexamp-default-rtdb.firebaseio.com/')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(toDoService: toDoService),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.tittle.value),
          actions: const [_LoadingCircular()],
        ),
        bottomNavigationBar: const _nextPage(),
        body: const _ToDoGird(),
      ),
    );
  }
}

class _nextPage extends StatelessWidget {
  const _nextPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state) {
        if (state is ToDoFinished) {
          context.navigateToPage(const CongratsPage(), type: SlideType.BOTTOM);
        }
      },
      builder: (context, state) {
        final isVisibleButton = context.watch<TodoCubit>().selectedItems.length < 4;

        return ElevatedButton(
            onPressed: isVisibleButton
                ? null
                : () {
                    context.read<TodoCubit>().onCompleted();
                  },
            child: Text(LocaleKeys.buttonText.value));
      },
    );
  }
}

class _ToDoGird extends StatelessWidget {
  const _ToDoGird({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoCubit, TodoState, List<TodoModel>>(
      selector: (state) {
        return state is ToDoSelectedItems ? state.items : context.read<TodoCubit>().selectedItems;
      },
      builder: (context, state) {
        return _TodoCard(selectedItem: state);
      },
    );
  }
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    Key? key,
    required this.selectedItem,
  }) : super(key: key);

  final List<TodoModel> selectedItem;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoCubit, TodoState, List<TodoModel>>(
      selector: (state) {
        return state is ToDoFinished ? state.items : context.read<TodoCubit>().toDoModelItems;
      },
      builder: (context, state) {
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: state.length,
            itemBuilder: ((context, index) {
              return _ToDo(
                onPressed: () {
                  context.read<TodoCubit>().updateItems(state[index]);
                },
                isSelected: selectedItem.contains(state[index]),
                todoModel: state[index],
              );
            }));
      },
    );
  }
}

class _LoadingCircular extends StatelessWidget {
  const _LoadingCircular({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state is ToDoLoading && state.value) {
          return const CircularProgressIndicator();
        }
        return const SizedBox();
      },
    ));
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
