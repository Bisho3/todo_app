import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo/cubit/cubit.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';
import 'package:todo_app/shared/components/component/component.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).newdone;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
