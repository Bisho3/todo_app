import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/todo/cubit/cubit.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';
import 'package:todo_app/shared/components/component/component.dart';

class ToDoScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var datecontroller = TextEditingController();

  ToDoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = TodoCubit.get(context);
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..CreateDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('${cubit.appbar[cubit.currentindex]}'),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.Screen[cubit.currentindex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.InsertToDatabase(
                        title: titleController.text,
                        date: datecontroller.text,
                        time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defualtFormField(
                                    Type: TextInputType.text,
                                    Controller: titleController,
                                    pre: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Title';
                                      }
                                      return null;
                                    },
                                    text: 'Task Title',
                                    OnTap: () {
                                      print('timmed tapped');
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defualtFormField(
                                    Type: TextInputType.datetime,
                                    Controller: timeController,
                                    pre: Icons.watch_later_outlined,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Time';
                                      }
                                      return null;
                                    },
                                    text: 'Task Time',
                                    OnTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defualtFormField(
                                      Type: TextInputType.datetime,
                                      Controller: datecontroller,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Must Enter Your Date';
                                        }
                                        return null;
                                      },
                                      text: 'Task Date',
                                      pre: Icons.calendar_month_outlined,
                                      OnTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2222-12-21'),
                                        ).then((value) {
                                          datecontroller.text =
                                              DateFormat.yMMMd().format(value!);
                                          print(
                                              DateFormat.yMMMd().format(value));
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.febicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.chageBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//
//
// void createDatabase() async {
//   database = await openDatabase('todo.db', version: 1,
//       onCreate: (database, version) async {
//         print('Database Created Bisho');
//         await database
//             .execute(
//             'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT)')
//             .then((value) {
//           print('Table Created ya Bisho');
//         }).catchError((error) {
//           print('Error Creating in Table ${error.toString()}');
//         });
//       }, onOpen: (database) {
//         print('Database Opend Successfully');
//         getDataFromDatabase(database).then((value) {
//           tasks = value;
//           print(tasks);
//         });
//       });
// }
//
// Future insertToDatabase({
//   required String title,
//   required String date,
//   required String time,
// }) async {
//   return await database.transaction((txn) async {
//     await txn
//         .rawInsert(
//         'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","New")')
//         .then((value) {
//       print('$value Inserted Successfully Bisho');
//     }).catchError((error) {
//       print('Error When Inserting NEW Record ${error.toString()}');
//     });
//   });
// }
//
// Future<List<Map>> getDataFromDatabase(database) async {
//   return await database.rawQuery('SELECT * FROM tasks');
// }}
