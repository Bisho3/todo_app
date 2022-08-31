import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo/cubit/cubit.dart';

Widget defualtFormField({
  required TextInputType Type,
  required TextEditingController Controller,
  Function? onsubmit,
  String? Function(String? val)? validate,
  IconData? pre,
  required String text,
  bool isPassword = false,
  IconData? suff,
  Function? suffpressed,
  Function? onchange,
  Function? onSubmit,
  required Function OnTap,
}) =>
    TextFormField(
      keyboardType: Type,
      controller: Controller,
      onTap: () {
        OnTap();
      },
      onFieldSubmitted: (String value) {
        onsubmit!(value);
      },
      validator: (value) {
        return validate!(value);
      },
      obscureText: isPassword,
      decoration: InputDecoration(
        label: Text(
          text,
        ),
        prefixIcon: Icon(pre),
        suffixIcon: suff != null
            ? IconButton(
                icon: Icon(
                  suff,
                ),
                onPressed: () {
                  suffpressed!();
                })
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
          5.0,
        )),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .UpdateData(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .UpdateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.get(context).DeleteData(id: model['id']);
      },
    );
Widget MyDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 10.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => MyDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet,Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
